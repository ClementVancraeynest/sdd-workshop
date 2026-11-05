// vectors: search by meaning for the workshop's memory, with a small model on this laptop.
// No server, no download, no library to install: one file for each system, and the model.
// memory/memory.sh calls it; sqlite3 keeps the pieces and their vectors.
//
//	vectors embed <model> [table]  stdin: [{"id":1,"col":"agent_text","title":"...",
//	                               "at":"2026-10-31 20:21","text":"..."}] as sqlite3 -json
//	                               prints. stdout: the SQL that stores the vectors of each
//	                               text in table (vectors when not given), one per window
//	vectors near <model> <k> <q>   stdin: [{"id":1,"part":0,"v":"<hex>"}], the stored vectors
//	                               stdout: the k rows closest to the question, by their best
//	                               window, "id<TAB>part<TAB>score"
//	vectors events <id> <kind> <title>
//	                               stdin: a Copilot conversation, one event per line
//	                               stdout: the SQL that stores it as La Roca's corpus does:
//	                               sessions, exchanges, tool_uses, thinking_blocks (events.go)
//
// A text is read for meaning as La Roca reads its corpus (plugins/vector/internal/vector/
// chunk.go): each column on its own (what the human said, what the agent answered), cut in
// overlapping windows, each window with "[title · month] " in front. La Roca's windows are
// 250 words that overlap by 100, for a model that reads 512 tokens (nomic-embed-text-v2,
// internal/model/manifest.go). MiniLM reads 256, and agent prose (file names, code) takes
// about two tokens a word: so here a window is 100 words that overlap by 40, the same share,
// and windows_test.go checks it fits. A window of 250 words is over 300 tokens, and
// MiniLM would never read its end: on 1 November a worker's whole answer was one vector,
// read up to the brief, and its words were never found.
// A vector is stored as 384 bytes, each number times 127, with the window it was made from.
// The score is the cosine: 1 is the same meaning, 0 nothing in common.
package main

import (
	"bufio"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"math"
	"os"
	"runtime"
	"sort"
	"strconv"
	"strings"
	"sync"
	"time"
	"unicode"
	"unicode/utf8"
)

const (
	windowWords  = 100 // La Roca's defaultChunkTokens (250), cut to what MiniLM reads of agent prose
	overlapWords = 40  // La Roca's defaultOverlapTokens (100), the same share of a window
	titleRunes   = 80  // as La Roca: maxChunkContextRunes
)

// windows: the text cut in windows of size words that overlap by overlap words; the text
// itself when it is not longer than one window (La Roca's tokenChunks).
func windows(text string, size, overlap int) []string {
	var spans [][2]int
	start := -1
	for i := 0; i < len(text); {
		r, w := utf8.DecodeRuneInString(text[i:])
		if unicode.IsSpace(r) {
			if start >= 0 {
				spans = append(spans, [2]int{start, i})
				start = -1
			}
		} else if start < 0 {
			start = i
		}
		i += w
	}
	if start >= 0 {
		spans = append(spans, [2]int{start, len(text)})
	}
	if len(spans) == 0 {
		return nil
	}
	if len(spans) <= size {
		return []string{text}
	}
	var out []string
	for s := 0; s < len(spans); s += size - overlap {
		e := min(s+size, len(spans))
		out = append(out, text[spans[s][0]:spans[e-1][1]])
		if e == len(spans) {
			break
		}
	}
	return out
}

// windowHeader: "[title · 2026-10] " in front of every window, as La Roca's chunkHeader.
func windowHeader(title, at string) string {
	title = strings.Join(strings.Fields(title), " ")
	if r := []rune(title); len(r) > titleRunes {
		title = strings.TrimSpace(string(r[:titleRunes-1])) + "…"
	}
	month := ""
	if len(at) >= 7 && at[4] == '-' {
		month = at[:7]
	}
	switch {
	case title != "" && month != "":
		return "[" + title + " · " + month + "] "
	case title != "":
		return "[" + title + "] "
	case month != "":
		return "[" + month + "] "
	}
	return ""
}

func main() {
	if len(os.Args) < 3 {
		usage()
	}
	if os.Args[1] == "events" {
		if len(os.Args) != 5 {
			usage()
		}
		events(os.Args[2], os.Args[3], os.Args[4])
		return
	}
	m, err := load(os.Args[2])
	if err != nil {
		fail(err)
	}
	switch os.Args[1] {
	case "embed":
		table := "vectors"
		if len(os.Args) > 3 {
			table = os.Args[3]
		}
		embedAll(m, table)
	case "near":
		if len(os.Args) != 5 {
			usage()
		}
		k, err := strconv.Atoi(os.Args[3])
		if err != nil || k < 1 {
			usage()
		}
		near(m, k, os.Args[4])
	default:
		usage()
	}
}

func usage() {
	fmt.Fprintln(os.Stderr, "usage: vectors embed <model> [table]   |   vectors near <model> <k> <question>   |   vectors events <session_id> <kind> <title>")
	os.Exit(2)
}

func fail(err error) {
	fmt.Fprintln(os.Stderr, "vectors:", err)
	os.Exit(1)
}

// readJSON: what sqlite3 -json printed; nothing at all when the query found no rows.
func readJSON(v any) {
	data, err := io.ReadAll(os.Stdin)
	if err != nil {
		fail(err)
	}
	if len(data) == 0 {
		return
	}
	if err := json.Unmarshal(data, v); err != nil {
		fail(fmt.Errorf("reading the pieces: %v", err))
	}
}

// embedAll: the vector of every window of every text, on all the processor's cores, in the
// order they came.
func embedAll(m *model, table string) {
	var texts []struct {
		ID    int64  `json:"id"`
		Col   string `json:"col"`
		Title string `json:"title"`
		At    string `json:"at"`
		Text  string `json:"text"`
	}
	readJSON(&texts)
	type piece struct {
		id        int64
		col, text string
		part      int
		input     string
	}
	var pieces []piece
	for _, t := range texts {
		h := windowHeader(t.Title, t.At)
		for i, w := range windows(strings.TrimSpace(t.Text), windowWords, overlapWords) {
			pieces = append(pieces, piece{t.ID, t.Col, w, i, h + w})
		}
	}
	vecs := make([][]float32, len(pieces))
	next, done := make(chan int), 0
	var mu sync.Mutex
	var wg sync.WaitGroup
	start := time.Now()
	for w := 0; w < runtime.NumCPU(); w++ {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for i := range next {
				vecs[i] = m.embed(pieces[i].input)
				mu.Lock()
				done++
				if done%100 == 0 {
					fmt.Fprintf(os.Stderr, "  reading for meaning: %d of %d, %ds\n", done, len(pieces), int(time.Since(start).Seconds()))
				}
				mu.Unlock()
			}
		}()
	}
	for i := range pieces {
		next <- i
	}
	close(next)
	wg.Wait()
	out := bufio.NewWriter(os.Stdout)
	defer out.Flush()
	fmt.Fprintln(out, "BEGIN;")
	for i, p := range pieces {
		fmt.Fprintf(out, "INSERT OR REPLACE INTO %s (id, col, part, piece, v) VALUES (%d, %s, %d, %s, X'%s');\n",
			table, p.id, quote(p.col), p.part, quote(p.text), hex.EncodeToString(bytes8(vecs[i])))
	}
	fmt.Fprintln(out, "COMMIT;")
}

func bytes8(v []float32) []byte {
	b := make([]byte, len(v))
	for i, x := range v {
		b[i] = byte(int8(math.Max(-127, math.Min(127, math.Round(float64(x)*127)))))
	}
	return b
}

// near: the k rows closest to the question's, each by its closest window.
func near(m *model, k int, question string) {
	var stored []struct {
		ID   int64  `json:"id"`
		Part int    `json:"part"`
		V    string `json:"v"`
	}
	readJSON(&stored)
	q := m.embed(question)
	type hit struct {
		id    int64
		part  int
		score float64
	}
	best := map[int64]int{}
	var hits []hit
	for _, s := range stored {
		b, err := hex.DecodeString(s.V)
		if err != nil || len(b) != len(q) {
			continue
		}
		var d, n float64
		for i, x := range b {
			v := float64(int8(x))
			d += v * float64(q[i])
			n += v * v
		}
		if n == 0 {
			continue
		}
		h := hit{s.ID, s.Part, d / math.Sqrt(n)}
		if i, ok := best[s.ID]; !ok {
			best[s.ID] = len(hits)
			hits = append(hits, h)
		} else if h.score > hits[i].score {
			hits[i] = h
		}
	}
	sort.Slice(hits, func(i, j int) bool { return hits[i].score > hits[j].score })
	if len(hits) > k {
		hits = hits[:k]
	}
	for _, h := range hits {
		fmt.Printf("%d\t%d\t%.2f\n", h.id, h.part, h.score)
	}
}

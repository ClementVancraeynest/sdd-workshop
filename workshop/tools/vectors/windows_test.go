package main

import (
	"fmt"
	"strings"
	"testing"
)

// someWords: "w0 w1 ... w<n-1>".
func someWords(n int) string {
	w := make([]string, n)
	for i := range w {
		w[i] = fmt.Sprint("w", i)
	}
	return strings.Join(w, " ")
}

// As La Roca: a text of one window or less is itself; a longer one is cut every 150 words
// into windows of 250, so each window shares 100 words with the one before, and the last
// word is always in a window.
func TestWindowsAsLaRoca(t *testing.T) {
	if got := windows(someWords(250), 250, 100); len(got) != 1 || got[0] != someWords(250) {
		t.Fatalf("250 words: %d windows, want the text itself", len(got))
	}
	got := windows(someWords(600), 250, 100)
	starts := []string{"w0 ", "w150 ", "w300 ", "w450 "}
	if len(got) != len(starts) {
		t.Fatalf("600 words: %d windows, want %d", len(got), len(starts))
	}
	for i, s := range starts {
		if !strings.HasPrefix(got[i], s) {
			t.Errorf("window %d starts %q, want %q", i, got[i][:8], s)
		}
	}
	if !strings.HasSuffix(got[len(got)-1], "w599") {
		t.Errorf("the last word is in no window")
	}
	if len(windows("  \n ", 250, 100)) != 0 {
		t.Errorf("a blank text has windows")
	}
}

// Every window is read to its end: a window of real agent prose, with its header, is
// within what MiniLM reads. With La Roca's 250 words it is not, and the end of every
// window would be cut, as the whole answer was on 1 November.
func TestWindowFitsTheModel(t *testing.T) {
	m, err := load("../../inputs/hour-4/memory/minilm.bin")
	if err != nil {
		t.Skip("no minilm.bin:", err)
	}
	prose := strings.Repeat("The reviewer blocked ticket 001 because pricing.js takes the best-promotion rule, which the ticket's FORBIDDEN leaves to 002-005; I'll fix it and re-run `sh app/check.sh test`. ", 40)
	head := windowHeader("run 001-percent-off, step 2 work, round 2", "2026-10-31 20:21")
	ws := windows(prose, windowWords, overlapWords)
	if len(ws) < 2 {
		t.Fatalf("%d windows for a long answer", len(ws))
	}
	for i, w := range ws {
		if n := len(m.tok.encode(head+w, 1<<20)); n > m.max {
			t.Errorf("window %d is %d tokens; the model reads %d", i, n, m.max)
		}
	}
	if n := len(m.tok.encode(head+strings.Join(strings.Fields(prose)[:250], " "), 1<<20)); n <= m.max {
		t.Errorf("a window of 250 words is %d tokens: it fits, the test proves nothing", n)
	}
}

func TestWindowHeaderAsLaRoca(t *testing.T) {
	for _, c := range []struct{ title, at, want string }{
		{"run 001-percent-off, step 2 work", "2026-10-31 20:21", "[run 001-percent-off, step 2 work · 2026-10] "},
		{"", "2026-10-31 20:21", "[2026-10] "},
		{"notes", "", "[notes] "},
		{"", "", ""},
	} {
		if got := windowHeader(c.title, c.at); got != c.want {
			t.Errorf("windowHeader(%q, %q) = %q, want %q", c.title, c.at, got, c.want)
		}
	}
}

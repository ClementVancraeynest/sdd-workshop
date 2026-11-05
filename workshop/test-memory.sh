#!/bin/sh
# The tests of hour 4's memory, on a small day shaped like a real one: a worker and a
# reviewer of one run, each with the long brief the graph gives them, and the group's
# conversation with its chief, which talks about that run and repeats the group's question.
# On 1 November, in the rehearsal of group 4, search by meaning found only the chief's
# conversations, never what a worker or a reviewer said: each turn, kept as La Roca keeps
# it (what the human said, and the agent's whole answer), had one vector made from the
# brief and the answer joined, and the model reads only the first 256 tokens of a text.
# Now each column has its own vectors, in windows of 250 words that overlap by 100, as La
# Roca makes them. These tests fail if that comes back.
# No browser, no model call: a few seconds. Usage: sh workshop/test-memory.sh
set -eu
workshop=$(cd "$(dirname "$0")" && pwd)
mem="$workshop/inputs/hour-4/memory"
scratch="$workshop/.check/memory-test"
rm -rf "$scratch"
mkdir -p "$scratch/home" "$scratch/day/runs"
cp -R "$mem" "$scratch/memory"
fail=0
check() { # check <description> <condition...>
  desc=$1
  shift
  if "$@"; then echo "  ok   $desc"; else echo "  FAIL $desc"; fail=1; fi
}
memory() { HOME="$scratch/home" sh "$scratch/memory/memory.sh" "$@"; }
db="$scratch/memory/group.sqlite"
q() { sqlite3 -readonly -batch -noheader "$db" "$1"; }

# The brief the graph gives an agent: long, and almost the same in every run.
brief() {
  printf 'Read /g/group-9/.github/skills/%s/SKILL.md first. Your folder is /g/group-9: every file you read or write is inside it. Do the ticket in /g/group-9/tickets/001-percent-off.md. Touch only files under /g/group-9/app/. When you finish, write /g/group-9/graph/runs/001-percent-off/%s/report.md following /g/group-9/graph/REPORT.md exactly. Do not run git. Stop when the report is written. People who do not program are watching you work in a terminal. They see two things: what you say, and the description of each command. So: give every command a short description in plain words, what it is for, never the command itself. Before each step, say in one plain sentence what you are going to do and why; after a test or a check, say in one sentence what it showed. STANDING ORDERS: Never change a test to make it pass. Never add a dependency. Write the report with its four headings. Prices are in pence. A promotion applies to the products of its category only. The receipt shows the savings as one line. Keep the page readable on the till screen.' "$1" "$2"
}
# long: what a worker says while it reads the code, over 300 words, as a real one does, so
# what it says after it is far past what the model reads of one text.
long() {
  for s in \
    'The pricing module reads the basket line by line and asks each promotion what it saves.' \
    'A percent promotion has a category and a rate, and it applies only to products of that category.' \
    'The store keeps the promotions in the browser, under one key, as a list of plain objects.' \
    'The page that creates a promotion saves its kind, its category, its rate and its dates.' \
    'Prices are in pence, so a rate of twenty percent on a jacket of eighty pounds saves sixteen pounds.' \
    'The receipt prints the total savings as one line under the subtotal, never one line per product.' \
    'The test page loads the module, builds a basket with a jacket and a cap, and checks the totals.' \
    'The cap is in another category, so its price must not change when the jacket is discounted.' \
    'The lint step checks that no function is longer than forty lines and that every file ends cleanly.' \
    'The ticket forbids the other kinds of promotion, the rule of the best one, and the dates.' \
    'So the price function must look for the single percent promotion of the line and apply it.' \
    'When no promotion matches, the line keeps its price and the saving of the line is zero.' \
    'The till page will call the same function later, so its name and its arguments must stay simple.' \
    'The report needs four headings: what changed, what was checked, what was not done, and the verdict.' \
    'The skill says to write the test first and to watch it fail before writing the code.' \
    'The test for the jacket and the cap fails now, as it should, because the price function is missing.' \
    'I add the function, run the lint, and read the two lines of the test that check the jacket.' \
    'The jacket line now shows sixty four pounds and the saving line shows sixteen pounds.' \
    'The cap line still shows fifteen pounds, which is what the ticket expects for another category.' \
    'Next I will keep the output of the tests, to count the lines that say ok.'; do
    printf '%s ' "$s"
  done
}
# line <type> <time> <json data>: one Copilot event.
line() { printf '{"type":"%s","timestamp":"2026-11-06T%sZ","data":%s}\n' "$1" "$2" "$3"; }
json() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

step="$scratch/day/runs/001-percent-off/step-2-work"
mkdir -p "$step"
{
  line user.message 10:00:00 "{\"content\":\"$(json "$(brief worker step-2-work)")\"}"
  line assistant.message 10:00:05 '{"content":"I will read the ticket and my skill first, to know what to build.","reasoningText":"The ticket wants one percent promotion per category."}'
  line assistant.message 10:00:20 '{"content":"I will run the tests and save their output to a scratch file, so I can count the ok lines.","toolRequests":[{"toolCallId":"t1","name":"bash","arguments":{"command":"sh app/check.sh test > /tmp/out.txt"}}]}'
  line tool.execution_complete 10:00:21 '{"toolCallId":"t1","success":false,"error":{"message":"Permission denied: /tmp is outside the folder"}}'
  line assistant.message 10:00:25 "{\"content\":\"$(long)\"}"
  line assistant.message 10:00:30 '{"content":"Writing outside my folder was refused, so I will read the test output where it prints instead.","reasoningText":"The graph refuses anything written outside my folder."}'
  line assistant.message 10:01:00 '{"content":"Done: the percent promotion applies to its own category, and every test passes."}'
} > "$step/copilot.jsonl"

step="$scratch/day/runs/001-percent-off/step-4-review"
mkdir -p "$step"
{
  line user.message 10:02:00 "{\"content\":\"$(json "$(brief reviewer step-4-review)")\"}"
  line assistant.message 10:02:10 '{"content":"I will compare the change with what the ticket forbids."}'
  line assistant.message 10:02:40 '{"content":"Verdict: block. The pricing takes the biggest saving of all promotions, and that rule belongs to later tickets."}'
} > "$step/copilot.jsonl"

# A second run, whose worker opens with the same sentence as the first one: in group 4's day
# twelve workers began "I'll start by reading the worker skill", and that one sentence took
# every place by meaning.
step="$scratch/day/runs/002-second-half/step-2-work"
mkdir -p "$step"
{
  line user.message 12:00:00 "{\"content\":\"$(json "$(brief worker step-2-work)")\"}"
  line assistant.message 12:00:05 '{"content":"I will read the ticket and my skill first, to know what to build."}'
  line assistant.message 12:00:40 '{"content":"Done: half price on the second unit of the same product."}'
} > "$step/copilot.jsonl"

# The group's conversation with its chief, in this repository: it talks about the run and
# the workers, and repeats the questions the group asks.
chief="$scratch/home/.copilot/session-state/c1"
mkdir -p "$chief"
printf 'cwd: %s\n' "$(git -C "$scratch/memory" rev-parse --show-toplevel)" > "$chief/workspace.yaml"
{
  line user.message 11:00:00 '{"content":"We are group 9."}'
  line assistant.message 11:00:05 '{"content":"Welcome back, group 9. We will build an index of your runs, the conversations of your workers and reviewers, and your decisions, so you can ask why something happened."}'
  line user.message 11:01:00 '{"content":"is there a pattern from the worker we could spot as patterna that should be in a skill?"}'
  line assistant.message 11:01:05 '{"content":"I will search your day for what the workers did again and again, by your words and by meaning.","reasoningText":"I need the worker own words on this, so I will search the report and the conversation of each worker."}'
  line user.message 11:02:00 '{"content":"why did the reviewer block the ticket?"}'
  line assistant.message 11:02:05 '{"content":"I will look for what the reviewer said when it blocked, in your runs."}'
} > "$chief/events.jsonl"

memory index "$scratch/day/runs" chief > /dev/null 2>&1

worker='runs/001-percent-off/step-2-work/copilot.jsonl'
# like_la_roca: the worker's conversation is one turn, as La Roca keeps it: the brief, and
# the worker's whole answer, every message of it; its refused tool in that turn.
like_la_roca() {
  [ "$(q "SELECT count(*) FROM exchanges WHERE session_id = '$worker';")" = 1 ] &&
    [ "$(q "SELECT human_text LIKE 'Read /g/group-9/.github/skills/worker/SKILL.md first.%' FROM exchanges WHERE session_id = '$worker';")" = 1 ] &&
    [ "$(q "SELECT agent_text LIKE 'I will read the ticket%Writing outside my folder was refused%every test passes.' FROM exchanges WHERE session_id = '$worker';")" = 1 ] &&
    [ "$(q "SELECT exchange_number FROM tool_uses WHERE had_error;")" = 1 ]
}
# windows_as_la_roca: the brief and the answer have their vectors apart, and the long answer
# is read in windows to its end: the last one holds what the worker said last.
windows_as_la_roca() {
  id=$(q "SELECT id FROM exchanges WHERE session_id = '$worker';")
  [ "$(q "SELECT count(*) FROM exchange_vectors WHERE id = $id AND col = 'human_text';")" -ge 1 ] &&
    [ "$(q "SELECT count(*) FROM exchange_vectors WHERE id = $id AND col = 'agent_text';")" -ge 2 ] &&
    [ "$(q "SELECT piece LIKE '%every test passes.' FROM exchange_vectors WHERE id = $id AND col = 'agent_text' ORDER BY part DESC LIMIT 1;")" = 1 ]
}
# meaning <question>: what ask found by meaning.
meaning() { memory ask "$1" | awk '/^Found by meaning/ { on = 1 } on'; }
# in_runs <question> <text>: by meaning, the part from the runs has the text.
in_runs() { meaning "$1" | awk '/In your runs/ { on = 1; next } /^  [A-Z]/ { on = 0 } on' | grep -q "$2"; }

check "a run step's conversation kept as La Roca keeps it: one turn, the brief and the worker's whole answer, its tools" like_la_roca
check 'as La Roca: the brief and the answer have their vectors apart, and a long answer is read in windows to its end' windows_as_la_roca
check 'by meaning, "is there a pattern from the worker...?" finds the worker in the runs, though the chief said the same words' \
  in_runs 'is there a pattern from the worker we could spot that should be in a skill?' 'The worker said'
# What the worker said after 300 words of its answer is found by meaning. MiniLM is small:
# for "why did the worker try to write outside its folder?" it ranks a window about the
# pricing code above the one with the refusal (the worker's thought comes first, and is the
# answer); asked in other words, the refusal's window comes first.
check 'by meaning, what the worker said after 300 words of its answer is found: the refused write' \
  in_runs 'what happened when the worker was not allowed to save the test output?' 'Writing outside my folder was refused'
check 'by meaning, "why did the worker try to write outside its folder?" finds the worker thinking it' \
  in_runs 'why did the worker try to write outside its folder?' 'The worker thought: The graph refuses anything written outside my folder'
check 'by meaning, "why did the reviewer block the ticket?" finds the verdict, not only the question asked to the chief' \
  in_runs 'why did the reviewer block the ticket?' 'Verdict: block'
check 'by meaning, the conversations with the chief still have their own part' \
  sh -c "HOME='$scratch/home' sh '$scratch/memory/memory.sh' ask 'is there a pattern from the worker?' | grep -q 'In your notes, decisions and conversations with your chief'"
# in_rest <question>: by meaning, the part of the notes and the conversations with the chief.
in_rest() { meaning "$1" | awk '/In your notes, decisions and conversations/ { on = 1; next } on'; }
once() { [ "$(meaning 'what did the worker read first?' | grep -c 'I will read the ticket and my skill first')" = 1 ]; }
no_echo() { ! in_rest 'is there a pattern from the worker we could spot that should be in a skill?' | grep -q 'You said: is there a pattern'; }
check 'by meaning, the same sentence said in two runs takes one place, not every place' once
check "by meaning, the group's question does not come back as an answer to itself" no_echo
check 'ask by words also shows the runs apart' \
  sh -c "HOME='$scratch/home' sh '$scratch/memory/memory.sh' ask 'reviewer block' | awk '/^Found with your words/ { on = 1 } /^Found by meaning/ { on = 0 } on' | grep -q 'In your runs'"

[ -n "${KEEP:-}" ] || rm -rf "$scratch" # KEEP=1 leaves the day in workshop/.check to look at
if [ "$fail" -eq 0 ]; then echo 'the memory finds what the agents said'; fi
exit "$fail"

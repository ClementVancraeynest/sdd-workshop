#!/bin/sh
# The tests of hour 4's four folders, workshop/inputs/hour-4/step-1 to step-4 (decision
# 8271, 4 November: Javier opens a folder, tells Copilot to run ticket 010 from there, and
# says which memory just came in). Each folder is a whole state of Northbank's world, the
# example team of memory/CASES.md: its own DOMAIN.md, STANDING.md, a small app of Harbour
# POS, the graph and ticket 010, a discount on a sale. One rule decides the ticket, the one
# case 7 of the memory holds: a discount goes per line, never on the total, rounded per
# line to the penny (Priya, 19 February). The reviewer knows it in every folder; where the
# worker can find it is the only thing that changes:
#   step-1  nowhere                      the run ends red: the reviewer blocks
#   step-2  DOMAIN.md                    green
#   step-3  the worker skill             green
#   step-4  only the memory, quoted into the ticket by the chief before launch: green
# Each folder keeps the run it was proved with, by real Copilot agents, in
# graph/runs/010-sale-discount/: what Javier shows when a live run is slow.
# Needs Chrome or Edge (check-bases.sh --folder runs the app's tests). Usage:
#   sh workshop/test-hour4.sh
set -eu
workshop=$(cd "$(dirname "$0")" && pwd)
hour4="$workshop/inputs/hour-4"
scratch="$workshop/.check/hour4-test"
fail=0
check() { # check <description> <condition...>
  desc=$1
  shift
  if "$@"; then echo "  ok   $desc"; else echo "  FAIL $desc"; fail=1; fi
}
# files <dir> <path>...: every path is a file in the folder.
files() {
  fs_dir=$1
  shift
  for fs_f in "$@"; do [ -f "$fs_dir/$fs_f" ] || return 1; done
}
# has_rule <file>: the file says the discount rule of case 7.
has_rule() { [ -f "$1" ] && grep -qi 'per line' "$1"; }
# no_rule <file>...: every file is there, and none says the rule.
no_rule() {
  for nr_f in "$@"; do
    [ -f "$nr_f" ] || return 1
    if has_rule "$nr_f"; then return 1; fi
  done
}
# the kept run of a folder, and what its journal and its steps say.
run_of() { printf '%s/graph/runs/010-sale-discount' "$1"; }
finished() { # finished <dir> <green|red>: the journal's last event is run_finished with that status
  tail -n 1 "$(run_of "$1")/journal.jsonl" 2> /dev/null | grep -q "\"event\":\"run_finished\",\"status\":\"$2\""
}
# last_visit <dir> <step folder name>: the folder of the last visit of that step.
last_visit() {
  lv=''
  for lv_f in "$(run_of "$1")/$2" "$(run_of "$1")/$2"-r*; do [ -d "$lv_f" ] && lv=$lv_f; done
  printf '%s' "$lv"
}
verdict() { # verdict <dir> <pass|block>: the reviewer's report ends with that verdict
  vd=$(last_visit "$1" step-4-review)
  [ -n "$vd" ] && grep -q "^Verdict: $2" "$vd/report.md"
}
worker_report() {
  wr=$(last_visit "$1" step-2-work)
  [ -n "$wr" ] && grep -q '^## Changed' "$wr/report.md"
}
real_agent() { # real_agent <dir>: the worker's step kept what Copilot wrote, not the fake agent
  ra=$(last_visit "$1" step-2-work)
  [ -n "$ra" ] && [ -s "$ra/copilot.jsonl" ] && ! grep -q 'done by the fake agent' "$ra/report.md"
}
# memory_finds <dir>: on a copy of the folder's memory, ask --example finds Priya's rule.
memory_finds() {
  rm -rf "$scratch"
  mkdir -p "$scratch/home"
  cp -R "$1/memory" "$scratch/memory"
  HOME="$scratch/home" sh "$scratch/memory/memory.sh" ask --example 'does a discount apply per line or on the total?' |
    grep -q 'Priya said: .*Always per line, never on the basket total'
}

given='DOMAIN.md STANDING.md app/check.sh app/index.html app/sale.js app/test/check.js
  app/test/sale.test.html graph/node.sh graph/path.jsonl graph/run.sh graph/pr.sh graph/lib.sh
  graph/state.sh graph/copilot.sh graph/narrate.sh graph/REPORT.md graph/tests/run-all.sh
  graph/tests/test-node.sh graph/tests/test-run.sh graph/tests/fake-agent.sh
  .github/skills/worker/SKILL.md .github/skills/reviewer/SKILL.md tickets/010-sale-discount.md
  AGENTS.md'
for n in 1 2 3 4; do
  d="$hour4/step-$n"
  echo "step-$n"
  # shellcheck disable=SC2086 # one argument per file
  check 'the folder has its DOMAIN.md, STANDING.md, app, graph, skills and ticket 010' files "$d" $given
  check 'the reviewer knows the rule: its skill says it' has_rule "$d/.github/skills/reviewer/SKILL.md"
  check "the chief's AGENTS.md is Northbank's, names this folder and the run command, and bars the group flow" \
    sh -c "grep -q '^# Northbank · step-$n of hour 4' '$d/AGENTS.md' && grep -q 'sh graph/run.sh tickets/010-sale-discount.md' '$d/AGENTS.md' && grep -q 'Never ask which group' '$d/AGENTS.md'"
  case $n in
    1)
      check 'the rule is nowhere the worker reads: not in DOMAIN.md, the worker skill or the ticket' \
        no_rule "$d/DOMAIN.md" "$d/.github/skills/worker/SKILL.md" "$d/tickets/010-sale-discount.md"
      ;;
    2)
      check 'the rule is in DOMAIN.md' has_rule "$d/DOMAIN.md"
      check 'and not in the worker skill or the ticket' \
        no_rule "$d/.github/skills/worker/SKILL.md" "$d/tickets/010-sale-discount.md"
      ;;
    3)
      check 'the rule is in the worker skill' has_rule "$d/.github/skills/worker/SKILL.md"
      check 'and not in DOMAIN.md or the ticket' no_rule "$d/DOMAIN.md" "$d/tickets/010-sale-discount.md"
      ;;
    4)
      check 'the memory is in the folder: memory.sh, the example team, the model and the vectors program' \
        files "$d" memory/memory.sh memory/example-team.sqlite memory/minilm.bin memory/bin/vectors-darwin-arm64 memory/bin/vectors-darwin-amd64
      check 'the rule is not in DOMAIN.md or the worker skill' \
        no_rule "$d/DOMAIN.md" "$d/.github/skills/worker/SKILL.md"
      check 'the memory finds it: ask --example answers with Priya on 19 February' memory_finds "$d"
      check "the ticket quotes what the memory found, Priya's words and where they are" \
        grep -q 'Priya said: "Always per line, never on the basket total' "$d/tickets/010-sale-discount.md"
      ;;
  esac
  check 'sh workshop/check-bases.sh --folder is green on it' \
    sh -c "sh '$workshop/check-bases.sh' --folder '$d' > /dev/null 2>&1 < /dev/null"
  check 'it keeps the run of ticket 010 it was proved with: journal, worker report, reviewer verdict' \
    sh -c "[ -f '$(run_of "$d")/journal.jsonl' ]"
  check 'that run was made by a real agent, not the fake one' real_agent "$d"
  check 'the worker left its report' worker_report "$d"
  if [ "$n" = 1 ]; then
    check 'the reviewer blocked' verdict "$d" block
    check 'the run ended red' finished "$d" red
  else
    check 'the reviewer passed' verdict "$d" pass
    check 'the run ended green' finished "$d" green
    check 'and step 5 wrote its pull request, pr.md' sh -c "[ -s '$(run_of "$d")/pr.md' ]"
  fi
done

rm -rf "$scratch"
if [ "$fail" -eq 0 ]; then echo "hour 4's four folders are as expected"; fi
exit "$fail"

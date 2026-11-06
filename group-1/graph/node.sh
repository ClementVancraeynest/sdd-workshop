#!/bin/sh
# The node: one program for every step of the path. sh graph/node.sh <step-folder>
# The contract is graph/NODE.md. Run it from the group folder.
set -u
here=$(cd "$(dirname "$0")" && pwd)
. "$here/lib.sh"

step=${1:-}
if [ -z "$step" ] || [ ! -d "$step" ]; then
  printf 'node.sh: usage: sh graph/node.sh <step-folder>\n' >&2
  exit 2
fi
step=${step%/}
input=$step/input.json
started=$(date +%H:%M:%S)

# finish <green|red> <why>: writes output.json, says it, and ends with 0 or 1.
finish() {
  printf '{"status":"%s","why":"%s","started":"%s","ended":"%s"}\n' \
    "$1" "$(json_escape "$2")" "$started" "$(date +%H:%M:%S)" > "$step/output.json"
  printf '%s: %s\n' "$1" "$2"
  [ "$1" = green ] && exit 0
  exit 1
}
# reject <why>: a bad job is red, nothing runs, report.md says why.
reject() {
  printf '%s\n' "$1" > "$step/report.md"
  finish red "$1"
}
# count <key>: how many times the key appears in the raw line.
count() {
  grep -o "\"$1\"[[:space:]]*:" "$input" 2>/dev/null | wc -l | tr -d ' '
}

# The door.
[ -f "$input" ] || reject "input.json is missing"
json_valid "$input" || reject "input.json is not valid JSON"
[ "$(count kind)" = 1 ] || reject "kind must appear exactly once"
kind=$(json_get "$input" kind)
dir=$(json_get "$input" dir)
case $kind in
  commands) [ "$(count run)" = 1 ] || reject "a commands job needs exactly one run" ;;
  agent) [ "$(count ticket)" = 1 ] || reject "an agent job needs exactly one ticket" ;;
  *) reject "unknown kind: $kind" ;;
esac
[ "$(count dir)" = 1 ] && [ -n "$dir" ] || reject "dir must appear exactly once"
[ -d "$dir" ] || reject "dir does not exist: $dir"

# Grey.
if [ "$kind" = commands ]; then
  run=$(json_get "$input" run)
  [ -n "$run" ] || reject "run is empty"
  code=0
  sh -c "$run" > "$step/report.md" 2>&1 < /dev/null || code=$?
  if [ "$code" = 0 ]; then finish green "commands passed, output in report.md"; fi
  finish red "commands failed with exit $code, output in report.md"
fi

# Blue.
ticket=$(json_get "$input" ticket)
[ -f "$ticket" ] || reject "ticket does not exist: $ticket"
agent=$(json_get "$input" agent)
agent=${agent:-graph/copilot.sh}
limit=$(json_get "$input" limit)
limit=${limit:-300}
SKILL=$(json_get "$input" skill)
MODEL=$(json_get "$input" model)
LAST=$(json_get "$input" last)
export SKILL MODEL LAST

prefix=$(git rev-parse --show-prefix 2>/dev/null || true)
before=$(git status --porcelain -uall 2>/dev/null | sort)
rm -f "$step/report.md"
: > "$step/agent.log"

code=0
run_limited "$limit" . "$step/agent.log" "sh '$agent' '$ticket' '$dir' '$step/report.md'" || code=$?
if [ "$code" = 124 ]; then finish red "agent cut after $limit s"; fi
if [ "$code" != 0 ]; then finish red "agent failed with exit $code, see agent.log"; fi
[ -s "$step/report.md" ] || finish red "agent left no report"
for heading in Ticket Changed Checked "Not done"; do
  grep -q "^## $heading" "$step/report.md" || finish red "report.md lacks ## $heading"
done

after=$(git status --porcelain -uall 2>/dev/null | sort)
outside=$(printf '%s\n' "$after" | while IFS= read -r line; do
  [ -n "$line" ] || continue
  printf '%s\n' "$before" | grep -qxF -- "$line" && continue
  path=${line#???}
  path=${path#\"}
  path=${path%\"}
  path=${path#"$prefix"}
  case $path in
    "$dir"/*|graph/runs/*) ;;
    *) printf '%s ' "$path" ;;
  esac
done)
outside=${outside% }
[ -z "$outside" ] || finish red "agent touched outside $dir: $outside"

if grep -q '^Verdict: block' "$step/report.md"; then
  reason=$(awk '/^Verdict: block/ { getline; print; exit }' "$step/report.md")
  finish red "reviewer blocked: $reason"
fi
finish green "agent finished, report.md written"

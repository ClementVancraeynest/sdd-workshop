#!/bin/sh
# Tests of the node (graph/node.sh) against the fake agent. No model is called.
# Run from the group folder: sh graph/tests/test-node.sh
set -u
here=$(cd "$(dirname "$0")" && pwd)
graph=$(dirname "$here")
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The throwaway group folder is group-9/ inside a git repository, like a real group.
root=$tmp/repo
g=$root/group-9
mkdir -p "$g/graph/tests" "$g/graph/runs" "$g/app" "$g/tickets" "$g/openspec"
cp "$graph/node.sh" "$graph/lib.sh" "$graph/REPORT.md" "$g/graph/"
cp "$here/fake-agent.sh" "$g/graph/tests/"
printf 'x\n' > "$g/app/keep.txt"
printf 'x\n' > "$g/openspec/keep.txt"
printf 'x\n' > "$g/graph/runs/.gitkeep"
for t in work fail slow outside no-report bad-report block pass; do
  printf '# %s\n' "$t" > "$g/tickets/$t.md"
done
(
  cd "$root" && git init -q . \
    && git add -A \
    && git -c user.name=t -c user.email=t@t commit -q -m base
) > /dev/null 2>&1

failed=0
ok() { printf '  ok   %s\n' "$1"; }
bad() { printf '  FAIL %s\n' "$1"; failed=1; }
# check <case> <command>: ok when the command succeeds.
check() { if eval "$2" > /dev/null 2>&1; then ok "$1"; else bad "$1"; fi; }

# step <name> <json>: writes the job of a step folder.
step() {
  mkdir -p "$g/graph/runs/$1"
  printf '%s\n' "$2" > "$g/graph/runs/$1/input.json"
}
# node <name>: runs the node on a step from the group folder, keeps its words and code.
node() {
  code=0
  out=$(cd "$g" && sh graph/node.sh "graph/runs/$1" 2>&1) || code=$?
}
output() { cat "$g/graph/runs/$1/output.json" 2>/dev/null; }
report() { cat "$g/graph/runs/$1/report.md" 2>/dev/null; }
fake='"agent":"graph/tests/fake-agent.sh"'

# 1. commands that pass
step c-pass '{"kind":"commands","dir":"app","run":"echo hello-from-grey"}'
node c-pass
check "commands that pass are green, exit 0" '[ "$code" = 0 ] && output c-pass | grep -q "\"status\":\"green\"" && printf "%s" "$out" | grep -q "^green:"'
check "the output of the commands is report.md" 'report c-pass | grep -q hello-from-grey'
check "output.json is one valid line with started and ended" '. "$g/graph/lib.sh"; json_valid "$g/graph/runs/c-pass/output.json" && [ "$(wc -l < "$g/graph/runs/c-pass/output.json")" = 1 ] && output c-pass | grep -q "\"started\":\"" && output c-pass | grep -q "\"ended\":\""'

# 2. commands that fail
step c-fail '{"kind":"commands","dir":"app","run":"echo boom; exit 3"}'
node c-fail
check "commands that fail are red, exit 1" '[ "$code" = 1 ] && output c-fail | grep -q "\"status\":\"red\"" && printf "%s" "$out" | grep -q "^red:"'
check "the why of failed commands names report.md" 'output c-fail | grep -q "report.md"'
check "the output of failed commands is still in report.md" 'report c-fail | grep -q boom'

# 3. an agent that finishes well
step a-ok '{"kind":"agent","dir":"app","ticket":"tickets/work.md",'"$fake"'}'
node a-ok
check "an agent with a four-heading report is green, exit 0" '[ "$code" = 0 ] && output a-ok | grep -q "\"status\":\"green\""'
check "agent.log is in the step folder" '[ -f "$g/graph/runs/a-ok/agent.log" ]'
check "the report of the agent is report.md" 'report a-ok | grep -q "^## Not done"'
check "writing in app/ only is not outside the dir" '[ -f "$g/app/fake-work.txt" ] && ! output a-ok | grep -q outside'
check "skill, model and last reach the plug" '
  step a-env "{\"kind\":\"agent\",\"dir\":\"app\",\"ticket\":\"tickets/work.md\",$fake,\"skill\":\"sk-x\",\"model\":\"md-y\",\"last\":\"graph/runs/a-ok\"}"
  node a-env
  report a-env | grep -q "Skill: sk-x" && report a-env | grep -q "Model: md-y"'
check "fields of the path are kept and ignored" '
  step a-extra "{\"step\":2,\"name\":\"work\",\"on_red\":\"stop\",\"rounds\":3,\"kind\":\"agent\",\"dir\":\"app\",\"ticket\":\"tickets/work.md\",$fake}"
  node a-extra
  [ "$code" = 0 ] && grep -q "\"rounds\":3" "$g/graph/runs/a-extra/input.json"'

# 4. an agent that fails or runs too long
step a-fail '{"kind":"agent","dir":"app","ticket":"tickets/fail.md",'"$fake"'}'
node a-fail
check "an agent that fails is red, and the why says so" '[ "$code" = 1 ] && output a-fail | grep -q "\"status\":\"red\"" && output a-fail | grep -q "agent failed"'
step a-slow '{"kind":"agent","dir":"app","ticket":"tickets/slow.md","limit":2,'"$fake"'}'
start=$(date +%s)
node a-slow
elapsed=$(( $(date +%s) - start ))
check "an agent past its limit is red, and the why says it was cut" '[ "$code" = 1 ] && output a-slow | grep -q "agent cut after 2 s"'
check "the agent is stopped at the limit, not left to finish" '[ "$elapsed" -lt 15 ]'

# 5. an agent that writes outside dir
step a-out '{"kind":"agent","dir":"app","ticket":"tickets/outside.md",'"$fake"'}'
node a-out
check "an agent writing outside dir is red, and the why names the path" '[ "$code" = 1 ] && output a-out | grep -q "agent touched outside app: " && output a-out | grep -q "tickets/outside.txt"'
check "the path is compared without the group prefix" '! output a-out | grep -q "group-9/app"'
rm -f "$g/tickets/outside.txt"

# 8. an agent that leaves no report, or a bad one
step a-none '{"kind":"agent","dir":"app","ticket":"tickets/no-report.md",'"$fake"'}'
node a-none
check "an agent without a report is red: agent left no report" '[ "$code" = 1 ] && output a-none | grep -q "agent left no report"'
step a-bad '{"kind":"agent","dir":"app","ticket":"tickets/bad-report.md",'"$fake"'}'
node a-bad
check "a report without a heading is red and names it" '[ "$code" = 1 ] && output a-bad | grep -q "report.md lacks ## Checked"'

# 7. the verdict
step a-block '{"kind":"agent","dir":"app","ticket":"tickets/block.md",'"$fake"'}'
node a-block
check "Verdict: block is red, with the reason" '[ "$code" = 1 ] && output a-block | grep -q "reviewer blocked: " && output a-block | grep -q "zero price"'
step a-pass '{"kind":"agent","dir":"app","ticket":"tickets/pass.md",'"$fake"'}'
node a-pass
check "Verdict: pass is green" '[ "$code" = 0 ] && output a-pass | grep -q "\"status\":\"green\""'

# 6. a malformed job: red, nothing run, nothing written but output.json and report.md
before_app=$(ls -A "$g/app" | tr '\n' ' ')
before_tickets=$(ls -A "$g/tickets" | tr '\n' ' ')
# malformed <case> <json>: the job is red, nothing ran, only two files are left in the folder.
malformed() {
  step "$1" "$2"
  node "$1"
  files=$(ls -A "$g/graph/runs/$1" | tr '\n' ' ')
  [ "$code" = 1 ] && output "$1" | grep -q "\"status\":\"red\"" \
    && [ -s "$g/graph/runs/$1/report.md" ] \
    && [ "$files" = "input.json output.json report.md " ] \
    && [ "$(ls -A "$g/app" | tr '\n' ' ')" = "$before_app" ] \
    && [ "$(ls -A "$g/tickets" | tr '\n' ' ')" = "$before_tickets" ]
}
check "two kind is red, nothing run" 'malformed m-kind2 "{\"kind\":\"commands\",\"kind\":\"agent\",\"dir\":\"app\",\"run\":\"touch app/ran\"}" && [ ! -e "$g/app/ran" ]'
check "three ticket is red, nothing run" 'malformed m-ticket3 "{\"kind\":\"agent\",\"dir\":\"app\",\"ticket\":\"tickets/work.md\",\"ticket\":\"tickets/pass.md\",\"ticket\":\"tickets/block.md\",$fake}"'
check "no dir is red, nothing run" 'malformed m-nodir "{\"kind\":\"commands\",\"run\":\"touch app/ran\"}" && [ ! -e "$g/app/ran" ]'
check "a dir that does not exist is red, nothing run" 'malformed m-baddir "{\"kind\":\"commands\",\"dir\":\"nowhere\",\"run\":\"touch app/ran\"}" && [ ! -e "$g/app/ran" ]'
check "an unknown kind is red, nothing run" 'malformed m-kind "{\"kind\":\"magic\",\"dir\":\"app\",\"run\":\"touch app/ran\"}" && [ ! -e "$g/app/ran" ]'
check "two run is red, nothing run" 'malformed m-run2 "{\"kind\":\"commands\",\"dir\":\"app\",\"run\":\"touch app/ran\",\"run\":\"true\"}" && [ ! -e "$g/app/ran" ]'

exit $failed

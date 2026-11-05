#!/bin/sh
# Tests the workshop's guard with tool calls shaped like the ones the chief made in the
# rehearsals of 29 and 30 October. One "  ok" or "  FAIL" line per case.
# Usage: sh workshop/hooks/test-guard.sh
set -u
here=$(cd "$(dirname "$0")" && pwd)
fail=0
s="test-$$"
rm -f "$here/.panel/$s"

call() { printf '%s' "$1" | WORKSHOP_OS=Darwin sh "$here/guard.sh"; }
denied() { # denied <description> <json>
  if call "$2" | grep -q '"permissionDecision":"deny"'; then echo "  ok   $1"; else echo "  FAIL $1"; fail=1; fi
}
allowed() { # allowed <description> <json>
  if call "$2" | grep -q 'deny'; then echo "  FAIL $1"; fail=1; else echo "  ok   $1"; fi
}
bash_call() { printf '{"sessionId":"%s","toolName":"bash","toolArgs":{"command":"%s","description":"x"}}' "$s" "$1"; }

denied 'the task tool (30 Oct: the worker ran as an invisible subagent)' \
  "{\"sessionId\":\"$s\",\"toolName\":\"task\",\"toolArgs\":{\"name\":\"node-worker\",\"mode\":\"background\"}}"
denied 'copilot -p in a command card (29 Oct: the worker log went to /tmp)' \
  "$(bash_call 'cd group-1 && copilot -p \"$(cat tickets/000-node.md)\" --allow-all-tools > /tmp/w.log 2>&1 &')"
denied 'graph/worker.sh in a command card' "$(bash_call 'cd group-4 && sh graph/worker.sh tickets/000-node.md')"
denied 'graph/run.sh in a command card' "$(bash_call 'cd group-4 && sh graph/run.sh tickets/001-percent-off.md')"
worker_writes=$(bash_call 'cat > graph/run.sh.new <<EOF\n# sh graph/run.sh tickets/<ticket>.md\nEOF')
denied 'the chief writing a file that names sh graph/run.sh' "$worker_writes"
if WORKSHOP_WORKER=1 call "$worker_writes" | grep -q deny; then echo '  FAIL a worker (WORKSHOP_WORKER=1) writing a file that names sh graph/run.sh (31 Oct)'; fail=1; else echo '  ok   a worker (WORKSHOP_WORKER=1) writing a file that names sh graph/run.sh (31 Oct)'; fi
denied 'sleep 45 (29 Oct: three minutes of silence)' "$(bash_call 'sleep 45; tail -5 graph/runs/worker-000-node.log')"
denied 'a log written to /var/folders' "$(bash_call 'tail -f /var/folders/4m/x/agent.log')"
allowed 'the node test' "$(bash_call 'cd group-4 && sh graph/tests/test-node.sh')"
allowed 'the path test' "$(bash_call 'cd group-4 && sh graph/tests/test-run.sh')"
allowed 'reading run.sh' "$(bash_call 'cd group-4 && cat graph/run.sh')"
allowed 'the status' "$(bash_call 'cd group-4 && sh workshop.sh status')"
allowed 'sleep 2' "$(bash_call 'sleep 2 && tail -3 graph/runs/worker-000-node.log')"
allowed 'the terminal panel with the worker' \
  "{\"sessionId\":\"$s\",\"toolName\":\"open_canvas\",\"toolArgs\":{\"canvasId\":\"terminal\",\"instanceId\":\"worker-000\",\"input\":{\"command\":\"cd /x/group-4 && sh graph/worker.sh tickets/000-node.md\"}}}"
denied 'writing ticket 000 before graph/NODE.md is open (30 Oct)' \
  "{\"sessionId\":\"$s\",\"toolName\":\"edit\",\"toolArgs\":{\"path\":\"/x/group-4/tickets/000-node.md\",\"old_str\":\"a\",\"new_str\":\"b\"}}"
allowed 'editing another file that names 000-node.md' \
  "{\"sessionId\":\"$s\",\"toolName\":\"edit\",\"toolArgs\":{\"path\":\"/x/group-4/notes/hour-2.md\",\"old_str\":\"a\",\"new_str\":\"tickets/000-node.md\"}}"
allowed 'opening graph/NODE.md in the editor panel' \
  "{\"sessionId\":\"$s\",\"toolName\":\"open_canvas\",\"toolArgs\":{\"canvasId\":\"editor\",\"instanceId\":\"node-md\",\"input\":{\"path\":\"group-4/graph/NODE.md\",\"scope\":\"repo\"}}}"
allowed 'writing ticket 000 once graph/NODE.md is open' \
  "{\"sessionId\":\"$s\",\"toolName\":\"edit\",\"toolArgs\":{\"path\":\"/x/group-4/tickets/000-node.md\",\"old_str\":\"a\",\"new_str\":\"b\"}}"

# Windows (rehearsal of 5 November): the panel is Windows PowerShell.
win() { # win <denied|allowed> <description> <json>
  if printf '%s' "$3" | WORKSHOP_OS=MINGW64_NT-10.0 sh "$here/guard.sh" | grep -q '"permissionDecision":"deny"'; then got=denied; else got=allowed; fi
  if [ "$got" = "$1" ]; then echo "  ok   $2"; else echo "  FAIL $2"; fail=1; fi
}
panel() { printf '{"sessionId":"%s","toolName":"open_canvas","toolArgs":{"canvasId":"terminal","instanceId":"run-010","input":{"command":"%s"}}}' "$s" "$1"; }
ps_call() { printf '{"sessionId":"%s","toolName":"powershell","toolArgs":{"command":"%s","description":"x"}}' "$s" "$1"; }
good="[Console]::OutputEncoding = [Text.UTF8Encoding]::new(); cd 'C:\\\\Users\\\\x\\\\step-4'; & 'C:\\\\Program Files\\\\Git\\\\bin\\\\sh.exe' graph/run.sh tickets/010-sale-discount.md"
win denied 'Windows: the panel with && (5 Nov: red error)' "$(panel 'cd C:\\\\Users\\\\x\\\\step-4 && sh graph/run.sh tickets/010-sale-discount.md')"
win denied 'Windows: the panel with a bare sh (5 Nov: sh is not recognized)' "$(panel "[Console]::OutputEncoding = [Text.UTF8Encoding]::new(); cd 'C:\\\\x'; sh graph/run.sh tickets/010.md")"
win denied 'Windows: the panel without UTF-8 (5 Nov: garbled arrow and tick)' "$(panel "cd 'C:\\\\x'; & 'C:\\\\Program Files\\\\Git\\\\bin\\\\sh.exe' graph/run.sh tickets/010.md")"
win allowed 'Windows: the panel in the Windows form' "$(panel "$good")"
win denied 'Windows: a run in a PowerShell command card' "$(ps_call "$good")"
win denied 'Windows: Start-Sleep 45 in PowerShell' "$(ps_call 'Start-Sleep -Seconds 45')"
win allowed 'Windows: the status through Git sh' "$(ps_call "& 'C:\\\\Program Files\\\\Git\\\\bin\\\\sh.exe' workshop.sh status")"
if printf '%s' "$(panel 'cd /x && sh graph/run.sh tickets/010.md')" | WORKSHOP_OS=Darwin sh "$here/guard.sh" | grep -q deny; then echo '  FAIL the Mac panel with && stays allowed'; fail=1; else echo '  ok   the Mac panel with && stays allowed'; fi
if WORKSHOP_OS=MINGW64_NT-10.0 sh "$here/start.sh" | grep -q '"additionalContext":"This computer runs Windows'; then echo '  ok   start.sh gives the Windows form on Windows'; else echo '  FAIL start.sh gives the Windows form on Windows'; fail=1; fi
if [ -z "$(WORKSHOP_OS=Darwin sh "$here/start.sh")" ]; then echo '  ok   start.sh says nothing on a Mac'; else echo '  FAIL start.sh says nothing on a Mac'; fail=1; fi
if deny_out=$(printf '%s' "$(panel 'cd x && sh y')" | WORKSHOP_OS=MINGW64_NT-10.0 sh "$here/guard.sh") && printf '%s' "$deny_out" | python3 -c 'import json,sys; json.load(sys.stdin)' 2>/dev/null; then echo '  ok   the Windows refusal is valid JSON'; else echo '  FAIL the Windows refusal is valid JSON'; fail=1; fi
if python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$here/windows.json" 2>/dev/null; then echo '  ok   windows.json is valid JSON'; else echo '  FAIL windows.json is valid JSON'; fail=1; fi

rm -f "$here/.panel/$s"
exit "$fail"

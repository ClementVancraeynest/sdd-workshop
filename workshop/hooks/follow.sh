#!/bin/sh
# The chief stays with the runs: a Copilot agentStop hook (.github/hooks/workshop.json).
# Copilot speaks only while it has a turn. When the chief ends its turn with a run going in
# the terminal panel, nobody tells the group what happens next: on 31 October, group 4,
# three runs ended, two pull requests opened, one run went red, and the chief said nothing
# for three minutes until the group asked "why are you silent". This hook runs when a turn
# ends and reads the journals under graph/runs/: if a run is still going, or one has ended
# since the chief last spoke, it answers {"decision":"block","reason":...} and Copilot gives
# the chief another turn with the reason as its prompt (Copilot stops after 8 blocks in a
# row). With nothing to tell, the turn ends. The first stop of a session only takes note of
# the runs already finished, so old runs are not announced as news.
# Usage (by Copilot): sh workshop/hooks/follow.sh < stop.json
# WORKSHOP_ROOT and WORKSHOP_PANEL are for its test.
set -u
if [ -n "${WORKSHOP_WORKER:-}" ]; then exit 0; fi
here=$(cd "$(dirname "$0")" && pwd)
root=${WORKSHOP_ROOT:-$(cd "$here/../.." && pwd)}
panel=${WORKSHOP_PANEL:-$here/.panel}
input=$(cat)
session=$(printf '%s' "$input" | sed -n 's/.*"sessionId": *"\([^"]*\)".*/\1/p' | head -n 1)
told="$panel/told-${session:-unknown}"
mkdir -p "$panel"
first=''
if [ ! -f "$told" ]; then first=yes; : > "$told"; fi

# last <file> <key>: the last string value of key on the last matching line.
value() { sed -n "s/.*\"$2\":\"\([^\"]*\)\".*/\1/p" | tail -n 1; }
# What the chief said last, from the transcript Copilot names: a run it already told the
# group about (its name and its link in that message) is not news.
transcript=$(printf '%s' "$input" | sed -n 's/.*"transcriptPath": *"\([^"]*\)".*/\1/p' | head -n 1)
last_said=''
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  last_said=$(grep '"type":"assistant.message"' "$transcript" | tail -n 1)
fi
going=''
ended=''
for j in "$root"/group-*/graph/runs/*/journal.jsonl "$root"/graph/runs/*/journal.jsonl "$root"/workshop/inputs/hour-4/step-*/graph/runs/*/journal.jsonl; do
  [ -f "$j" ] || continue
  run=$(dirname "$j")
  rel=${run#"$root"/}
  if grep -q '"event":"run_finished"' "$j"; then
    if grep -qxF "$rel" "$told"; then continue; fi
    printf '%s\n' "$rel" >> "$told"
    [ -z "$first" ] || continue
    status=$(grep '"event":"run_finished"' "$j" | value - status)
    why=$(grep '"event":"run_finished"' "$j" | value - why)
    url=''
    if [ -f "$run/pr.url" ]; then url=$(head -n 1 "$run/pr.url"); fi
    if printf '%s' "$last_said" | grep -qF -- "$(basename "$run")" && { [ -z "$url" ] || printf '%s' "$last_said" | grep -qF -- "$url"; }; then continue; fi
    ended="$ended Run $rel ended $status: $why.${url:+ Pull request: $url.}"
  else
    pid=$(grep -o '"pid":[0-9]*' "$j" | tail -n 1 | cut -d: -f2)
    if [ -n "$pid" ] && kill -0 "$pid" 2> /dev/null; then
      event=$(tail -n 1 "$j" | value - event)
      step=$(tail -n 1 "$j" | sed -n 's/.*"step":\([0-9]*\).*/\1/p')
      going="$going $rel (last event: $event${step:+, step $step});"
    fi
  fi
done

# The worker of hour 2 (graph/worker.sh) is not a run: it keeps no journal. While it works
# its lines go to graph/runs/worker-<ticket>.log.ansi; when it ends they move to
# worker-<ticket>.log, whose last "Worker on ... ended" line says how. On 5 November, group
# 3, the chief opened the worker's panel, explained it and ended its turn: nobody followed
# the worker. A .log.ansi untouched for 15 minutes is a worker that died, not one working.
wgoing=''
wended=''
for w in "$root"/group-*/graph/runs/worker-*.log.ansi; do
  [ -f "$w" ] || continue
  [ -n "$(find "$w" -mmin -15 2> /dev/null)" ] || continue
  wgoing="$wgoing ${w#"$root"/};"
done
for w in "$root"/group-*/graph/runs/worker-*.log; do
  [ -f "$w" ] || continue
  line=$(grep 'Worker on .* ended ' "$w" | tail -n 1)
  [ -n "$line" ] || continue
  key="${w#"$root"/}: $line"
  if grep -qxF "$key" "$told"; then continue; fi
  printf '%s\n' "$key" >> "$told"
  [ -z "$first" ] || continue
  last=$(grep -E '(✓|✗) ' "$w" | tail -n 1 | sed 's/^[^✓✗]*//')
  wended="$wended $line (${last:-no last line}), in ${w#"$root"/}."
done
[ -n "$ended$going$wended$wgoing" ] || exit 0

reason=''
if [ -n "$wended" ]; then
  reason="A worker ended:$wended Tell the group now, in two lines: green (exit 0) or red, in the terminal's own words, and then run the ticket's test of VERIFY and show its output. If your last message already said it, end your turn."
fi
if [ -n "$wgoing" ]; then
  reason="$reason${reason:+ }A worker is still working:$wgoing Do not end your turn while it works: read its terminal panel (invoke_canvas_action read_terminal_output), say one line to the group only when something new came, sleep 4 at most between looks, until the terminal prints Worker on ... ended. Then say how it ended."
fi
if [ -n "$ended" ]; then
  reason="$reason${reason:+ }A run ended:$ended If your last message already said this with the link, end your turn and say nothing more. Else tell the group now, two lines per run: the result in the terminal's words, and the pull request link when there is one; for a red run, the reviewer's reason and that a person decides (read it with sh graph/state.sh graph/runs/<run>). Open graph/runs/<run>/pr.md in the editor panel when there is a pull request."
fi
if [ -n "$going" ]; then
  reason="$reason${reason:+ }A run is still going:$going Do not end your turn while it goes: read its terminal panel (invoke_canvas_action read_terminal_output), say one line to the group only when something new came, sleep 4 at most between looks, until the terminal prints run ...: green or red. Then say the result and the link it prints."
fi
# The reason goes inside a JSON string: no double quotes, backslashes or new lines in it.
reason=$(printf '%s' "$reason" | tr '\n\\"' '   ')
printf '{"decision":"block","reason":"%s"}\n' "$reason"
exit 0

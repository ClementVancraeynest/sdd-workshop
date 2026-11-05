#!/bin/sh
# Windows set-up for the chief: a Copilot sessionStart hook (.github/hooks/workshop.json).
# Rehearsal of 5 November on Windows 11: the terminal panel is Windows PowerShell. It refused
# `&&` and `sh`, and its console (code page 437) printed the graph's arrow and tick as
# garbage. On Windows (Copilot runs this hook with Git's bash) it hands the chief, as
# context, the one form of command that shows the room what a Mac shows; guard.sh refuses
# any other form. Anywhere else it prints nothing.
# Usage (by Copilot): sh workshop/hooks/start.sh. WORKSHOP_OS is for its test.
set -u
case ${WORKSHOP_OS:-$(uname -s)} in
  MINGW* | MSYS* | CYGWIN*) cat "$(dirname "$0")/windows.json" ;;
esac
exit 0

# Module 4b · Context engineering

Closing question: Same ticket, four runs: what did the worker know each time, and where did it come from?
Given: Northbank, a prepared world: four folders, `step-1` to `step-4`, each with ticket 010, its graph and its own copy of the memory tool
The group decides: Which memory entered in each folder, and where their own team keeps that one today
The group builds: Nothing by hand: four runs of the same ticket, one more memory each; one red, three green, watched on the instructor's screen and on their own Mac
Rescue: The run each folder was proved with (`graph/runs/010-sale-discount`), when a live run is slow

## A bigger window does not make a better agent

Layout: text

- **Then:** a few thousand tokens. Now a million or more: room for more instructions, tool results, docs.
- **The study:** 18 frontier models, and all of them got less reliable as the window got bigger. It has a name: context rot.
- **Context engineering:** deciding what actually goes into the window at each step of an agent's run.

> THE MORE TOKENS IN THE WINDOW, THE LESS RELIABLY THE MODEL USES ANY OF THEM

## What fills the window of a migration agent

Layout: five

- The system prompt: the standing instructions for how the agent operates
- The task: a couple of lines, near the front
- Project instructions, an AGENTS.md on how this project is built, and every tool definition
- The message history: every step it has taken. After an hour, a lot of steps
- Tool results, the biggest band: file contents, test output, error logs, schema dumps

## Attention is a budget

Layout: numbers

- **1M** tokens a window may hold. The attention spread across them is finite
- **18** frontier models in one study. Every one got less reliable as the window grew
- **46 → 19** tools: a model failed a task offered 46 tools, and passed the same task with 19

## Four ways a window goes bad

Layout: steps

- **Poisoning:** a false note the agent wrote itself, "the new driver retries, delete the retry code", treated as ground truth. File after file, good code deleted.
- **Distraction:** an hour of its own history outweighs its training. It drifts into doing more of what it already did.
- **Confusion:** every tool definition sits in the window, used or not. More tools, harder choice.
- **Clash:** the agent finds the note was wrong and writes that down too. Both versions sit in the window.

Nothing is looked up: every token competes for attention

## Four fixes, all by throwing something away

Layout: steps

- **Validate:** check a conclusion against something real before writing it down. One connection test, no note.
- **Compact:** summarize the long history, a photocopy of a photocopy. Better: detail into files, pulled in when needed.
- **Curate:** give the agent the handful of tools the job calls for. It can fetch the others.
- **Prune:** delete the superseded version, or start a fresh window with the corrected state.

An agent gets better at long tasks by holding less

## The four fixes in the graph you built

Layout: steps

- **Validate:** the check step and the reviewer: a gate no note of the agent can talk out of
- **Compact:** one clean window per ticket; the journal, the reports and the verdicts live in files, not in the window
- **Curate:** the worker's narrow context, and a skill loaded only when the task matches
- **Prune:** a run is never reused: a fresh copy and a fresh window for every ticket

Your graph holds less by design

## Key message

Layout: key

> CONTEXT ENGINEERING: DECIDE WHAT GOES INTO THE WINDOW AT EACH STEP

## Hands on 4 · One ticket, four memories

Layout: hands-on

1. open Copilot in workshop/inputs/hour-4/step-1, Northbank's world, and ask it to launch ticket 010. The worker knows only the ticket: it takes the discount on the subtotal, and the reviewer blocks. Red
2. close it, open Copilot in step-2, same words. Now the rule is in DOMAIN.md. Green
3. step-3: the rule is in the worker's skill, not in DOMAIN.md. Green, with the discount test written first
4. step-4: the rule is in no file, only in Northbank's memory. The chief asks memory.sh, finds Priya's words of 19 February, and the ticket carries them. Green

You: Launch ticket 010.
Chief: Run 010 red: the reviewer blocked. app/sale.js takes the percentage of the subtotal; Northbank's rule is per line, rounded to the penny. A person decides.

# Decided

- Hour 4 is its own prepared world, Northbank: four folders, `step-1` to `step-4`, the same ticket 010, one more memory each; the instructor shares the screen and everyone follows on their Mac (decision 8271).
- The theory of hour 4 is two talks, context engineering (this deck, 4b) and the four types of memory (deck 4a); the context window is the working memory of CoALA (decision 8271).

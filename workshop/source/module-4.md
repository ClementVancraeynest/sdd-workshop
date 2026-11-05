# Module 4 · Memory that improves the system

Closing question: Same ticket, four runs: what did the worker know each time, and where did it come from?
Given: Northbank, a prepared world: four folders, `step-1` to `step-4`, each with ticket 010, its graph and its own copy of the memory tool
The group decides: Which memory entered in each folder, and where their own team keeps that one today
The group builds: Nothing by hand: four runs of the same ticket, one more memory each; one red, three green, watched on the instructor's screen and on their own Mac
Rescue: The run each folder was proved with (`graph/runs/010-sale-discount`), when a live run is slow

## How do humans remember?

Layout: text

- **Right now:** what you are holding in your head this minute.
- **Facts:** what you know is true, like the discount going before VAT.
- **Skills:** playing the guitar like Paco de Lucía.
- **Experience:** the three hours lost fixing a broken image in a site because it was badly cached in the browser.

> A WELL-DESIGNED AGENT NEEDS THE SAME FOUR

## Four types of agent memory (CoALA, Princeton)

Layout: five

- Working: the context window. Like RAM: fast, doesn't last forever, with a ceiling (from 256k to 1M)
- Semantic: what it knows in general. In practice, markdown files such as AGENTS.md
- Procedural: how to do things. SKILL.md, loaded only when the task matches
- Episodic: what happened before and what it learned. The hardest to get right
- Thermostat: working memory. Password-reset bot: plus a skill. Coding agent: all four

## The four memories in the graph you built

Layout: steps

- **Working:** the worker's clean window, one per ticket
- **Semantic:** AGENTS.md and DOMAIN.md
- **Procedural:** the skills from module 3
- **Episodic:** the SQLite with your runs. This module

Memory is what separates a chatbot from an agent

## Episodic memory: the hardest one

Layout: prose

- Why the conversations: to recall past conversations and their context, the human's and the agent's. A decision is backed by a human's word, not by a metric. When something goes wrong you rebuild the timeline step by step: what the chief of staff said, what the agent answered.
- What you do with it: run times, cost, which model is better, repeated patterns that become a skill. The system improves as it is used. Distil on top of the source, never instead of it.

## RAG or memory?

Layout: text

- **RAG** reads what a person wrote on purpose: specs, docs, tickets.
- **Memory** reads what the agent lived: runs, verdicts, what it fixed and how.
- Your SQLite holds both. The specs and tickets are RAG. The runs and verdicts are memory.

> WHAT YOU WROTE. WHAT IT LIVED.

## Key message

Layout: statement

> EVERY RUN IS DATA. THE SYSTEM GETS BETTER ONLY IF YOU KEEP IT AND LOOK AT IT.

## What teams running this can see in their data

Layout: numbers

- **4 h** A run waited 4 h in review. Nobody was told
- **86%** One reviewer model was right in 86% of 32 cases
- **0 of 6** One worker model: 6 PRs, none clean through the gate

## Your corpus: what you and your system wrote

Layout: five

- The chief's tickets
- Worker reports and reviewer verdicts
- Time and cost per step
- The chief's handover
- Conversations: you with the chief, the chief with its agents

## Key message

Layout: key

> NOT A MONITORING DASHBOARD. EVERY DECISION IS BACKED BY A HUMAN'S WORD.

## RAG in a nutshell

Layout: text

- **Index:** cut what the system produced into pieces and store them.
- **Retrieve:** find the pieces that answer your question.
- **Generate:** the model answers with those pieces in its context.
- In this module: each question searched two ways, by words (full-text in SQLite) and by meaning (vectors from a 23 MB model that runs on your laptop). Same steps at any size.

> RETRIEVE BEFORE YOU GENERATE

## The industry is building the same thing

Layout: prose

- Databricks, April 2026: "agents cite notebooks from earlier runs that were themselves wrong", and reuse them with more confidence. Their answer, MemCurrent (October 2026), keeps raw traces and distilled lessons. In their own test, success rate went from 22% to 68%.
- Open source you can research: La Roca, Mem0, Letta, Graphiti, LangMem. Traces: Langfuse, OpenTelemetry.
- Your cloud already ships it: AWS AgentCore Memory, Vertex Memory Bank, Azure Foundry.

## Where is the human?

Layout: text

- **Curating:** what gets stored, with what provenance, when to re-validate.
- **Reading:** time, cost, which model is right. Deciding the improvement: another model, another cap, a new skill.
- **Asking:** why did we decide this? Tell me what happened back then when it was decided.

> THE SYSTEM IMPROVES AS IT IS USED. ONLY IF SOMEONE LOOKS.

# Decided

- Hour 4 is its own prepared world, Northbank: four folders, `step-1` to `step-4`, the same ticket 010, one more memory each; the instructor shares the screen and everyone follows on their Mac (decision 8271).
- The theory of hour 4 is two talks, context engineering (deck 4b) and the four types of memory (this deck, 4a); the context window is the working memory of CoALA (decision 8271).
- A run of hour 3 still going when hour 4 starts is left going; the group reads what it left (decisions 8216 and 8218).

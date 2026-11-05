---
name: worker
description: How a worker of Northbank's graph takes one ticket of Harbour POS and turns it into code. Load it when an agent step of the path gives you a ticket, a folder and a report path.
---

You are a worker: step 2 of the path. You get one ticket, you deliver that ticket, and you
write your report. You do not know what came before and you will not be here after:
everything you need is in the ticket, `DOMAIN.md`, this skill and the standing orders of
your prompt.

## The ticket is the job

- The ticket is a brief with seven sections. `GOAL` is what the shop gets. `SCOPE` and
  `FORBIDDEN` are the fence. `ACCEPTANCE` and `VERIFY` are the judge: every line has to
  hold, and the command has to pass. `REPORT` says what goes in your report. The
  `STANDING ORDERS` of your prompt are Northbank's rules, and they always apply.
- Read `DOMAIN.md`: what the till does today and the decisions Northbank took. The
  examples of `ACCEPTANCE` are the test cases, with real numbers. Use them as they are.
- If the ticket and `DOMAIN.md` disagree, `DOMAIN.md` wins. Say so in your report.
- If your prompt names the previous step's `output.json` and `report.md`, you are in a
  second round: read them first. They say why the check said no.

## How you work

- The app is a browser page: plain JavaScript files that the page loads with `<script src=`.
- No modules and no Node: the browser runs the files exactly as they are.
- A test is `app/test/<name>.test.html` on `check.js`: one `check` per ACCEPTANCE line.
- `sh app/check.sh test` runs every test page in the browser, without a window.

1. Write the test first, from the examples. Run it and see it fail.
2. Write the smallest code that makes it pass. No extra features, no refactors of code the
   ticket does not name.
3. Run every test in `app/` (`sh app/check.sh test`), the typecheck (`sh app/check.sh
   typecheck`) and the lint (`sh app/check.sh lint`). All three green, or you are not done.
4. Write the report exactly where your prompt says, in the shape of `graph/REPORT.md`:
   four headings, `## Ticket`, `## Changed`, `## Checked`, `## Not done`, a blank line
   between sections, the files as a list with dashes, the output of the commands
   indented.

## What you never do

- Change a file outside the folder your prompt names. Not the graph, not `DOMAIN.md`, not
  the tickets. The node checks it, and a file outside is red.
- Change a test that already passed so that it passes again.

## Rules of the business

Rules Northbank learned the hard way. They hold in every ticket, even when the ticket does
not name them.

- A discount goes per line, never on the total of the sale, and each line is rounded to
  the penny. Otherwise the receipt and the accounting disagree by a penny now and then
  (Priya, 19 February).

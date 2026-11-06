---
name: reviewer
description: How a reviewer judges a Shop checkout ticket's result and ends with a verdict. Use for every review step of the Fil checkout.
---

# Reviewer: read, judge, never touch code

You never write or change code, tests or tickets. You read what the worker left and write
your report. Read the ticket, the worker's `report.md`, the changed files, then run
`sh app/check.sh lint` and `sh app/check.sh test` yourself.

## What you may block

You block for any of these three, and nothing else:

1. **Tests**: an ACCEPTANCE item with no test, a test that is skipped, weakened or
   deleted, or a test that fails.
2. **Lint**: `sh app/check.sh lint` is not clean.
3. **Design**: the code does not fit how this app is built (plain browser JavaScript, no
   modules, no dependency), goes outside the ticket's SCOPE, or breaks the contract of the
   ticket (names, money in cents).

Do not block for taste or style that the three above do not cover.

## What you can check against the business

- Money is whole cents. 13.99 is `1399`.
- The sticker comes off before VAT, and the discounted price is rounded down to the cent:
  19.99 at 30 % gives 13.99.
- No separate VAT line, VAT is included in the price.
- A return without a receipt is refused. An article never comes back more times than it
  was bought, over all returns of a sale.
- An empty basket, a zero price and a negative quantity are cases worth looking for.

## Your report

Follow `graph/REPORT.md`: `## Ticket`, `## Changed` (write `nothing`), `## Checked`,
`## Not done`. End with one last line, after a blank line:

- `Verdict: pass`
- or `Verdict: block`, and on the next line one sentence: the scenario, the line of the
  ticket or the rule it breaks.

A block goes back to the worker with your report. Be specific, so the worker can fix it.

---
name: worker
description: How a worker turns one Shop checkout ticket into code and tests, and the business rules it cannot guess. Use for every ticket of the Fil checkout.
---

# Worker: one ticket, test first

You are given one ticket. Read it, then `DOMAIN.md` and the change spec
`openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`. The ticket's SCOPE
and FORBIDDEN are your fence; its ACCEPTANCE and VERIFY say when you are done.

## How to work

1. Write the test first, in `app/test/<name>.test.html`, one `ok` or `FAIL` line per
   ACCEPTANCE item. Run it with the ticket's VERIFY command and see it red.
2. Write the smallest code that turns it green, in plain browser JavaScript under `app/`.
3. Run `sh app/check.sh lint` and `sh app/check.sh test`. Both must pass before you report.
4. Never weaken, skip or delete a test to get green.
5. If a previous report is given to you, read it first and fix exactly what it says.

## Business rules you cannot guess

- Money is whole cents, never decimals: 13.99 is `1399`.
- The discount sticker comes off the price **before** VAT, never after.
- The discounted price is rounded **down** to the cent, in the customer's favour:
  19.99 at 30 % gives 13.99.
- Prices include VAT. VAT is included in the price only: no separate VAT line on screen.
- Payment is card or cash, nothing else.
- A return needs its receipt. A return without a receipt is refused.
- Over all the returns of one sale, an article never comes back more times than it was
  bought.
- The cashier chooses the refund method, card or cash, for each return, whatever the
  original payment.
- The drawer at closing holds the cash taken minus the cash refunded.

## When to stop and ask

- The spec does not say it: do not guess. Report it as not done and say what is missing.
- The change needs a file outside the ticket's SCOPE: stop, do not touch it, say so.

## Your report

Follow `graph/REPORT.md` exactly: `## Ticket`, `## Changed`, `## Checked`, `## Not done`,
in this order. Under `## Checked`, the commands you ran and their last lines.

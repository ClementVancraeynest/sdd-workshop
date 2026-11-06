# 004 · Pay by cash

## GOAL
A cashier closes a basket by cash: the page takes the amount received and says how much
change to give back, and refuses an amount that is too short.

## SCOPE
May write: `app/payment.js`, `app/test/payment.test.html`.
May not write: any other file, in particular `app/basket.js`, `app/index.html`,
`app/check.sh`, `app/test/check.js`, `STANDING.md`, `graph/`, `openspec/`.

## CONTEXT
- Requirement "Payment by card or cash" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`.
- `DOMAIN.md`, decision 1: cash is accepted; the market shop takes almost a third of its Saturday sales in cash.
- Missing today: only `Payment.payByCard` exists. Depends on ticket 003.
- The contract: `Payment.payByCash(basket, receivedCents)` records and returns a sale shaped like the card one, with `method: "cash"`, `receivedCents` and `changeCents` equal to `receivedCents - totalCents`. If `receivedCents` is below the total it throws an `Error` whose message contains `not enough` and records nothing.

## ACCEPTANCE
1. Pay by cash with change: a basket of 3550 paid with 4000 received is recorded with `method` "cash" and `changeCents` 450.
2. Cash received is not enough: a basket of 3550 with 3000 received throws an error containing "not enough", and `Payment.sales` does not grow.

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. Add one `check()` or
`checkThrows()` per ACCEPTANCE line, 1 and 2, to `app/test/payment.test.html`; the tests of
ticket 003 stay as they are.

## FORBIDDEN
- Returns, closing: other tickets.
- Weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

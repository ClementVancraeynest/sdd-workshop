# 006 · Refund method

## GOAL
For each return, the cashier chooses to refund to the card or in cash from the drawer,
whatever the way the customer paid, and the page records the choice.

## SCOPE
May write: `app/returns.js`, `app/test/returns.test.html`.
May not write: any other file, in particular `app/basket.js`, `app/payment.js`,
`app/index.html`, `app/check.sh`, `app/test/check.js`, `STANDING.md`, `graph/`, `openspec/`.

## CONTEXT
- Requirement "Refund method" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`.
- Group decision: the cashier chooses card or cash for each return, whatever the payment method of the original sale.
- Missing today: `Returns.create` takes no method and keeps no record. Depends on ticket 005.
- The contract: `Returns.create(receipt, items, method)` where `method` is `"card"` or `"cash"`; the returned refund has `method`, and it is added to `Returns.list` as before. Any other `method` throws an `Error` whose message contains `method` and records nothing. A return refused for any reason records nothing.

## ACCEPTANCE
1. Cash sale refunded to the card: a sale paid in cash, returned with method "card", is recorded with `method` "card".
2. Card sale refunded in cash: a sale paid by card, returned with method "cash", is recorded with `method` "cash".
3. No other method: `Returns.create` with method "cheque" throws an error containing "method", and `Returns.list` does not grow.

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. Add one `check()` or
`checkThrows()` per ACCEPTANCE line, 1 to 3, to `app/test/returns.test.html`; update the
calls of ticket 005's tests only to pass a method, never to change what they check.

## FORBIDDEN
- The drawer view: another ticket.
- Weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

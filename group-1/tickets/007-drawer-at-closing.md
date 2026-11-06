# 007 · Drawer at closing

## GOAL
At closing time the page says how much cash the drawer must hold, so Claire's Sunday morning
is no longer spent finding out why the drawer and the paper notes do not match.

## SCOPE
May write: `app/closing.js` (new), `app/test/closing.test.html` (new).
May not write: any other file, in particular `app/basket.js`, `app/payment.js`,
`app/returns.js`, `app/index.html`, `app/check.sh`, `app/test/check.js`, `STANDING.md`,
`graph/`, `openspec/`.

## CONTEXT
- Requirement "Drawer at closing" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`.
- `DOMAIN.md`: done, for Claire, means the drawer matches the screen at closing.
- Missing today: nothing adds up the day. Depends on tickets 004 and 006 (`Payment`, `Returns`).
- The contract: `Closing.expectedCashCents()` returns, in cents, the sum over the cash sales of `receivedCents - changeCents`, minus the sum of `amountCents` over the cash refunds of `Returns.list`. Card sales and card refunds count for nothing. The test page loads the three other scripts first.

## ACCEPTANCE
1. Drawer after sales and a refund: one cash sale of 3550 paid with 4000, and one cash refund of 1400, give 2150.
2. Card does not touch the drawer: only card sales and card refunds give 0.

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. The test page
`app/test/closing.test.html` calls `Payment.reset()` and `Returns.reset()` first and has one
`check()` per ACCEPTANCE line, 1 and 2.

## FORBIDDEN
- The cashier screen: another ticket.
- Weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

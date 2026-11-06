# 003 · Pay by card

## GOAL
A cashier closes a basket by card, and the sale is recorded with a receipt number the
customer can bring back later.

## SCOPE
May write: `app/payment.js` (new), `app/test/payment.test.html` (new).
May not write: any other file, in particular `app/basket.js`, `app/index.html`,
`app/check.sh`, `app/test/check.js`, `STANDING.md`, `graph/`, `openspec/`.

## CONTEXT
- Requirement "Payment by card or cash" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`.
- `DOMAIN.md`, decision 1: the shops take card and cash. 78 % of sales are by card.
- Missing today: nothing records a sale. Depends on ticket 001 (`Basket`).
- The contract, one global in `app/payment.js` (no modules):
  - `Payment.reset()` empties the list of sales.
  - `Payment.sales` is the list of recorded sales, in order.
  - `Payment.payByCard(basket)` records and returns a sale `{ receipt, lines, totalCents, method: "card", receivedCents, changeCents }` with `receipt` `"R-1"`, `"R-2"`... in order, `receivedCents` equal to `totalCents` and `changeCents` 0. `lines` is a copy of the basket's lines.
  - It uses `Basket.total`; the test page loads `../basket.js` before `../payment.js`.

## ACCEPTANCE
1. Pay by card: a basket of 3550 closed by card is recorded as a sale with `method` "card" and `totalCents` 3550.
2. Receipt numbers: two sales in a row get the receipts "R-1" and "R-2".

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. The test page
`app/test/payment.test.html` calls `Payment.reset()` first and has one `check()` per
ACCEPTANCE line, 1 and 2.

## FORBIDDEN
- Cash, returns, closing: other tickets.
- Weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

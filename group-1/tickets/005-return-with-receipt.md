# 005 · Return with the receipt

## GOAL
A cashier returns part of a sale by its receipt and the page gives the exact refund, the
price the customer actually paid. A return without a receipt is refused.

## SCOPE
May write: `app/returns.js` (new), `app/test/returns.test.html` (new).
May not write: any other file, in particular `app/basket.js`, `app/payment.js`,
`app/index.html`, `app/check.sh`, `app/test/check.js`, `STANDING.md`, `graph/`, `openspec/`.

## CONTEXT
- Requirement "Return with the receipt" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`.
- `DOMAIN.md`, decision 3: returns without a receipt are refused. Last month 6 of 41 returns were refunded with the wrong amount.
- Missing today: nothing handles returns. Depends on tickets 002 and 003 (`Basket`, `Payment`).
- The contract, one global in `app/returns.js` (no modules):
  - `Returns.create(receipt, items)` where `items` is a list of `{ name, quantity }`. It finds the sale in `Payment.sales` by `receipt` and returns `{ receipt, items, amountCents }`, where `amountCents` is, for each item, the line's `priceCents` of that sale times the quantity returned.
  - With no `receipt`, or one no sale has, it throws an `Error` whose message contains `receipt`.
  - If an item's quantity, added to what earlier returns of the same sale already took back, is above the quantity of that line in the sale, or the sale has no such line, it throws an `Error` whose message contains `more than`.
  - Each accepted return is added to `Returns.list`, in order; a refused one records nothing. `Returns.reset()` empties `Returns.list`.
  - The test page loads `../basket.js`, `../payment.js`, then `../returns.js`.

## ACCEPTANCE
1. Partial return: a sale of two shirts at 1400 each, one returned, gives an `amountCents` of 1400.
2. Return of a discounted product: a product sold at 1399 after a sticker, returned, gives 1399, never the price before the sticker.
3. Return without a receipt: `Returns.create` with no receipt throws an error containing "receipt".
4. Cannot return more than was bought: a sale of one shirt, two returned, throws an error containing "more than".
5. Cannot return the same article twice: a sale of one shirt, returned once, then returned again, throws an error containing "more than" and `Returns.list` holds only the first return.

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. The test page
`app/test/returns.test.html` calls `Payment.reset()` and `Returns.reset()`, makes its sales with `Payment.payByCard`,
and has one `check()` or `checkThrows()` per ACCEPTANCE line, 1 to 5.

## FORBIDDEN
- The refund method and the drawer: other tickets.
- Weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

# 001 · Basket total

## GOAL
A cashier can add products to a basket and see the total of what the customer owes. Prices
already include VAT, and no VAT line is ever shown.

## SCOPE
May write: `app/basket.js` (new), `app/test/basket.test.html` (new).
May not write: any other file, in particular `app/index.html`, `app/check.sh`,
`app/test/check.js`, `STANDING.md`, `graph/`, `openspec/`.

## CONTEXT
- Requirement "Basket total" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`.
- `DOMAIN.md`, decision 2: VAT is included in the price, with no separate VAT line.
- Missing today: `app/` holds only the home page; there is no basket.
- Depends on nothing. Money is whole cents (a price of 20.00 is `2000`).
- The contract, as one global in `app/basket.js` (no modules):
  - `Basket.create()` returns an empty basket `{ lines: [] }`.
  - `Basket.add(basket, product, quantity)` where `product` is `{ name, priceCents }`. Adding a product whose `name` is already in the basket raises that line's quantity; otherwise it adds a line `{ name, priceCents, quantity }`.
  - `Basket.total(basket)` returns the sum of `priceCents * quantity` over the lines, in cents.

## ACCEPTANCE
1. Add products: a product at 20.00 and a product at 15.50 give a total of 3550.
2. Same product twice: the same product at 20.00 added twice gives one line with quantity 2 and a total of 4000.
3. No VAT line: the basket and its total hold no VAT amount, only the lines and the total.

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. The test page
`app/test/basket.test.html` loads `check.js` and `../basket.js` and calls `check()` once per
ACCEPTANCE line, 1 to 3.

## FORBIDDEN
- Stickers, payment, returns, closing: other tickets.
- Weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

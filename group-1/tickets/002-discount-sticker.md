# 002 · Discount sticker

## GOAL
A product with a discount sticker is added to the basket at its discounted price, worked out
by the page instead of the cashier's calculator. The discounted price is rounded down to the
cent, in the customer's favour.

## SCOPE
May write: `app/basket.js`, `app/test/basket.test.html`.
May not write: any other file, in particular `app/index.html`, `app/check.sh`,
`app/test/check.js`, `STANDING.md`, `graph/`, `openspec/`.

## CONTEXT
- Requirement "Discount sticker" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`.
- `DOMAIN.md`: a sticker comes off the price before VAT, never after. Group decision: the discounted price is rounded down to the cent (19.99 at 30 % is 13.99).
- Missing today: `Basket.add` ignores any sticker. Depends on ticket 001.
- The contract: a `product` may carry `stickerPercent`, a whole number from 0 to 100. The line's `priceCents` is the discounted unit price, `Math.floor(priceCents * (100 - stickerPercent) / 100)`, then multiplied by the quantity in the total. With no `stickerPercent` nothing changes.

## ACCEPTANCE
1. Sticker on a product: a product at 20.00 with a 30 % sticker has a line price of 1400 and a total of 1400.
2. Rounding in the customer's favour: a product at 19.99 with a 30 % sticker has a line price of 1399, not 1400.

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. Add one `check()` per
ACCEPTANCE line, 1 and 2, to `app/test/basket.test.html`; the tests of ticket 001 stay as they are.

## FORBIDDEN
- Payment, returns, closing: other tickets. No VAT line.
- Weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

## Why

Fil, three clothing shops in Lyon, has tills that are no longer supported. A cashier works
out discount stickers on a calculator and writes returns on paper notes: last month 6 of
41 returns were refunded with the wrong amount, and at closing the drawer and the notes do
not match. Fil needs a checkout page on a tablet before the January sales.

## What Changes

- A basket: the cashier adds products and sees the total, VAT included, with no separate
  VAT line.
- Discount stickers: a percentage taken off the price before VAT, rounded down to the cent
  in the customer's favour.
- Payment by card or by cash; for cash, the amount received and the change to give back.
- Returns of part of a sale, only with the receipt; the cashier chooses to refund to the
  card or in cash from the drawer.
- A closing view: the cash the drawer must hold, so it matches the screen.

Out: returns without a receipt (refused), a separate VAT line on screen.

## Capabilities

### New Capabilities
- `checkout`: basket, discount stickers, payment, returns with a receipt, and the drawer at closing.

### Modified Capabilities
None. The `home-page` spec stays as it is.

## Impact

Only the page in `app/` and its tests.

## Context

Fil needs a checkout on a tablet at each counter. The group decided: card and cash; VAT
included in the price with no separate line; returns without a receipt refused; the
cashier chooses the refund method per return; a discounted price is rounded down to the
cent. The app today is one page, `app/index.html`, titled Shop checkout.

## Goals / Non-Goals

**Goals:**
- Every scenario of the `checkout` spec holds and is proved by a test page.
- The drawer matches the screen at closing.

**Non-Goals:**
- Returns without a receipt.
- A VAT line on screen.

## Decisions

- The sticker applies to the unit price: the discounted unit price is rounded down to the
  cent, then multiplied by the quantity.
- A refund is the discounted unit price paid, times the number of items returned.
- The page is HTML, CSS and JavaScript in the browser, as `STANDING.md` describes.

## Risks / Trade-offs

- Rounding down loses at most one cent per unit for Fil; the client accepted it.

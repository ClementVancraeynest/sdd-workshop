# 008 · Cashier screen

## GOAL
The cashier works on one page on the tablet: adds products, sees the total, takes payment
and sees the change, with the product name Shop checkout still at the top.

## SCOPE
May write: `app/index.html`, `app/test/screen.test.html` (new).
May not write: any other file, in particular the scripts `app/basket.js`, `app/payment.js`,
`app/returns.js`, `app/closing.js`, `app/check.sh`, `app/test/check.js`, `STANDING.md`,
`graph/`, `openspec/`.

## CONTEXT
- Requirements "Basket total" and "Payment by card or cash" of `openspec/changes/checkout-basket-and-returns/specs/checkout/spec.md`, and the "Product name on the home page" requirement of `openspec/specs/home-page/spec.md`, which must still hold.
- Group decision (decision 2): VAT is included in the price, and no VAT line is shown.
- Missing today: `app/index.html` is only a heading. Depends on tickets 002 and 004.
- The contract: the page loads `basket.js` and `payment.js`; it has a form to add a product (name, price in euros, quantity, sticker percent), an element `id="total"` with the basket total in euros, buttons "Pay by card" and "Pay by cash", an input `id="received"` for cash, and an element `id="change"` with the change after a cash sale. A refusal shows its message in `id="message"`.

## ACCEPTANCE
1. Product name: the page title and the main heading both read "Shop checkout".
2. Total on screen: after adding a product at 20.00 and a product at 15.50, `#total` reads "35.50".
3. Change on screen: after paying that basket by cash with 40.00 received, `#change` reads "4.50".
4. Short cash: with 30.00 received, `#message` says the amount is not enough and no sale is closed.
5. No VAT line: the page text contains no "VAT".

## VERIFY
Run `sh app/check.sh test` and `sh app/check.sh lint`: both green. The test page
`app/test/screen.test.html` loads `../index.html` in a frame, drives the form, and has one
`check()` per ACCEPTANCE line, 1 to 5.

## FORBIDDEN
- Returns and the closing view on screen: not part of this ticket.
- Changing the scripts of other tickets; weakening, skipping or deleting a test; adding a dependency or any file outside SCOPE.

## REPORT
Done or blocked; the files changed; the tests that ran; the output of `sh app/check.sh test`.

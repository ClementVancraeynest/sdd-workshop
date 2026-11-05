## Ticket
tickets/010-sale-discount.md: reviewed, blocked on a business rule

## Changed
nothing

## Checked
- Read app/sale.js and app/test/discount.test.html against the four ACCEPTANCE lines: each has a test, and the examples come out right.
- Worked the rule "discount per line, rounded per line" by hand: three lines of 17p with 10% off must total 45p (each line 17p - 2p = 15p). `receipt` computes `Math.round(subtotal * percent / 100)` on the subtotal: 51p - 5p = 46p.

## Not done
- No test covers several small lines, so the tests do not catch the subtotal-percentage error.

Verdict: block
app/sale.js takes the percentage of the subtotal in `receipt` instead of per line rounded to the penny (three 17p lines at 10% give 46p, must be 45p).

## Ticket
tickets/010-sale-discount.md: reviewed, the change does what it asks

## Changed
nothing

## Checked
- app/sale.js: `discountOf` rounds each line on its own and adds them up, so three lines of 17p at 10% give 45p, not 46p.
- app/test/discount.test.html has a check for each ACCEPTANCE line.
`sh app/check.sh test`:
    ok 10% off one line shows the discount and the total after it
    ok 10% off two lines is taken per line
    ok a percentage above 100 throws
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh lint` and `sh app/check.sh typecheck`: no output, exit 0

## Not done
- Comment only: the percentage is not checked to be a whole number, and the ticket does not ask for it.

Verdict: pass

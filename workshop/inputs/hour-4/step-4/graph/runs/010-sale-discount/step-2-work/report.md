## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test`:
    ok 10% off one line shows the discount and the total after it
    ok 10% off two lines is taken per line
    ok rounding happens per line, to the penny
    ok no percentage gives the receipt of today
    ok a percentage of 0 gives the receipt of today, with no Discount line
    ok a percentage below 0 throws
    ok a percentage above 100 throws
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

The test page failed first (five red checks), then went green with the code. The discount is per line, each line rounded to the penny, as Priya said in the ticket's CONTEXT.

## Not done
nothing

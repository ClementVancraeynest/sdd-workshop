## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test`:
    ok 10% off one line shows the discount and the total
    ok 10% off two lines
    ok no percentage gives the receipt without a discount line
    ok a percentage of 0 gives the receipt without a discount line
    ok a percentage below 0 throws
    ok a percentage above 100 throws
    ok the discount is rounded per line to the penny
    ok the subtotal adds every line
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing

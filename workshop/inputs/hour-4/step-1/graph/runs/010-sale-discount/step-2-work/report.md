## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test`:
    ok 10% off one scarf shows the discount and the total
    ok 10% off two lines ends with subtotal, discount and total
    ok no percentage gives the receipt as today
    ok a percentage of 0 gives the receipt as today
    ok a percentage below 0 throws
    ok a percentage above 100 throws
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing. Note: neither the ticket nor DOMAIN.md says how to round a discount that is not a whole number of pence; the code rounds to the nearest penny, and no example depends on it.

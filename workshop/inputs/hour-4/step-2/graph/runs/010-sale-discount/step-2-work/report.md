## Ticket
tickets/010-sale-discount.md: done

## Changed
- app/sale.js
- app/test/discount.test.html

## Checked
`sh app/check.sh test`:
    ok the page exists and has a title
    ok 10% off one line shows the discount and the total
    ok 10% off two lines ends with the subtotal, the discount and the total
    ok the discount is rounded to the penny on each line, not on the total
    ok no percentage gives the receipt of today
    ok 0% gives the receipt of today, with no Discount line
    ok a percentage below 0 throws
    ok a percentage above 100 throws
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing. DOMAIN.md says a discount goes per line and each line is rounded to the penny, so the code takes the percentage off each line and rounds per line (the ticket's examples give the same numbers). The test also has a per-line rounding case (two lines of £1.05 at 10% give -£0.22). Non-whole percentages also throw the same error.

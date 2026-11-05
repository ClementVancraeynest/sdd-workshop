## Ticket
tickets/010-sale-discount.md: reviewed, the work is done

## Changed
nothing

## Checked
`sh app/check.sh test`: every check ok, last lines:
    ok the subtotal adds every line
    ok the receipt lists the lines, the subtotal and the total
`sh app/check.sh lint`: no output, exit 0
- Each ACCEPTANCE line has its own check in app/test/discount.test.html (examples 1 and 2, no percentage, 0, below 0, above 100).
- Business rule: `receipt` in app/sale.js takes the discount per line (`lineDiscount`, rounded with Math.round) and adds the lines up, never a percentage of the subtotal. By hand, 105p + 105p at 10% gives 11p + 11p = 22p off, total £1.88, which the new test checks.
- No Node, module or dependency; the existing sale test page is unchanged.

## Not done
nothing

Verdict: pass

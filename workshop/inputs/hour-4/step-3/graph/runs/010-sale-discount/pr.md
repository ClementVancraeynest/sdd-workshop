The cashier can give a sale a percentage off, for a customer with a voucher: the receipt
shows the discount under the subtotal, and the total to pay after it.

**Changed** (step-2-work)
- app/sale.js
- app/test/discount.test.html

**Checked**
```
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
```

**Reviewer** (step-4-review): pass. Nothing

Run `010-sale-discount`: never went back to the worker; journal in `graph/runs/010-sale-discount/journal.jsonl`.

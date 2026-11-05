The cashier can give a sale a percentage off, for a customer with a voucher: the receipt
shows the discount under the subtotal, and the total to pay after it.

**Changed** (step-2-work)
- app/sale.js
- app/test/discount.test.html

**Checked**
```
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
```

**Reviewer** (step-4-review): pass. - Comment only: the per-line rounding is tested with two 105p lines, not with the 17p example; the code is right. - Comment only: non-whole percentages such as 10.5 also throw, which the ticket does not mention.

Run `010-sale-discount`: never went back to the worker; journal in `graph/runs/010-sale-discount/journal.jsonl`.

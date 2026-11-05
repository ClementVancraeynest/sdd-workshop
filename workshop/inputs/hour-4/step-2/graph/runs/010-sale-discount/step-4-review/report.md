## Ticket
tickets/010-sale-discount.md: reviewed, the work is done

## Changed
nothing

## Checked
`sh app/check.sh test`: every check ok, exit 0, including the seven checks of `app/test/discount.test.html` and the existing sale checks.
    ok a percentage below 0 throws
    ok a percentage above 100 throws
`sh app/check.sh lint` and `sh app/check.sh typecheck`: no output, exit 0
Read `app/sale.js`: the discount is taken per line and rounded per line (`lineDiscount`), never from the subtotal. By hand, three lines of 17p at 10% give 2p off each, 45p in all, not 46p. ACCEPTANCE 1 to 4 each have a test; `sale.test.html` is untouched; no Node, module or dependency.

## Not done
- Comment only: the per-line rounding is tested with two 105p lines, not with the 17p example; the code is right.
- Comment only: non-whole percentages such as 10.5 also throw, which the ticket does not mention.

Verdict: pass

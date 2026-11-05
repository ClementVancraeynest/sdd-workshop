# Copilot CLI Session

> [!NOTE]
> - **Session ID:** `9e412430-1514-4c44-8f27-ec61eabe330e`  
> - **Started:** 11/5/2026, 12:00:44 PM  
> - **Duration:** 22s  
> - **Exported:** 11/5/2026, 12:01:06 PM  

---

<sub>1s</sub>

### User

Read /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/.github/skills/reviewer/SKILL.md first. Your folder is /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4: every file you read or write is inside it. Do the ticket in /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/tickets/010-sale-discount.md. Touch only files under /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/app/. When you finish, write /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/step-4-review/report.md following /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/graph/REPORT.md exactly. Do not run git. Stop when the report is written. People who do not program are watching you work in a terminal. They see two things: what you say, and the description of each command. So: give every command a short description in plain words, what it is for, never the command itself. Before each step, say in one plain sentence what you are going to do and why; after a test or a check, say in one sentence what it showed.
STANDING ORDERS:
# Standing orders

One rule per line. The graph pastes this file, as it is, into the brief of every worker and
reviewer.

1. Change only the files your SCOPE allows.
2. Never weaken, skip or delete a test to get green.
3. Never guess a business rule. If the ticket and DOMAIN.md do not say it, report blocked and say what is missing.
4. Write code, tests and reports in English.
5. The app runs in a browser and nowhere else: HTML, CSS and JavaScript exactly as a browser loads them. No Node, no npm, no modules (`import`, `export`, `require`), no build step, no dependency. A test is a page, `app/test/<name>.test.html`, that `app/check.sh test` runs in the browser; it prints one `ok` or `FAIL` line per check. `app/check.sh lint` is red otherwise.

---

<sub>5s</sub>

### `view`

**view the file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/.github/skills/reviewer/SKILL.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/.github/skills/reviewer/SKILL.md

<details>
<summary>34 lines</summary>

```
---
name: reviewer
description: How the reviewer of Northbank's graph judges a change of Harbour POS it did not write. Load it when an agent step of the path gives you a ticket, a folder and a report path, as the reviewer.
---

You are the reviewer: step 4 of the path. You did not write this code and you will not fix
it: you change no file but your report. You read what the worker left in the folder against
the ticket and you give a verdict. Judgment without authorship.

## What you may block

Only two things:

1. **What breaks the ticket or its proof of done.** The code does not do what the
   ticket says; an ACCEPTANCE line has no test, or its test checks something else; a test
   that passed before was changed to pass again; a file outside the ticket's `SCOPE`
   changed; a line of the standing orders was broken.
   A change that brings Node, npm, a module or a network script is blocked: `lint` says it.
2. **What breaks a rule of the business**, listed below. The worker may not know these
   rules; you do. Check each one that the change touches by reading the code and working
   out its example by hand.

Everything else is a comment, not a block: naming, style, edge cases the ticket does not
mention, a test you would have added, features the ticket does not ask for. Write them
under `## Not done` as comments, and still pass.

## The verdict

Write the report exactly where your prompt says, in the shape of `graph/REPORT.md` (the
four headings `## Ticket`, `## Changed`, `## Checked`, `## Not done`, a blank line between
sections; under `## Changed` write "nothing"), and then, after a blank line, one more
line:

- `Verdict: pass` approves.
- `Verdict: block` blocks, and the next line says why in one sentence: which line of the
  ticket or rule below it breaks, with the file.

## Rules of the business

- Prices are whole pence in the code; only the receipt shows pounds.
- A discount goes per line, never on the total of the sale, and each line is rounded to
  the penny (Priya, 19 February). Example: three lines of 17p with 10% off come to 45p
  (each line 17p - 2p = 15p), never 46p (51p - 5p). Code that takes the percentage of the
  subtotal breaks this rule, even when the ticket's own examples come out the same.
```

</details>


---

<sub>5s</sub>

### `view`

**view the file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/tickets/010-sale-discount.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/tickets/010-sale-discount.md

<details>
<summary>38 lines</summary>

```
# 010 · A discount on a sale

## GOAL

The cashier can give a sale a percentage off, for a customer with a voucher: the receipt
shows the discount under the subtotal, and the total to pay after it.

## SCOPE

May write: `app/sale.js` and a new test page `app/test/discount.test.html`.
May not write: anything else, `app/test/sale.test.html` and `app/index.html` included.

## CONTEXT

Northbank's decisions are in `DOMAIN.md`: read them before you start. Today
`receipt(lines)` in `app/sale.js` knows no discount: `grep -c discount app/sale.js`
prints 0. This ticket adds a second argument, the percentage off, a whole number from 0
to 100: `receipt(lines, percent)`. It depends on nothing else.

From Northbank's memory, before launch. The chief asked
`sh memory/memory.sh ask --example "does a discount apply per line or on the total?"`
and it found the conversation `example-team/conversations/2026-02-19-chief-and-priya-discounts.md`,
where Priya said: "Always per line, never on the basket total. And rounding happens per
line, to the penny. Otherwise the receipt and the accounting disagree by a penny now and
then, and the shops call us." So the discount of this ticket goes per line, never on the
total of the sale, and each line is rounded to the penny.

## ACCEPTANCE

1. `receipt([{ name: "Wool scarf", pence: 2000, qty: 1 }], 10)` is
   `["1 x Wool scarf  £20.00", "Subtotal  £20.00", "Discount 10%  -£2.00", "Total  £18.00"]`.
2. `receipt([{ name: "Wool scarf", pence: 2000, qty: 1 }, { name: "Tea towel", pence: 350, qty: 2 }], 10)`
   ends with `"Subtotal  £27.00", "Discount 10%  -£2.70", "Total  £24.30"`.
3. With no percentage, or 0, the receipt is the same as today: no `Discount` line.
4. A percentage below 0 or above 100 throws an Error whose message says
   `discount must be 0 to 100`.

## VERIFY

`sh app/check.sh test`: every check green, with the new page
`app/test/discount.test.html`, one `check` (or `checkThrows`) per ACCEPTANCE line.

## FORBIDDEN

- Changing `app/test/sale.test.html` or any test that passes today.
- A new dependency, a module, Node or a build step.
- Anything this ticket does not ask: no discount per product chosen by the cashier, no
  vouchers stored, no page changes.

## REPORT

Done or blocked; the files changed; the commands that ran (`sh app/check.sh test`, `lint`,
`typecheck`) with their last lines; what was not done and why.
```

</details>


---

<sub>5s</sub>

### `view`

**view the file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/graph/REPORT.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4/graph/REPORT.md

<details>
<summary>35 lines</summary>

````
# How an agent step reports

Every agent step ends by writing its `report.md` in Markdown: four headings, in this
order, each `## ` at the start of its own line, a blank line between sections, lists with a
dash, command output indented four spaces. The node checks that the four headings are
there; a report without one of them is red.

```markdown
## Ticket
tickets/001-basket-total.md: done

## Changed
- app/basket.js
- app/test/basket.test.html

## Checked
`sh app/check.sh test`:
    ok the basket adds two lines
    ok the total is 23.50 for 12.00 and 11.50
`sh app/check.sh typecheck` and `sh app/check.sh lint`: no output, exit 0

## Not done
nothing
```

What goes under each heading:

- `## Ticket`: the ticket you were given, and in a few words whether it is done or blocked.
- `## Changed`: every file you changed or created, one per line with a dash, or `nothing`.
- `## Checked`: the commands you ran to prove it, and what they printed (the last lines).
- `## Not done`: what the ticket asked and you did not do, and why; or `nothing`.

Reviewers only, one more line at the end, after a blank line, one of these two:

```markdown
Verdict: pass
```

```markdown
Verdict: block
The ticket asks for a test of a zero price and there is none.
```

After `Verdict: block`, the next line says why, in one sentence: the scenario, the line of
the ticket or the rule it breaks. The node reads it: `block` is red, and the path goes back
to the worker.
````

</details>


---

<sub>6s</sub>

### Copilot

I'm the reviewer, so I'll read the worker's code and tests.

---

<sub>7s</sub>

### `bash`

**Read the worker's code and test**

$ cd /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4 && cat app/sale.js && cat app/test/discount.test.html

<details>
<summary>80 lines</summary>

```
// Harbour POS: one sale on the till, and its receipt.
// A sale is a list of lines, one per product: { name: "Wool scarf", pence: 2000, qty: 1 }.
// Prices are whole pence; only the receipt shows pounds.

// money(pence): pence as the receipt shows them, "£20.00", "-£2.00".
function money(pence) {
  var sign = pence < 0 ? "-" : "";
  var p = Math.abs(pence);
  var rest = String(p % 100);
  if (rest.length < 2) rest = "0" + rest;
  return sign + "£" + Math.floor(p / 100) + "." + rest;
}

// lineTotal(line): what one line costs, in pence.
function lineTotal(line) {
  return line.pence * line.qty;
}

// subtotal(lines): every line added up, in pence.
function subtotal(lines) {
  var sum = 0;
  for (var i = 0; i < lines.length; i++) sum += lineTotal(lines[i]);
  return sum;
}

// discountOf(lines, percent): the money taken off, in pence. Each line is discounted on its
// own and rounded to the penny, never on the total of the sale.
function discountOf(lines, percent) {
  var sum = 0;
  for (var i = 0; i < lines.length; i++) sum += Math.round(lineTotal(lines[i]) * percent / 100);
  return sum;
}

// receipt(lines, percent): the receipt of the sale, one string per printed line: each
// product, then the subtotal, then the discount when percent (0 to 100) is above 0, then
// the total to pay.
function receipt(lines, percent) {
  if (percent === undefined || percent === null) percent = 0;
  if (typeof percent !== "number" || !(percent >= 0 && percent <= 100)) {
    throw new Error("discount must be 0 to 100");
  }
  var out = [];
  for (var i = 0; i < lines.length; i++) {
    out.push(lines[i].qty + " x " + lines[i].name + "  " + money(lineTotal(lines[i])));
  }
  out.push("Subtotal  " + money(subtotal(lines)));
  var off = discountOf(lines, percent);
  if (percent > 0) out.push("Discount " + percent + "%  " + money(-off));
  out.push("Total  " + money(subtotal(lines) - off));
  return out;
}
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>discount</title>
</head>
<body>
  <pre id="result"></pre>
  <script src="check.js"></script>
  <script src="../sale.js"></script>
  <script>
    var scarf = { name: "Wool scarf", pence: 2000, qty: 1 };
    var towel = { name: "Tea towel", pence: 350, qty: 2 };
    check("10% off one line shows the discount and the total after it",
      receipt([scarf], 10),
      ["1 x Wool scarf  £20.00", "Subtotal  £20.00", "Discount 10%  -£2.00", "Total  £18.00"]);
    check("10% off two lines is taken per line",
      receipt([scarf, towel], 10).slice(-3),
      ["Subtotal  £27.00", "Discount 10%  -£2.70", "Total  £24.30"]);
    check("rounding happens per line, to the penny",
      receipt([{ name: "Pen", pence: 105, qty: 1 }, { name: "Pad", pence: 105, qty: 1 }], 25).slice(-3),
      ["Subtotal  £2.10", "Discount 25%  -£0.52", "Total  £1.58"]);
    check("no percentage gives the receipt of today",
      receipt([scarf, towel]),
      ["1 x Wool scarf  £20.00", "2 x Tea towel  £7.00", "Subtotal  £27.00", "Total  £27.00"]);
    check("a percentage of 0 gives the receipt of today, with no Discount line",
      receipt([scarf], 0),
      ["1 x Wool scarf  £20.00", "Subtotal  £20.00", "Total  £20.00"]);
    checkThrows("a percentage below 0 throws", function () { receipt([scarf], -1); }, "discount must be 0 to 100");
    checkThrows("a percentage above 100 throws", function () { receipt([scarf], 101); }, "discount must be 0 to 100");
  </script>
</body>
</html>
<shellId: 0 completed with exit code 0>
```

</details>


---

<sub>10s</sub>

### Copilot

Next I'll run the tests and lint to see whether they pass.

---

<sub>11s</sub>

### `bash`

**Run tests, lint and typecheck**

$ cd /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-4 && sh app/check.sh test 2>&1 | tail -15; sh app/check.sh lint 2>&1 | tail -3; echo lint=$?; sh app/check.sh typecheck 2>&1 | tail -3

<details>
<summary>16 lines</summary>

```
ok the page exists and has a title
ok 10% off one line shows the discount and the total after it
ok 10% off two lines is taken per line
ok rounding happens per line, to the penny
ok no percentage gives the receipt of today
ok a percentage of 0 gives the receipt of today, with no Discount line
ok a percentage below 0 throws
ok a percentage above 100 throws
ok money shows pence as pounds
ok money shows a single penny with two digits
ok money shows money taken off with a minus
ok a line costs its price times its quantity
ok the subtotal adds every line
ok the receipt lists the lines, the subtotal and the total
lint=0
<shellId: 1 completed with exit code 0>
```

</details>


---

<sub>14s</sub>

### Copilot

The code works per line and each line is rounded, so I'm writing the report.

---

<sub>16s</sub>

### `bash` — Failed

**Write the review report**

$ cd /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount && mkdir -p step-4-review && cat > step-4-review/report.md <<'EOF'
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
EOF

```
Permission denied because no interactive user response was available. Retry in an interactive session so the user can approve it, or try an alternative that does not require this permission.
```


---

<sub>19s</sub>

### `create`

**create a new file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/step-4-review/report.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/step-4-review/report.md

```
Created file /Users/you/sdd-workshop/workshop/inputs/hour-4/step-4/graph/runs/010-sale-discount/step-4-review/report.md with 740 characters
```


---

<sub>22s</sub>

### Copilot

I reviewed ticket 010 and passed it. I wrote the report to `step-4-review/report.md` with `Verdict: pass`.

- **Per line:** the discount is worked out and rounded on each line, then added up. Three lines of 17p at 10% off give 45p, not 46p, so Priya's rule holds.
- **Acceptance:** each of the four acceptance lines has a test in `app/test/discount.test.html`.
- **Checks:** `sh app/check.sh test` showed every check green. `lint` and `typecheck` printed nothing.
- **One comment, not a block:** the percentage isn't checked to be a whole number. The ticket doesn't ask for that.

My first attempt to write the report from the shell was refused, so I wrote it with the file-creation tool instead.

---

<sub>Generated by [GitHub Copilot CLI](https://github.com/features/copilot/cli)</sub>

# Copilot CLI Session

> [!NOTE]
> - **Session ID:** `becf6d6d-46e9-4575-9162-91cd5b4b5ecc`  
> - **Started:** 11/5/2026, 11:57:48 AM  
> - **Duration:** 18s  
> - **Exported:** 11/5/2026, 11:58:06 AM  

---

<sub>1s</sub>

### User

Read /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/.github/skills/reviewer/SKILL.md first. Your folder is /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1: every file you read or write is inside it. Do the ticket in /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/tickets/010-sale-discount.md. Touch only files under /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/app/. When you finish, write /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/step-4-review/report.md following /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/graph/REPORT.md exactly. Do not run git. Stop when the report is written. People who do not program are watching you work in a terminal. They see two things: what you say, and the description of each command. So: give every command a short description in plain words, what it is for, never the command itself. Before each step, say in one plain sentence what you are going to do and why; after a test or a check, say in one sentence what it showed.
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

<sub>4s</sub>

### `view`

**view the file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/.github/skills/reviewer/SKILL.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/.github/skills/reviewer/SKILL.md

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

<sub>4s</sub>

### `view`

**view the file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/tickets/010-sale-discount.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/tickets/010-sale-discount.md

<details>
<summary>31 lines</summary>

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

<sub>4s</sub>

### `view`

**view the file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/graph/REPORT.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1/graph/REPORT.md

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

I'm the reviewer: I read the worker's code and tests.

---

<sub>7s</sub>

### `bash`

**Read the worker's code and test**

$ cd /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/workspace/workshop/inputs/hour-4/step-1 && cat app/sale.js app/test/discount.test.html; ls app app/test

<details>
<summary>81 lines</summary>

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

// receipt(lines, percent): the receipt of the sale, one string per printed line: each product,
// then the subtotal, then (when percent is above 0) the discount, then the total to pay.
// percent is a whole number from 0 to 100, and is optional.
function receipt(lines, percent) {
  if (percent === undefined || percent === null) percent = 0;
  if (typeof percent !== "number" || isNaN(percent) || percent < 0 || percent > 100) {
    throw new Error("discount must be 0 to 100");
  }
  var out = [];
  for (var i = 0; i < lines.length; i++) {
    out.push(lines[i].qty + " x " + lines[i].name + "  " + money(lineTotal(lines[i])));
  }
  var sub = subtotal(lines);
  var off = Math.round(sub * percent / 100);
  out.push("Subtotal  " + money(sub));
  if (percent > 0) out.push("Discount " + percent + "%  " + money(-off));
  out.push("Total  " + money(sub - off));
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
    check("10% off one scarf shows the discount and the total",
      receipt([scarf], 10),
      ["1 x Wool scarf  £20.00", "Subtotal  £20.00", "Discount 10%  -£2.00", "Total  £18.00"]);
    check("10% off two lines ends with subtotal, discount and total",
      receipt([scarf, towel], 10).slice(-3),
      ["Subtotal  £27.00", "Discount 10%  -£2.70", "Total  £24.30"]);
    check("no percentage gives the receipt as today",
      receipt([scarf]),
      ["1 x Wool scarf  £20.00", "Subtotal  £20.00", "Total  £20.00"]);
    check("a percentage of 0 gives the receipt as today",
      receipt([scarf], 0),
      ["1 x Wool scarf  £20.00", "Subtotal  £20.00", "Total  £20.00"]);
    checkThrows("a percentage below 0 throws", function () { receipt([scarf], -1); }, "discount must be 0 to 100");
    checkThrows("a percentage above 100 throws", function () { receipt([scarf], 101); }, "discount must be 0 to 100");
  </script>
</body>
</html>
app:
check.sh
index.html
sale.js
test

app/test:
check.js
discount.test.html
page.test.sh
sale.test.html
<shellId: 0 completed with exit code 0>
```

</details>


---

<sub>10s</sub>

### Copilot

The code takes the percentage of the subtotal, which breaks the per-line rule. I'm writing the report with a block verdict.

---

<sub>12s</sub>

### `bash` — Failed

**Write the review report**

$ cd /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount && cat > step-4-review/report.md <<'EOF'
## Ticket
tickets/010-sale-discount.md: reviewed, blocked on a business rule

## Changed
nothing

## Checked
- Read app/sale.js and app/test/discount.test.html against the four ACCEPTANCE lines: each has a test, and the examples come out right.
- Worked the rule "discount per line, rounded per line" by hand: three lines of 17p with 10% off must total 45p (each line 17p - 2p = 15p). `receipt` computes `Math.round(subtotal * percent / 100)` on the subtotal: 51p - 5p = 46p.

## Not done
- No test covers several small lines, so the tests do not catch the subtotal-percentage error.

Verdict: block
app/sale.js takes the percentage of the subtotal in `receipt` instead of per line rounded to the penny (three 17p lines at 10% give 46p, must be 45p).
EOF

```
Permission denied because no interactive user response was available. Retry in an interactive session so the user can approve it, or try an alternative that does not require this permission.
```


---

<sub>15s</sub>

### `create`

**create a new file at /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/step-4-review/report.md.**

/Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/step-4-review/report.md

```
Created file /Users/you/sdd-workshop/workshop/inputs/hour-4/step-1/graph/runs/010-sale-discount/step-4-review/report.md with 751 characters
```


---

<sub>18s</sub>

### Copilot

I blocked ticket 010 and wrote the report at `step-4-review/report.md`. I did not run the tests; I judged the code by reading it and working the business rule by hand.

The code in `app/sale.js` takes the percentage of the subtotal. Priya's rule says a discount goes per line, rounded to the penny. Three 17p lines at 10% off should come to 45p, and this code gives 46p. The worker's tests only use the ticket's own examples, which come out the same either way, so they don't catch it.

The report ends with `Verdict: block` and that reason.

---

<sub>Generated by [GitHub Copilot CLI](https://github.com/features/copilot/cli)</sub>

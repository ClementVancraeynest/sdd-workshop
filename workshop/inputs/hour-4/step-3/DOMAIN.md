# Product: Harbour POS

## The client

Northbank runs a chain of shops. Harbour POS is the software of their tills: the cashier
scans the products of a sale, the till adds them up and prints the receipt. Ines is the
lead, Tom an engineer, Priya product. They work with a chief, a worker and a reviewer,
like this folder does.

## What the till does today

`app/sale.js`: a sale is a list of lines, one per product, with its price and its
quantity. The receipt lists each line, then the subtotal, then the total to pay.
`app/index.html` shows the receipt of a sample sale.

## Decisions

- Prices are whole pence in the code. Only the receipt shows pounds: `£20.00`, and money
  taken off with a minus, `-£2.00` (Ines, 16 February).
- One line of a sale is one product with its quantity: `2 x Tea towel  £7.00` (Tom,
  16 February).
- The receipt prints the products first, then `Subtotal`, then `Total`, two spaces
  between the label and the amount (Priya, 16 February).
- The till runs in the browser of the shop's screen: plain JavaScript, no build, no
  network (Ines, 16 February).

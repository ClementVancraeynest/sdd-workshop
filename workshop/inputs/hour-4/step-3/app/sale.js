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

// receipt(lines): the receipt of the sale, one string per printed line: each product, then
// the subtotal, then the total to pay.
function receipt(lines) {
  var out = [];
  for (var i = 0; i < lines.length; i++) {
    out.push(lines[i].qty + " x " + lines[i].name + "  " + money(lineTotal(lines[i])));
  }
  out.push("Subtotal  " + money(subtotal(lines)));
  out.push("Total  " + money(subtotal(lines)));
  return out;
}

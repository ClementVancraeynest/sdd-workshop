// Payments: every closed basket is recorded as a sale with a receipt number.
var Payment = {
  sales: [],

  reset: function () {
    Payment.sales = [];
  },

  payByCard: function (basket) {
    var total = Basket.total(basket);
    var lines = [];
    for (var i = 0; i < basket.lines.length; i++) {
      var l = basket.lines[i];
      lines.push({ name: l.name, priceCents: l.priceCents, quantity: l.quantity });
    }
    var sale = {
      receipt: "R-" + (Payment.sales.length + 1),
      lines: lines,
      totalCents: total,
      method: "card",
      receivedCents: total,
      changeCents: 0
    };
    Payment.sales.push(sale);
    return sale;
  }
};

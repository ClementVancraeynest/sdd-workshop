// Payments: every closed basket is recorded as a sale with a receipt number.
var Payment = {
  sales: [],

  reset: function () {
    Payment.sales = [];
  },

  payByCard: function (basket) {
    return Payment.record(basket, "card", Basket.total(basket));
  },

  payByCash: function (basket, receivedCents) {
    var total = Basket.total(basket);
    if (typeof receivedCents !== "number" || receivedCents < total) {
      throw new Error("not enough cash: " + total + " cents due");
    }
    return Payment.record(basket, "cash", receivedCents);
  },

  record: function (basket, method, receivedCents) {
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
      method: method,
      receivedCents: receivedCents,
      changeCents: receivedCents - total
    };
    Payment.sales.push(sale);
    return sale;
  }
};

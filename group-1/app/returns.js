// Returns: a return is made against the receipt of a sale and refunds what was paid.
var Returns = {
  list: [],

  reset: function () {
    Returns.list = [];
  },

  create: function (receipt, items, method) {
    if (method !== "card" && method !== "cash") {
      throw new Error("the refund method must be card or cash");
    }
    var sale = null;
    for (var i = 0; receipt && i < Payment.sales.length; i++) {
      if (Payment.sales[i].receipt === receipt) {
        sale = Payment.sales[i];
      }
    }
    if (!sale) {
      throw new Error("a return needs the receipt of a sale");
    }

    var amount = 0;
    var asked = {};
    for (var k = 0; k < items.length; k++) {
      var item = items[k];
      var line = null;
      for (var j = 0; j < sale.lines.length; j++) {
        if (sale.lines[j].name === item.name) {
          line = sale.lines[j];
        }
      }
      var already = 0;
      for (var r = 0; r < Returns.list.length; r++) {
        if (Returns.list[r].receipt !== receipt) {
          continue;
        }
        for (var m = 0; m < Returns.list[r].items.length; m++) {
          if (Returns.list[r].items[m].name === item.name) {
            already += Returns.list[r].items[m].quantity;
          }
        }
      }
      asked[item.name] = (asked[item.name] || 0) + item.quantity;
      if (!line || already + asked[item.name] > line.quantity) {
        throw new Error("cannot return more than was bought: " + item.name);
      }
      amount += line.priceCents * item.quantity;
    }

    var result = { receipt: receipt, items: items, amountCents: amount, method: method };
    Returns.list.push(result);
    return result;
  }
};

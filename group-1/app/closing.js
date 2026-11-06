// Closing: the cash the drawer must hold is the cash taken minus the cash refunded.
var Closing = {
  expectedCashCents: function () {
    var cents = 0;
    for (var i = 0; i < Payment.sales.length; i++) {
      var sale = Payment.sales[i];
      if (sale.method === "cash") {
        cents += sale.receivedCents - sale.changeCents;
      }
    }
    for (var j = 0; j < Returns.list.length; j++) {
      if (Returns.list[j].method === "cash") {
        cents -= Returns.list[j].amountCents;
      }
    }
    return cents;
  }
};

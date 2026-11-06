// The basket: prices are whole cents and already include VAT, so no VAT is kept here.
var Basket = {
  create: function () {
    return { lines: [] };
  },

  add: function (basket, product, quantity) {
    for (var i = 0; i < basket.lines.length; i++) {
      if (basket.lines[i].name === product.name) {
        basket.lines[i].quantity += quantity;
        return basket;
      }
    }
    basket.lines.push({ name: product.name, priceCents: product.priceCents, quantity: quantity });
    return basket;
  },

  total: function (basket) {
    var sum = 0;
    for (var i = 0; i < basket.lines.length; i++) {
      sum += basket.lines[i].priceCents * basket.lines[i].quantity;
    }
    return sum;
  }
};

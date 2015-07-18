/**global: ko**/

function formatCurrency(value) {
    "use strict";
    return "$" + value.toFixed(2);
}

//{
//    "active": true,
//    "country": "-",
//    "mint": "-",
//    "series": "hand pour",
//    "metal": "silver",
//    "weight": 0.5,
//    "purchasePrice": 9.2,
//    "premium": 0.9423913043
//}
var CURRENT_GOLD_SPOT = 1150.10;
var CURRENT_SILVER_SPOT = 15.10;

function Coin(data) {
    "use strict";
    this.id = ko.observable(data.id);
    this.active = ko.observable(data.active);
    this.premium = ko.observable(data.premium);
    this.country = ko.observable(data.country);
    this.mint = ko.observable(data.mint);
    this.series = ko.observable(data.series);
    this.weight = ko.observable(data.weight);
    this.metal = ko.observable(data.metal);
    if (data.diameter) {
        this.diameter = ko.observable(data.diameter);
    } else {
        this.diameter = ko.observable("--");
    }
    if (data.width) {
        this.width = ko.observable(data.width);
    } else {
        this.width = ko.observable("--");
    }
    this.purchasePrice = ko.observable(data.purchasePrice);
    this.meltPrice = ko.computed(function () {
        if (this.metal() === "silver") {
            return this.weight() * CURRENT_SILVER_SPOT;
        }
        if (this.metal() === "gold") {
            return this.weight() * CURRENT_GOLD_SPOT;
        }
    }, this);
    this.currentPrice = ko.computed(function () {
        return this.meltPrice() * this.premium();
    }, this);
}


function ViewModel() {
    "use strict";
    var i, c;
    this.coins = ko.observableArray([]);

    for (i = 0; i < coinData.length; i += 1) {
        c = new Coin(coinData[i]);
        this.coins().push(c);
    }
}

var vm = new ViewModel();
ko.applyBindings(vm);
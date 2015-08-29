function Coin(data) {
    "use strict";
    var generateID = function () {
        return "mc" + pad(Math.floor(Math.random() * 100000000), 8);
    }
    this.id = ko.observable(generateID());
    this.active = ko.observable(data.active);
    this.coinType = data.type;
    this.premium = ko.observable(data.premium);
    this.year = this.coinType.year;
    this.country = this.coinType.country; //ko.observable(data.country);
    this.mint = this.coinType.mint; //ko.observable(data.mint);
    this.series = this.coinType.series; //ko.observable(data.series);
    this.weight = this.coinType.weight; //ko.observable(data.weight);
    this.metal = this.coinType.metal; //ko.observable(data.metal);
    this.diameter = this.coinType.diameter; //ko.observable(data.diameter);
    this.width = this.coinType.width; //ko.observable(data.width);
    this.purchasePrice = ko.observable(data.purchasePrice);
    this.meltPrice = ko.computed(function () {
        if (this.metal() === "silver") {
            return this.weight() * CURRENT_SILVER_SPOT;
        }
        if (this.metal() === "gold") {
            return this.weight() * CURRENT_GOLD_SPOT;
        }
        if (this.metal() === "platinum") {
            return this.weight() * CURRENT_PLATINUM_SPOT;
        }
        return 0;
    }, this);
    this.currentPrice = ko.computed(function () {
        return this.meltPrice() * this.premium();
    }, this);
}
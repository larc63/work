function Coin(data) {
    "use strict";
    var generateID = function () {
        return "mc" + pad(Math.floor(Math.random() * 100000000), 8);
    }
    this.id = ko.observable(generateID());
    this.active = ko.observable(data.active);
    this.coinType = ko.observable(data.coinType);
    this.coinTypeId = this.coinType().id();
    this.premium = ko.observable(data.premium);
    this.purchaseDate = ko.observable(data.purchaseDate ? data.purchaseDate : "");
    this.purchasePrice = ko.observable(data.purchasePrice);
    this.saleDate = ko.observable(data.saleDate ? data.saleDate : "");
    this.salePrice = ko.observable(data.salePrice ? data.salePrice : "");
    this.isPermaStack = ko.observable(data.isPermaStack ? data.isPermaStack : false);

    this.meltPrice = ko.computed(function () {
        if (this.coinType().metal() === "silver") {
            return this.coinType().weight() * CURRENT_SILVER_SPOT;
        }
        if (this.coinType().metal() === "gold") {
            return this.coinType().weight() * CURRENT_GOLD_SPOT;
        }
        if (this.coinType().metal() === "platinum") {
            return this.coinType().weight() * CURRENT_PLATINUM_SPOT;
        }
        if (this.coinType().metal() === "copper") {
            return this.coinType().weight() * CURRENT_COPPER_SPOT;
        }
        return 0;
    }, this);

    this.currentPrice = ko.computed(function () {
        return this.meltPrice() * this.premium();
    }, this);

    this.clone = function () {
        var data = {};
        data.id = generateID();
        data.active = this.active();
        data.coinType = this.coinType();
        data.premium = this.premium();
        data.purchaseDate = this.purchaseDate();
        data.purchasePrice = this.purchasePrice();
        data.saleDate = this.saleDate();
        data.salePrice = this.salePrice();
        data.isPermaStack = this.isPermaStack();
        return new Coin(data);
    }
}
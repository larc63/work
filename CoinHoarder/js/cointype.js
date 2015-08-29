function CoinType(data) {
    "use strict";
    var generateID = function () {
        return "ct" + pad(Math.floor(Math.random() * 100000000), 8);
    }

    this.id = ko.observable(generateID());
    if (data.country) {
        this.country = data.country;
    } else {
        this.country = "--";
    }
    this.selectedCountry = ko.observable();
    this.year = ko.observable(data.year ? data.year : "");
    this.mint = ko.observable(data.mint ? data.mint : "");
    this.series = ko.observable(data.series ? data.series : "");
    this.weight = ko.observable(data.weight ? data.weight : "");
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
};
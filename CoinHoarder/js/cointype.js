function CoinType(data) {
    "use strict";
    var generateID = function () {
        return "ct" + pad(Math.floor(Math.random() * 100000000), 8);
    }

    this.id = ko.observable(generateID());
    this.country = ko.observable(data.country ? data.country : "");
    this.year = ko.observable(data.year ? data.year : "");
    this.mint = ko.observable(data.mint ? data.mint : "");
    this.series = ko.observable(data.series ? data.series : "");
    this.weight = ko.observable(data.weight ? data.weight : "");
    this.metal = ko.observable(data.metal);
    this.diameter = ko.observable(data.diameter? data.diameter: "--");
    this.width = ko.observable(data.width? data.width: "--");
    
    this.clone = function(){
        var data = {};
        data.id = this.id();
        data.country = this.country();
        data.year = this.year();
        data.mint = this.mint();
        data.series = this.series();
        data.weight = this.weight();
        data.metal = this.metal();
        data.diameter = this.diameter();
        data.width = this.width();
        data.weight = this.weight();
        return new CoinType(data);
    }
};
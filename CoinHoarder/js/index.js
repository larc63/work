/*global ko, coinData */

function formatCurrency(value) {
    "use strict";
    return "$" + value.toFixed(2);
}

var CURRENT_GOLD_SPOT = 1150.10;
var CURRENT_PLATINUM_SPOT = 1150.10;
var CURRENT_SILVER_SPOT = 15.10;

function CoinSet() {
    this.name = "";
    this.coins = ko.observableArray([]);
};

function CoinType(data) {
    "use strict";
    var generateID = function () {
        return 100 + Math.floor(Math.random() * 1000);
    }

    this.id = ko.observable(data.id ? data.id : generateID());
    if (data.country) {
        this.country = data.country;
    } else {
        this.country = "--";
    }
    this.selectedCountry = ko.observable();
    this.year = ko.observable(data.year);
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
}

function Coin(data) {
    "use strict";
    this.id = ko.observable(data.id);
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


function ViewModel() {
    "use strict";
    var i, c, type, self = this;
    this.coins = ko.observableArray([]);
    this.coinTypes = ko.observableArray([]);
    this.countries = ko.observableArray([]);
    this.mints = [];

    this.getCountry = function (data) {
        var i, country;
        for (i = 0; i < this.countries().length; i += 1) {
            country = this.countries()[i];
            if (country === data.country) {
                return country;
            }
        }
        this.countries().push(data.country);
        return data.country;
    };

    this.getMint = function (data) {
        var i, mint;
        for (i = 0; i < this.mints.length; i += 1) {
            mint = this.mints[i];
            if (mint === data.mint) {
                return mint;
            }
        }
        this.mints.push(data.mint);
        return data.mint;
    };

    this.getCoinType = function (data) {
        var i, type;
        for (i = 0; i < this.coinTypes().length; i += 1) {
            type = this.coinTypes()[i];
            if (type.country === data.country && type.year() === data.year && type.mint() === data.mint && type.weight() === data.weight && type.metal() === data.metal) {
                return type;
            }
        }
        type = new CoinType(data);
        this.coinTypes.push(type);
        return type;
    };

    this.findCoin = function (year, country, series, metal, weight) {
        for (i = 0; i < this.coinTypes().length; i += 1) {
            type = this.coinTypes()[i];
            if (type.country === country && type.year() === year && type.weight() === weight && type.metal() === metal) {
                return type;
            }
        }
    }

    //for (i = 0; i < 15; i += 1) {
    for (i = 0; i < coinData.length; i += 1) {
        type = this.getCoinType(coinData[i]);
        coinData[i].type = type;
        coinData[i].country = this.getCountry(coinData[i]);
        coinData[i].mint = this.getMint(coinData[i]);
        c = new Coin(coinData[i]);
        this.coins().push(c);
    }

    this.stagedCoinType = ko.observable(new CoinType({}))
    this.addCoinType = function (event) {
        self.stagedCoinType().country = self.stagedCoinType().selectedCountry();
        self.coinTypes.push(self.stagedCoinType());
    }
    this.doDatabaseStuff = function () {
        var request = window.indexedDB.open("coin-hoarder", 3);
        request.onerror = function (event) {
            // Handle errors.
        };
        request.onupgradeneeded = function (event) {
            var db = event.target.result;

            // Create an objectStore to hold information about our customers. We're
            // going to use "ssn" as our key path because it's guaranteed to be
            // unique - or at least that's what I was told during the kickoff meeting.
            var objectStore = db.createObjectStore("customers", {
                keyPath: "ssn"
            });

            // Create an index to search customers by name. We may have duplicates
            // so we can't use a unique index.
            objectStore.createIndex("name", "name", {
                unique: false
            });

            // Create an index to search customers by email. We want to ensure that
            // no two customers have the same email, so use a unique index.
            objectStore.createIndex("email", "email", {
                unique: true
            });

            // Use transaction oncomplete to make sure the objectStore creation is 
            // finished before adding data into it.
            objectStore.transaction.oncomplete = function (event) {
                // Store values in the newly created objectStore.
                var customerObjectStore = db.transaction("customers", "readwrite").objectStore("customers");
                for (var i in customerData) {
                    customerObjectStore.add(customerData[i]);
                }
            }
        };
    };

    this.currentSet = new CoinSet();
    this.currentSet.name = "Lunar Series Goats";
    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 0.5));
    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 1));
    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 2));
    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 5));
    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 10));
    //    this.currentSet.name = "Libertdad 2014";
    //    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 0.5));
}

var vm = new ViewModel();
ko.applyBindings(vm);
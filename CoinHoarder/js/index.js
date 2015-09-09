/*global ko, coinData */
function pad(num, size) {
    return ('000000000' + num).substr(-size);
}

function format4(value) {
    "use strict";
    if (value instanceof String || typeof value === "string") {
        value = Number(value);
    }
    //console.log(typeof value + " !!! " + value);
    return value.toFixed(4);
}

function formatCurrency(value) {
    "use strict";
    if (value instanceof String || typeof value === "string") {
        value = Number(value);
    }
    //console.log(typeof value + " !!! " + value);
    return "$" + value.toFixed(2);
}

var CURRENT_GOLD_SPOT = 1140.68;
var CURRENT_PLATINUM_SPOT = 1012.00;
var CURRENT_SILVER_SPOT = 14.67;

function CoinSet() {
    "use strict";
    this.name = "";
    this.coins = ko.observableArray([]);
};

function ViewModel() {
    "use strict";
    var i, c, type, self = this;
    this.coins = ko.observableArray([]);
    this.coinTypes = ko.observableArray([]);

    this.getCoinType = function (data) {
        var i, type;
        for (i = 0; i < this.coinTypes().length; i += 1) {
            type = this.coinTypes()[i];
            if (type.country() === data.coinType.country && type.year() === data.coinType.year && type.mint() === data.coinType.mint && type.weight() === data.coinType.weight && type.metal() === data.coinType.metal && type.series() === data.coinType.series) {
                return type;
            }
        }
        type = new CoinType(data.coinType);
        this.coinTypes.push(type);
        return type;
    };

    this.findCoin = function (year, country, series, metal, weight) {
        for (i = 0; i < this.coinTypes().length; i += 1) {
            type = this.coinTypes()[i];
            if (type.country() === country && type.year() === year && type.weight() === weight && type.metal() === metal) {
                return type;
            }
        }
    }


    this.sortCoins = function () {
        this.coinTypes().sort(function (a, b) {
            var t1 = a,
                t2 = b,
                c1 = t1.country(),
                c2 = t2.country(),
                y1 = Number(t1.year()),
                y2 = Number(t2.year()),
                m1 = t1.mint(),
                m2 = t2.mint(),
                s1 = t1.series(),
                s2 = t2.series(),
                w1 = Number(t1.weight()),
                w2 = Number(t2.weight());
            if (c1 < c2) return -1;
            if (c1 > c2) return 1;
            if (y1 < y2) return -1;
            if (y1 > y2) return 1;
            if (s1 < s2) return -1;
            if (s1 > s2) return 1;
            if (w1 < w2) return -1;
            if (w1 > w2) return 1;
            if (m1 < m2) return -1;
            if (m1 > m2) return 1;
            return 0;
        });

        this.coins().sort(function (a, b) {
            var t1 = a.coinType(),
                t2 = b.coinType(),
                c1 = t1.country(),
                c2 = t2.country(),
                y1 = Number(t1.year()),
                y2 = Number(t2.year()),
                m1 = t1.mint(),
                m2 = t2.mint(),
                s1 = t1.series(),
                s2 = t2.series(),
                w1 = Number(t1.weight()),
                w2 = Number(t2.weight());
            if (c1 < c2) return -1;
            if (c1 > c2) return 1;
            if (m1 < m2) return -1;
            if (m1 > m2) return 1;
            if (y1 < y2) return -1;
            if (y1 > y2) return 1;
            if (s1 < s2) return -1;
            if (s1 > s2) return 1;
            if (w1 < w2) return -1;
            if (w1 > w2) return 1;
            return 0;
        });
    }

    //for (i = 0; i < 2; i += 1) {
    for (i = 0; i < coinData.length; i += 1) {
        type = this.getCoinType(coinData[i]);
        coinData[i].coinType = type;
        if (localStorage.hasOwnProperty(coinData[i].id)) {
            c = JSON.parse(localStorage.getItem(coinData[i].id));
        } else {
            c = new Coin(coinData[i]);
            //console.log("added ", c);
            //localStorage.setItem(c.id(), ko.toJSON(c));
        }
        this.coins().push(c);
    }
    this.sortCoins();


    this.stagedIndex = 0;
    this.stagedCoinType = ko.observable();
    this.stagedCoinTypeIndex = 0;
    this.copyCoinType = function (index) {
        self.stagedCoinType(this.clone());
        self.stagedCoinTypeIndex = -1;
    }
    this.deleteCoinType = function (index) {
        self.coinTypes.splice(index, 1);
        self.coinTypes.valueHasMutated();
    }
    this.editCoinType = function (index) {
        self.stagedCoinType(this.clone());
        self.stagedCoinType().id(this.id());
        self.stagedCoinTypeIndex = index;
    }
    this.commitCoinType = function () {
        if (self.stagedCoinTypeIndex >= 0) {
            self.coinTypes()[self.stagedCoinTypeIndex] = self.stagedCoinType();
        } else {
            self.coinTypes().push(self.stagedCoinType());
        }
        self.stagedCoinType(undefined);
        self.stagedCoinTypeIndex = 0;
        self.sortCoins();
        self.coinTypes.valueHasMutated();
        self.coins.valueHasMutated();
    }
    this.exportCoins = function () {
        console.log(ko.toJSON(this.coins()));
        saveAs()
    };
    this.stagedCoin = ko.observable();

    this.copyMyCoin = function (index) {
        self.stagedCoin(this.clone());
        self.stagedIndex = -1;
    }

    this.editMyCoin = function (index) {
        self.stagedCoin(this.clone());
        self.stagedCoin().id(this.id());
        self.stagedIndex = index;
    }

    this.deleteMyCoin = function (index) {
        self.coins().splice(index, 1);
        self.coins.valueHasMutated();
    }

    this.commitCoin = function () {
        if (self.stagedIndex >= 0) {
            self.coins()[self.stagedIndex] = self.stagedCoin();
        } else {
            self.coins().push(self.stagedCoin());
        }
        self.stagedCoin(undefined);
        self.stagedIndex = 0;
        self.sortCoins();
        self.coins.valueHasMutated();
    }
    this.addCoin = function () {
        self.stagedCoin();
    }
    this.cancelCoinOperation = function () {
        self.stagedCoin(undefined);
        self.stagedCoinType(undefined);
    }


    this.numberOfCoins = ko.computed(function () {
        return self.coins().filter(function (e) {
            return e.active();
        }).length + " Coins";
    });
    this.numberOfCoinsPermaStack = ko.computed(function () {
        return self.coins().filter(function (e) {
            return e.active() && e.isPermaStack();
        }).length + " Coins in permastack";
    });
    this.numberOfCoinsNotPermaStack = ko.computed(function () {
        return self.coins().filter(function (e) {
            return e.active() && !e.isPermaStack();
        }).length + " Coins not in permastack";
    });
    this.numberOfOunces = ko.computed(function () {
        var retVal = 0,
            activeCoins = self.coins().filter(function (e) {
                return e.active();
            });
        if (activeCoins.length > 0) {
            retVal = format4(activeCoins.reduce(function (a, b) {
                if (a instanceof Coin) {
                    return Number(a.coinType().weight()) + Number(b.coinType().weight());
                } else {
                    return a + Number(b.coinType().weight());
                }
            }));
        }
        return retVal + " Ounces";
    });
    this.numberOfOuncesInPermaStack = ko.computed(function () {
        var retVal = 0,
            activeCoins = self.coins().filter(function (e) {
                return e.active() && e.isPermaStack();
            });
        if (activeCoins.length > 0) {
            retVal = format4(activeCoins.reduce(function (a, b) {
                if (a instanceof Coin) {
                    return Number(a.coinType().weight()) + Number(b.coinType().weight());
                } else {
                    return a + Number(b.coinType().weight());
                }
            }));
        }
        return retVal + " Ounces in permastack";
    });
    this.numberOfOuncesNotInPermaStack = ko.computed(function () {
        var retVal = 0,
            activeCoins = self.coins().filter(function (e) {
                return e.active() && !e.isPermaStack();
            });
        if (activeCoins.length > 0) {
            retVal = format4(activeCoins.reduce(function (a, b) {
                if (a instanceof Coin) {
                    return Number(a.coinType().weight()) + Number(b.coinType().weight());
                } else {
                    return a + Number(b.coinType().weight());
                }
            }));
        }
        return retVal + " Ounces not in permastack";
    });
    this.meltTotal = ko.computed(function () {
        return formatCurrency(self.coins().filter(function (e) {
            return e.active();
        }).reduce(function (a, b) {
            if (a instanceof Coin) {
                return Number(a.meltPrice()) + Number(b.meltPrice());
            } else {
                return a + Number(b.meltPrice());
            }
        }));
    });
    this.investmentTotal = ko.computed(function () {
        return formatCurrency(self.coins().filter(function (e) {
            return e.active();
        }).reduce(function (a, b) {
            if (a instanceof Coin) {
                return Number(a.purchasePrice()) + Number(b.purchasePrice());
            } else {
                return a + Number(b.purchasePrice());
            }
        }));
    });
    this.permaStackValue = ko.computed(function () {
        return formatCurrency(self.coins().filter(function (e) {
            return e.active() && e.isPermaStack();
        }).reduce(function (a, b) {
            if (a instanceof Coin) {
                return Number(a.currentPrice()) + Number(b.currentPrice());
            } else {
                return a + Number(b.currentPrice());
            }
        }));
    });
    this.possibleSale = ko.computed(function () {
        return formatCurrency(self.coins().filter(function (e) {
            return e.active() && !e.isPermaStack();
        }).reduce(function (a, b) {
            if (a instanceof Coin) {
                return Number(a.currentPrice()) + Number(b.currentPrice());
            } else {
                return a + Number(b.currentPrice());
            }
        }));
    });

    this.currentSet = new CoinSet();
    //    this.currentSet.name = "Lunar Series Goats";
    //    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 0.5));
    //    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 1));
    //    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 2));
    //    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 5));
    //    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 10));
    //    this.currentSet.name = "Libertdad 2014";
    //    this.currentSet.coins.push(this.findCoin(2015, "Australia", "Lunar Series II", "silver", 0.5));
}

var vm = new ViewModel();
ko.applyBindings(vm);
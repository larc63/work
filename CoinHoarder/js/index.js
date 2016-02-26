/*global ko, data, Coin */
var CURRENT_GOLD_SPOT = 1233.33;
var CURRENT_SILVER_SPOT = 15.46;
var CURRENT_PLATINUM_SPOT = 945.50;
var CURRENT_COPPER_SPOT = 2.06;

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
    this.sellableCoins = ko.observableArray([]);
    this.getCoinType = function (data) {
        var i, type = this.coinTypes().find(function (e) {
            return e.id() === data.coinTypeId
        });
        if (type) {
            return type;
        }
        console.log("didn't find the coin type in the array with .find");
        for (i = 0; i < this.coinTypes().length; i += 1) {
            type = this.coinTypes()[i];
            if (type.country() === data.coinType.country && type.year() === data.coinType.year && type.mint() === data.coinType.mint && type.weight() === data.coinType.weight && type.metal() === data.coinType.metal && type.series() === data.coinType.series) {
                return type;
            }
        }
        if (data.coinTypeId === undefined) {
            debugger;
        }
        console.log("adding a new type for " + data.coinTypeId);
        type = new CoinType(data.coinType);
        this.coinTypes.push(type);
        return type;
    };

    this.findCoin = function (year, country, series, metal, weight) {
        var type = this.coinTypes().find(function (e) {
            return e.year() === year && e.country() === country && e.series() === series && e.metal() === metal && e.weight() === weight;
        });
        return type;
    }


    this.sortCoins = function () {
        this.coinTypes().sort(function (a, b) {
            var t1 = a,
                t2 = b,
                //                i1 = t1.id(),
                //                i2 = t2.id(),
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
            //            if (i1 < i2) return -1;
            //            if (i1 > i2) return 1;
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

    for (i = 0; i < data.coinTypes.length; i += 1) {
        this.coinTypes().push(new CoinType(data.coinTypes[i]));
    }

    //for (i = 0; i < 2; i += 1) {
    for (i = 0; i < data.coins.length; i += 1) {
        data.coins[i].coinType = undefined;

        type = this.getCoinType(data.coins[i]);
        data.coins[i].coinType = type;
        if (localStorage.hasOwnProperty(data.coins[i].id)) {
            c = JSON.parse(localStorage.getItem(data.coins[i].id));
        } else {
            c = new Coin(data.coins[i]);
            //console.log("added ", c);
            //localStorage.setItem(c.id(), ko.toJSON(c));
        }
        this.coins().push(c);
    }
    this.sortCoins();
    this.sellableCoins(this.coins().filter(function (c) {
        return c.isPermaStack() === false && c.active() === true;
    }));

    this.sellableCoins().sort(function (a, b) {
        var t1 = a.purchasePrice(),
            t2 = b.purchasePrice(),
            c1 = a.currentPrice(),
            c2 = c.currentPrice();
        if (c1 - t1 < c2 - t2) return 1;
        if (c1 - t1 > c2 - t2) return -1;
        return 0;
    });

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
    };
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
    };
    this.exportCoins = function () {
        var sortingFunction = function (a, b) {
                var ida = parseInt(a.id.substring(2)),
                    idb = parseInt(b.id.substring(2));
                if (ida >= idb) {
                    return 1;
                }
                if (ida < idb) {
                    return -1;
                }
            },
            coins = this.coins().map(function (c) {
                var newCoin = {
                    id: c.id(),
                    coinTypeId: c.coinTypeId,
                    active: c.active,
                    premium: c.premium,
                    purchaseDate: c.purchaseDate,
                    purchasePrice: c.purchasePrice,
                    saleDate: c.saleDate,
                    salePrice: c.salePrice,
                    isPermaStack: c.isPermaStack
                };
                return newCoin;
            }).sort(sortingFunction),
            coinTypes = this.coinTypes().map(function (c) {
                var newCoinType = {
                    id: c.id(),
                    country: c.country(),
                    year: c.year(),
                    mint: c.mint(),
                    series: c.series(),
                    weight: c.weight(),
                    width: c.width(),
                    metal: c.metal(),
                    diameter: c.diameter()
                };
                return newCoinType;
            }).sort(sortingFunction),
            e;
        //        console.log(ko.toJSON(coins));
        //        console.log(ko.toJSON(this.coinTypes()));
        //        console.log(ko.toJSON(this.coins()));
        e = {
            coins: ko.toJS(coins),
            coinTypes: ko.toJS(coinTypes)
        };
        console.log("window.data=" + JSON.stringify(e) + ";");
        //        window.open('data:application/text,' + "window.data=" + JSON.stringify(e) + ";");
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
        if (self.stagedCoin().coinType().id() !== this.coinTypeId) {
            this.coinTypeId = self.stagedCoin().coinType().id();
        }
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
    this.goldToSilverRatio = ko.computed(function () {
        var goldTotal = 0,
            silverTotal = 0,
            activeGoldCoins = self.coins().filter(function (e) {
                return e.active() && e.coinType().metal() == "gold";
            }),
            activeSilverCoins = self.coins().filter(function (e) {
                return e.active() && e.coinType().metal() == "silver";
            }),
            ratio = 1.0,
            adder = function (a, b) {
                if (a instanceof Coin) {
                    return Number(a.coinType().weight()) + Number(b.coinType().weight());
                } else {
                    return a + Number(b.coinType().weight());
                }
            };

        if (activeSilverCoins.length > 0) {
            goldTotal = activeGoldCoins.reduce(adder);
            silverTotal = activeSilverCoins.reduce(adder);
            ratio = 1 / goldTotal;
            return "Silver:gold = " + format4(silverTotal * ratio) + ":1";
        } else {
            return "0:0";
        }
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
    this.currentSet.name = "Libertad 2014";
    this.currentSet.coins().push(this.findCoin(2014, "Mexico", "Libertad", "silver", 0.05));
    this.currentSet.coins().push(this.findCoin(2014, "Mexico", "Libertad", "silver", 0.1));
    this.currentSet.coins().push(this.findCoin(2014, "Mexico", "Libertad", "silver", 0.25));
    this.currentSet.coins().push(this.findCoin(2014, "Mexico", "Libertad", "silver", 0.5));
    this.currentSet.coins().push(this.findCoin(2014, "Mexico", "Libertad", "silver", 1));
    this.currentSet.coins().push(this.findCoin(2014, "Mexico", "Libertad", "silver", 2));
    this.currentSet.coins().push(this.findCoin(2014, "Mexico", "Libertad", "silver", 5));

    self.Tab = function (data) {
        var tab = this;
        tab.id = ko.observable(data.id);
        tab.name = ko.observable(data.name);
    };

    self.selectedTab = ko.observable(1);
    self.tabs = [];
    //(id, name, url, text, selected
    self.tabs.push(new self.Tab({
        id: 1,
        name: 'My Coins',
        text: 'Welcome to my coins!'
    }));
    self.tabs.push(new self.Tab({
        id: 2,
        name: 'Coin Types',
        text: 'Welcome to coin types'
    }));
    self.tabs.push(new self.Tab({
        id: 3,
        name: 'Sets',
        text: 'These are the sets of coins'
    }));
    self.tabs.push(new self.Tab({
        id: 4,
        name: 'Sellable coins',
        text: 'This is where the sellables go'
    }));
    self.tabs.push(new self.Tab({
        id: 5,
        name: 'Summary',
        text: 'This is where the summary goes'
    }));
};
var vm = new ViewModel();
ko.applyBindings(vm);
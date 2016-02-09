function ViewModel() {
    var self = this;
    self.selectedTab = 1;

    self.Tab = function (data) {
        var tab = this;
        tab.id = ko.observable(data.id);
        tab.name = ko.observable(data.name);
        tab.text = ko.observable(data.text);

        function reqListener() {
            tab.text(this.responseText);
        }

        if (data.url) {
            var oReq = new XMLHttpRequest();
            oReq.addEventListener("load", reqListener);
            oReq.open("GET", data.url);
            oReq.send();
        }
        return tab;
    };


    self.selectedTab = ko.observable(1);
    self.tabs = new Array();
    //(id, name, url, text, selected
    self.tabs.push(new self.Tab({id: 1, name: 'Tab 1', url: 'tab01.html', text: 'Wecome to Tab #1!'}));
    self.tabs.push(new self.Tab({id: 2, name: 'Tab 2', url: undefined, text: 'This is Tab 2...'}));
    self.tabs.push(new self.Tab({id: 3, name: 'Tab 3', url: undefined, text: 'I\'m tab 3'}));
    self.tabs.push(new self.Tab({id: 4, name: 'Tab 4', url: undefined, text: 'Hello World!'}));

    return self;
}

ko.applyBindings(new ViewModel());
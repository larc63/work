function ViewModel(){
    var self = this;
    self.Tab = function(id, name, text, selected){
        var tab = this;
        tab.id = ko.observable(id);
        tab.name = ko.observable(name);
        tab.text = ko.observable(text);
        return tab;
    };
    self.selectedTab = ko.observable(1);
    self.tabs = new Array();
    self.tabs.push(new self.Tab(1, 'Tab 1', 'Wecome to Tab #1!'));
    self.tabs.push(new self.Tab(2, 'Tab 2', 'This is Tab 2...'));
    self.tabs.push(new self.Tab(3, 'Tab 3', 'I\'m tab 3'));
    self.tabs.push(new self.Tab(4, 'Tab 4', 'Hello World!'));
    return self;
}

ko.applyBindings(new ViewModel());
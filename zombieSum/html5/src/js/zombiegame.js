ZombieGame = function() {
	var self = this;
	this.game = new Game();
	this.update = function() {
		self.game.update();		
	};
	this.init = function() {
		self.updateTimer = window.setInterval(self.update, 1000);
		self.update();
	};
	window.setTimeout(self.init(), 2000);
};

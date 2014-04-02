ZombieGame = function() {
	var self = this;
	this.game = new Game();
	this.update = function() {
		self.game.update();		
	};
	this.init = function() {
		self.updateTimer = window.setInterval(self.update, 500);
		self.update();
	};
	setTimeout(self.init(), 2000);
};

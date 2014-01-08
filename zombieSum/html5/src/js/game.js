Game = function() {
	var BACKGROUND_COLOR = "#666600";
	
	console.log("Game Constructor!");

	var canvas = document.getElementById('mainCanvas');
	this.context = canvas.getContext('2d');
	this.actor = new Actor();
	


	this.paint = function() {
//		console.log("painting!");
		this.context.fillStyle = BACKGROUND_COLOR;
		this.context.fillRect(0, 0, 800, 600);
		this.actor.paint(this.context);
	};

	this.update = function(self) {
		
		this.actor.update();
		
		this.paint();
	};
	
	
	
};
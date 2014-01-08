// spriteSheetCanvas = document.createElement('canvas');  
// spriteSheetCanvas.width = dotDiam*numStages;           
// spriteSheetCanvas.height = dotDiam;                    
// spriteSheetContext = spriteSheetCanvas.getContext("2d");

Actor = function() {
	// var self = this;

	var ZOMBIE_STATE_INIT = 0;
	var ZOMBIE_STATE_MOVE_FRONT = 1;
	var ZOMBIE_STATE_MOVE_FRONT_STOP = 2;
	var ZOMBIE_STATE_MOVE_RIGHT = 3;
	var ZOMBIE_STATE_MOVE_RIGHT_STOP = 4;
	var ZOMBIE_STATE_MOVE_LEFT = 5;
	var ZOMBIE_STATE_MOVE_LEFT_STOP = 6;
	var ZOMBIE_STATE_DIE = 7;
	var ZOMBIE_NUM_STATES = 7;

	this.sprite = new Sprite('img/zombie.png');
	this.x = 0;
	this.y = 0;
	this.state = 0;

	this.paint = function(context) {
		this.sprite.paint(context, this.x, this.y);
	};

	this.update = function() {
		this.sprite.update();
	};
};

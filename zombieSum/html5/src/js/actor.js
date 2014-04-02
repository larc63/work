// spriteSheetCanvas = document.createElement('canvas');
// spriteSheetCanvas.width = dotDiam*numStages;
// spriteSheetCanvas.height = dotDiam;
// spriteSheetContext = spriteSheetCanvas.getContext("2d");

Actor = function() {
	var self = this;

	var ZOMBIE_STATE_INIT = 0;
	var ZOMBIE_STATE_MOVE_FRONT = 1;
	var ZOMBIE_STATE_MOVE_FRONT_STOP = 2;
	var ZOMBIE_STATE_MOVE_RIGHT = 3;
	var ZOMBIE_STATE_MOVE_RIGHT_STOP = 4;
	var ZOMBIE_STATE_MOVE_LEFT = 5;
	var ZOMBIE_STATE_MOVE_LEFT_STOP = 6;
	var ZOMBIE_STATE_DIE = 7;
	var ZOMBIE_NUM_STATES = 7;

	this.sprite = new Sprite(self, 'img/zombie.png');
	this.x = 0;
	this.y = 0;
	this.state = 0;

	this.paint = function(context) {
		if (this.state != ZOMBIE_STATE_INIT) {
			this.sprite.paint(context, this.x, this.y);
		}
	};

	this.changeState = function(newState) {
		switch(newState) {
			case ZOMBIE_STATE_INIT:
				break;
			case ZOMBIE_STATE_MOVE_FRONT:
			case ZOMBIE_STATE_MOVE_FRONT_STOP:
			case ZOMBIE_STATE_MOVE_RIGHT:
			case ZOMBIE_STATE_MOVE_RIGHT_STOP:
			case ZOMBIE_STATE_MOVE_LEFT:
			case ZOMBIE_STATE_MOVE_LEFT_STOP:
			case ZOMBIE_STATE_DIE:
				this.sprite.setAnimation(newState);
				this.sprite.resetAnimation();
				this.state = newState;
				break;
		}
	}

	this.update = function() {
		this.sprite.update();
	};
};

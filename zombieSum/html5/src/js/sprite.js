Sprite = function(imageSrc) {

	var FRAME_WIDTH = 64;
	var FRAME_HEIGHT = 64;
	var NUM_FRAMES = 7;

	var ZOMBIE_ANIMATION_INIT = 0;
	var ZOMBIE_ANIMATION_MOVE_FRONT = 1;
	var ZOMBIE_ANIMATION_MOVE_FRONT_STOP = 2;
	var ZOMBIE_ANIMATION_MOVE_RIGHT = 3;
	var ZOMBIE_ANIMATION_MOVE_RIGHT_STOP = 4;
	var ZOMBIE_ANIMATION_MOVE_LEFT = 5;
	var ZOMBIE_ANIMATION_MOVE_LEFT_STOP = 6;
	var ZOMBIE_ANIMATION_DIE = 7;
	var ZOMBIE_NUM_ANIMATIONS = 7;

	var self = this;

	this.image = new Image();
	this.frame = 0;
	this.animationIndex = 0;

	this.loaded = false;
	this.image.onload = function() {
		// console.log("image.onLoad!");
		self.loaded = true;
	};
	this.image.src = imageSrc;

	this.paint = function(context, x, y) {
		// TODO: crop here
		if (this.loaded === true) {
			context.drawImage(this.image, this.frame * FRAME_WIDTH,
					this.animationIndex * FRAME_HEIGHT, FRAME_WIDTH,
					FRAME_HEIGHT, x, y, FRAME_WIDTH, FRAME_HEIGHT);
		}
	};
	this.update = function() {
		this.frame = (this.frame + 1) % NUM_FRAMES;
	};
};
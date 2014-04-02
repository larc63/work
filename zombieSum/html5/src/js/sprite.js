Sprite = function(caller, imageSrc) {

var FRAME_WIDTH = 64;
var FRAME_HEIGHT = 64;
var NUM_FRAMES = 7;
var FRAMES_PER_ROW = 7;

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

this.frameIndices = [
[], //ZOMBIE_ANIMATION_INIT
[0, 1, 2, 3, 4, 5, 6], //ZOMBIE_ANIMATION_MOVE_FRONT
];

this.loaded = false;
this.image.onload = function() {
	// console.log("image.onLoad!");
	self.loaded = true;
	caller.changeState(caller.state+1);
};
this.image.src = imageSrc;

this.paint = function(context, x, y) {
	var row, column;
	switch(this.animationIndex) {
		case ZOMBIE_ANIMATION_INIT:
			break;
		case ZOMBIE_ANIMATION_MOVE_FRONT:
			row = this.frameIndices[this.animationIndex][this.frame]%FRAMES_PER_ROW;
			column = (this.frameIndices[this.animationIndex][this.frame]/FRAMES_PER_ROW) >>> 0;
			context.drawImage(this.image, row * FRAME_WIDTH, column * FRAME_HEIGHT, FRAME_WIDTH, FRAME_HEIGHT, x, y, FRAME_WIDTH, FRAME_HEIGHT);
			break;
	}
};

this.update = function() {
	this.frame = (this.frame + 1) % this.frameIndices[this.animationIndex].length;
};

this.setAnimation = function(index){
	this.animationIndex = index;
};

this.resetAnimation = function(){
	this.frame = 0;
};
};
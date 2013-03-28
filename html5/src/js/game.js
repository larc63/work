
 function Game(){             
  console.log("Game Constructor!");
  this.canvas = document.getElementById('mainCanvas');
  this.context = this.canvas.getContext('2d');
 
 }

Game.prototype.initGame = function (){
  console.log("initGame!");
}

Game.prototype.paint = function () {
  console.log("painting!");

  this.context.drawImage(imageObj, 0, 0);
}
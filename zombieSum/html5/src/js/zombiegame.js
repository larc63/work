ZombieGame.prototype = new Game();
ZombieGame.prototype.constructor = ZombieGame;

function ZombieGame(){
   Game.call();
   this.initGame();  
   window.setTimeout(this.paint,1000);
}

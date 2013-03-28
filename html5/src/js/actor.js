// spriteSheetCanvas = document.createElement('canvas');  
// spriteSheetCanvas.width = dotDiam*numStages;           
// spriteSheetCanvas.height = dotDiam;                    
// spriteSheetContext = spriteSheetCanvas.getContext("2d");


var imageObj = new Image();
          
imageObj.onload = function() {
      console.log("image.onLoad!");
//   context.drawImage(imageObj, 69, 50);
};

console.log("setting src!");
imageObj.src = 'img/zombie.png';
var clouds = [];
var example = document.getElementById('example');
var context = example.getContext('2d');
var range = 0;
var rangeIncrement=200;
var lastY=-1;
var offset=0;
generateCloudPattern();
function timer() {
	setTimeout (function() { moveClouds(); timer(); },100);	
}
timer();
function moveClouds() {
    if(context.canvas.width != window.innerWidth) {
        context.canvas.width  = window.innerWidth;
    }

	context.clearRect(0,0,4000,500);
	offset++;
	for(var i=0; i<clouds.length; i++) {
		generateCloud(clouds[i][0],clouds[i][1],offset,clouds[i][2]);
	}	
}
function generateCloudPattern() {
	for(var i=0; i < 30; i++) {
		var totaldir;
		//if first time
		if(lastY==-1) {
			//generate random position
			var y = rand(0,350);
		}else{
			var dir = rand(0,1);
			if(lastY>250) {
				//go up		
				//alert('up');
				var y = rand(0,(lastY-100));
				totaldir="up";
			} else if (lastY<100) {
				// go down
				//alert('down');
				var y = rand((lastY+100),350);
				totaldir="down";
			} else {
				if(dir==0) { 
					//go up		
					//alert('up');
					var y = rand(0,(lastY-100));
					totaldir="up";
				}else{
					// go down

					//alert('down');
					var y = rand((lastY+100),350);
					totaldir="down";
				}
			}
		}
		var x=range+rand(0,50);
		var scale = generateCloud(x,y,offset,rand(2,8)/10);
		clouds.push([x,y,scale]);
		range += rangeIncrement;
		lastY=y;
	}
}
function generateCloud(x,y,offset,scale) {
	context.beginPath();

	context.arc( (x+100-offset)*scale,y+100*scale, 50*scale, 0, Math.PI*2, false);
	context.arc( (x+140-offset)*scale,y+120*scale, 30*scale, 0, Math.PI*2, false);
	context.arc( (x+60-offset)*scale,y+120*scale, 30*scale, 0, Math.PI*2, false);

	context.closePath();
	context.fillStyle = "rgb(255,255,255)";
	context.fill();
	return scale;
}
function rand(min,max) {
	return Math.floor((max-(min-1))*Math.random()) + min;
}
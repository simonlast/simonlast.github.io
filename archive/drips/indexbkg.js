/**
 * @author Simon Last
 */

canvas = document.getElementById("platform");
var ctx = canvas.getContext("2d");

canvas.width = window.innerWidth;
canvas.height = window.innerHeight;

var grav = 7;

function gameObject(x,y,r,vx,vy,c){
	this.x = x;
	this.y = y;
	this.r = r;
	var dev = 1;
	this.vx = vx+Math.random()*dev-dev/2;
	this.vy = vy;
	this.c = c;
	this.render = function(modifier){
		this.vy += grav*modifier;
		var vDev = .3;
		this.vx += Math.random()*vDev - vDev/2;
		this.x += this.vx;
		this.y += this.vy;
		ctx.fillStyle = c;
		//ctx.fillStyle = "rgba(255,0,0,172)"; 
		ctx.beginPath();
		this.r -= .1;
		ctx.arc(this.x, this.y, this.r, 0, Math.PI*2, true); 
		ctx.closePath();
		ctx.fill();
	}
}

var objects = new Array();
// objects.push(new gameObject(100,100,100,0,0));
   var c = "rgba(";
    for (j = 0; j < 3; j++) {
      var v = Math.floor(Math.random()*100)+120; // 0-255;
      c += v + ",";
    }
    c += ".07)";
     objects.push(new gameObject(canvas.width*3/4,canvas.height/4,Math.random(50)+50,0,2,c));
     
addEventListener("mousedown", function (e) {
	    var mouseX, mouseY;

    if(e.offsetX) {
        mouseX = e.offsetX;
        mouseY = e.offsetY;
    }
    else if(e.layerX) {
        mouseX = e.layerX;
        mouseY = e.layerY;
    }
    var c = "rgba(";
    for (j = 0; j < 3; j++) {
      var v = Math.floor(Math.random()*100)+120; // 0-255;
      c += v + ",";
    }
    c += ".03)";
     objects.push(new gameObject(mouseX,mouseY,Math.random(50)+50,0,2,c));
}, false);

var update = function (modifier) {
	for (var i=0; i < objects.length; i++) {
	  objects[i].render(modifier);
	  if(objects[i].y > canvas.height){
	  	objects.splice(i, 1);
	  }
	};

}; 

var main = function () {
	var now = Date.now();
	var delta = now - then;
	
	update(delta / 1000);
	
	then = now;

};

var then = Date.now();
setInterval(main, 1);

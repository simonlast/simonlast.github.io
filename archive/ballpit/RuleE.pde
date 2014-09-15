/* @pjs pauseOnBlur="true"; globalKeyEvents="true"; */

//const
color bkg = color(240);
float grav = .6;
float damp = .7;
float radDiv = 20.0;
float bounciness = .4;
float minRad;
float maxRad;
float friction = .97;
float msecs = 1000;
float maxThrowV = 6.0;
int maxNumBalls = 100;

//var
ArrayList<Circle> circles;
PVector lastMouse;
float driftV = 2.0;
int numAdded = 0;

void setup(){
	size(screenWidth,screenHeight);
	smooth();
	noStroke();
	//stroke(255);
	//strokeWeight(3);
	circles = new ArrayList<Circle>();
	lastMouse = new PVector();
        minRad = width/25.0;
        maxRad = width/15.0;
}

void draw(){
	
	background(bkg);
	float m = millis();
	int numSecs = (int)(m/msecs);
	if(numSecs > numAdded){

		circles.add(new Circle(random(width*.1,width*.9),-1*maxRad,random(minRad,maxRad),
			random(-1*maxThrowV,maxThrowV),random(-1*maxThrowV,maxThrowV)));
		numAdded++;
	}
	

	for(Circle c : circles){
			c.render();
	}

        if(circles.size() > maxNumBalls){
           ArrayList<Circle> toRemove = new ArrayList<Circle>();
           for(Circle c : circles){
             if(c.pos.x + c.rad < 0 || c.pos.x - c.rad > width){
               toRemove.add(c);
             }
           
           }
           for(Circle c : toRemove){
              circles.remove(c); 
           }
           //println(circles.size());
        }
	
	lastMouse = new PVector(mouseX,mouseY);
}

void mouseReleased(){
	float vx = (mouseX-lastMouse.x)*4.0;
	float vy = (mouseY-lastMouse.y)*4.0;
	if(vx > maxThrowV){
		vx = maxThrowV;
	}else if(vx < -1*maxThrowV){
		vx = -1*maxThrowV;
	}
	if(vy > maxThrowV){
		vy = maxThrowV;
	}else if(vy < -1*maxThrowV){
			vy = -1*maxThrowV;
	}
	circles.add(new Circle(mouseX,mouseY,random(minRad,maxRad),vx,vy));
}

class Circle{
	PVector pos,v;
	float rad;
	color c;
	boolean stuck;
	
	Circle(float x, float y, float r, float vx, float vy){
		pos = new PVector(x,y);
		v = new PVector(vx,vy);
		rad = r;
		c = color(random(100,200),random(100,200),random(100,200),172);
		stuck = false;
	}
	
	void groundBounceCheck(){
		if(pos.y + rad > height){
				//println(pos.y);
			v.y *= -1;
			v.y *= damp;
			v.x *= friction;
			pos.y = height-rad;
				//println(pos.y);
		}/*if(pos.x - rad < 0){
			v.x *= -1;
			v.x *= damp;
			pos.x = rad;
		}if(pos.x + rad > width){
				v.x *= -1;
				v.x *= damp;
				pos.x = width-rad;
			}
			*	*/
		
		
	}
	
	boolean circleBounceCheck(){
		for(Circle c : circles){
			if(c == this){
				continue;
			}
			float d = PVector.dist(pos,c.pos);
			if(d < rad+c.rad){
				
				float m1 = rad/radDiv;
				float m2 = c.rad/radDiv;

				PVector averagePos = new PVector((pos.x+c.pos.x)/2,(pos.y+c.pos.y)/2);
				PVector dX = new PVector(pos.x-averagePos.x,pos.y-averagePos.y);
				PVector cdX = new PVector(c.pos.x-averagePos.x,c.pos.y-averagePos.y);
				dX.mult(bounciness/m1);
				cdX.mult(bounciness/m2);
				v.add(dX);
				c.v.add(cdX);
				v.mult(damp);
				c.v.mult(damp);
				return true;
			}
		}
		return false;
	}
	
	void render(){
	
		
		circleBounceCheck();
		groundBounceCheck();
		
		v.y += grav;
		pos.add(v);
		
		fill(c);
		ellipse(pos.x,pos.y,rad*2,rad*2);
		
	}
	
	
}

/*

class Gun{
	PVector pos;
	float angle;
	ArrayList<Circle> queue;
	
	Gun(){
		pos = new PVector(width/2,0);
		angle = PI/-2;
		queue = new ArrayList<Circle>();
		for(int i=0; i<5; i++){
			queue.add(new Circle(width/2,0,random(minRad,maxRad)));
		}
	}
	
	void render(){
		
		//for(Circle c : queue){
			
		//}
		
	}
	
	void fire(){
		
		
	}
	
	
	
	
}


*/







/* @pjs pauseOnBlur="true"; globalKeyEvents="true"; */
ArrayList<Planet> planets;
Planet sun,earth,mars,jupiter;
Planet goal,start,centerMass,hit;
ArrayList<BlackHole> blackholes;
Player player;
boolean pressed,started,win,lose,fuelOut;
PVector diff;
int initPos;
color bkg = color(30);
PFont f,f2;
int fuel;

float playerSpeed = .2;
float launchSpeed = 2;
float theta = 0;

float g = .0025;
float pMass = 2;
float rad = 15;
int level = 0;
float pi = 3.14159265;

void setup(){
  size(screenWidth,screenHeight);
  smooth();
  fuelOut = false;
  theta = 0;
  f = loadFont("data/KozGoPro-Regular-48.vlw");
   f2 = loadFont("data/KozGoPro-Regular-100.vlw");
  bkg = color(30);
  background(bkg);
  noStroke();
  strokeWeight(1);
  planets = new ArrayList<Planet>();
    win = false;
  lose = false;
   pressed = false;
  started = false;
  diff = new PVector(0,0);
  
  if(level == 0){
     fuel = 9999999;
        launchSpeed = .2;
    playerSpeed = .2;
    earth = new Planet(30,1,width*4.5/6,height*4.8/6,0,0);
    earth.drawR = 150;
    earth.c = color(132,112,255);
    centerMass = earth;
    start = earth; 
    planets.add(earth);
    earth.name = "that planet";
    
    jupiter = new Planet(40,317.8,width*.8,height/2,0,0);
    jupiter.c = color(50,205,50);
    jupiter.name = "that planet";
    planets.add(jupiter);
    goal = jupiter;
    
  }
  else if(level == 1){
    fuel = 5;
    playerSpeed = 1;
    launchSpeed = 2;
    earth = new Planet(70,300000,width/2,height/2,0,0);
   earth.drawR = 150;
    earth.c = color(102,205,170);
    centerMass = earth;
    start = earth; 
    planets.add(earth);
    earth.name = "Earth";
    
  //    sun = new Planet(70,300000,width/2,height/2,0,0);
    //sun.c = color(255,215,0);
    //planets.add(sun);
  
  //centerMass = sun;
    Planet moon = new Planet(40,317.8,width*.8,height/2,0,0);
    planets.add(moon);
    goal = moon;
    moon.circleOrbit();
    
    goal.name = "The Moon";

    
    
    
  }
  else if(level == 2){
   
        fuel = 10;
    launchSpeed = .2;
    playerSpeed = .2;
  sun = new Planet(70,300000,width/2,height/2,0,0);
  sun.c = color(255,215,0);
  planets.add(sun);
  sun.name = "The Sun";
  
  centerMass = sun;
 
  earth = new Planet(40,1,width*.6,height/2,0,0);
  earth.c = color(102,205,170);
  earth.circleOrbit();
  earth.name = "The Earth";
  
  mars = new Planet(30,.7,width*.8,height/2,0,0);
  mars.c = color(205,92,92);
  mars.circleOrbit();
  mars.name = "Mars";
  
  /*
  jupiter = new Planet(40,317.8,width*.8,height/2,0,0);
  jupiter.c = color(255,140,0);
  jupiter.circleOrbit();
  jupiter.name = "Jupiter";
  */

  goal = mars;
  start = earth;
 
  planets.add(mars);
  planets.add(earth);
  // planets.add(jupiter);
    
  }
  else if(level == 3){
      
    fuel = 10;
    launchSpeed = .2;
    playerSpeed = .2;
    sun = new Planet(70,300000,width/2,height/2,0,0);
    sun.c = color(255,215,0);
    planets.add(sun);
    sun.name = "The Sun";
    
    centerMass = sun;
      
    mars = new Planet(30,.7,width*.6,height/2,0,0);
    mars.c = color(205,92,92);
    mars.circleOrbit();
    mars.name = "Mars";
    
    jupiter = new Planet(40,317.8,width*.8,height/2,0,0);
    jupiter.c = color(255,140,0);
    jupiter.circleOrbit();
    jupiter.name = "Jupiter";
    
    for(int x=0; x<20; x++){
     Planet p = new Planet(random(10,15),.1,width*.7+random(-50,50),height/2,0,0);
     p.circleOrbit();
     p.name = "an asteroid";
     for(int i=0; i<(int)random(40000); i++)
       p.update();
     planets.add(p);
    }
    
    start = mars;
    goal = jupiter;
    
    planets.add(mars);
    planets.add(jupiter);
    
   
  }else if(level ==4){
        fuel = 6;
    launchSpeed = 3;
    playerSpeed = .2;
    jupiter = new Planet(70,100000,width/2,height/2,0,0);
    jupiter.c = color(255,140,0);
    jupiter.name = "Jupiter";
    planets.add(jupiter);
    centerMass = jupiter;
    start = jupiter;
    
    for(int x=0; x<10; x++){
     Planet p = new Planet(random(10,30),.1,width*.6+random(200),height/2,0,0);
     p.circleOrbit();
     p.name = "the wrong moon";
     p.c = color(200+random(-20,20),200+random(-20,20),200+random(-20,20));
     for(int i=0; i<(int)random(80000); i++)
       p.update();
     planets.add(p);
    }
    
    Planet moon = new Planet(20,.7,width*.8,height/2,0,0);
    moon.circleOrbit();
    moon.c = color(135,206,250);
    moon.name = "Callisto";
    goal = moon;
    planets.add(moon);
    
    
  }else if(level ==5){
     fuel = 20;
    launchSpeed = .2;
    playerSpeed = .2;
    jupiter = new Planet(70,100000,width/2,height/2,0,0);
    jupiter.c = color(255,140,0);
    jupiter.name = "Jupiter";
    planets.add(jupiter);
    centerMass = jupiter;
    
    for(int x=0; x<8; x++){
     Planet p = new Planet(random(10,30),.1,width*.6+random(200),height/2,0,0);
     p.circleOrbit();
     p.name = "the wrong moon";
     p.c = color(200+random(-20,20),200+random(-20,20),200+random(-20,20));
     for(int i=0; i<(int)random(160000); i++)
       p.update();
     planets.add(p);
    }
    
    Planet moon = new Planet(20,.7,width*.8,height/2,0,0);
    moon.circleOrbit();
    moon.name = "Callisto";
    moon.c = color(135,206,250);
    start = moon;
    planets.add(moon);
    
    Planet moon2 = new Planet(20,.7,width*.55,height/2,0,0);
    moon2.circleOrbit();
    moon2.name = "Io";
     moon2.c = color(218,165,32);
    goal = moon2;
    planets.add(moon2);
    
    
  }else if(level ==6){
        fuel = 6;
    launchSpeed = .2;
    playerSpeed = .2;
    sun = new Planet(70,300000,width/2,height/2,0,0);
    sun.c = color(255,215,0);
    planets.add(sun);
    sun.name = "The Sun";
    
    centerMass = sun;
    
    jupiter = new Planet(50,317.8,width*.6,height/2,0,0);
    jupiter.c = color(255,140,0);
    jupiter.circleOrbit();
    jupiter.name = "Jupiter";
    
    Planet saturn = new Planet(30,317.8,width*.8,height/2,0,0);
    saturn.c = color(218,165,32);
    saturn.circleOrbit();
    saturn.name = "Saturn";
    
    planets.add(saturn);
    planets.add(jupiter);
    
    for(int x=0; x<25; x++){
     Planet p = new Planet(random(10,15),.1,width*.7+random(-50,50),height/2,0,0);
     p.v.y = random(1.5,2.2);
     p.v.x = random(-.7,.7);
     p.c = color(72,209,204,172);
     p.name = "a comet";
     for(int i=0; i<(int)random(160000); i++)
       p.update();
     planets.add(p);
    }
    
    start = jupiter;
    goal = saturn;
    
   
   
  }else if(level == 7){
    fuel = 6;
    launchSpeed = 4.5;
    playerSpeed = 1;
    Planet saturn = new Planet(70,400000,width/2,height/2,0,0);
    saturn.c = color(218,165,32);
    saturn.name = "Saturn";
    planets.add(saturn);
    centerMass = saturn;
    start = saturn;
    
    for(int x=0; x<15; x++){
     Planet p = new Planet(random(10,30),.1,width*.6+random(200),height/2,0,0);
     p.circleOrbit();
     p.name = "the wrong moon";
     p.c = color(200+random(-20,20),200+random(-20,20),200+random(-20,20));
     for(int i=0; i<(int)random(80000); i++)
       p.update();
     planets.add(p);
    }
    
    Planet moon = new Planet(30,.7,width*.8,height/2,0,0);
    moon.circleOrbit();
    moon.c = color(255,215,0);
    moon.name = "Titan";
    goal = moon;
    planets.add(moon);
    
    
    
    
  }else if(level == 8){
    fuel = 20;
    launchSpeed = .2;
    playerSpeed = .2;
    Planet saturn = new Planet(70,400000,width/2,height/2,0,0);
    saturn.c = color(218,165,32);
    saturn.name = "Saturn";
    planets.add(saturn);
    centerMass = saturn;
    
    for(int x=0; x<15; x++){
     Planet p = new Planet(random(10,30),.1,width*.6+random(200),height/2,0,0);
     p.circleOrbit();
     p.name = "the wrong moon";
     p.c = color(200+random(-20,20),200+random(-20,20),200+random(-20,20));
     for(int i=0; i<(int)random(80000); i++)
       p.update();
     planets.add(p);
    }
    
    for(int x=0; x<8; x++){
     Planet p = new Planet(random(10,15),.1,width*.7+random(-50,50),height/2,0,0);
     p.v.y = random(1.5,2.2);
     p.v.x = random(-.7,.7);
     p.c = color(72,209,204,172);
     p.name = "a comet";
     for(int i=0; i<(int)random(160000); i++)
       p.update();
     planets.add(p);
    }
    
    Planet moon = new Planet(30,.7,width*.8,height/2,0,0);
    moon.circleOrbit();
    moon.c = color(255,215,0);
    moon.name = "Titan";
    goal = moon;
    planets.add(moon);
    start = moon;
    
        Planet moon2 = new Planet(20,.7,width*.55,height/2,0,0);
    moon2.circleOrbit();
    moon2.name = "Pan";
    moon2.v.y *= -1;
     moon2.c = color(186,85,211);
    goal = moon2;
    planets.add(moon2);
    
  }else if(level == 9){
         fuel = 20;
    launchSpeed = .1;
    playerSpeed = .1;
    
    blackholes = new ArrayList<BlackHole>();
    
    BlackHole b1 = new BlackHole(300000,100,height-100,100);
     BlackHole b2 = new BlackHole(300000,width-100,80,100);
     b1.other = b2;
     b2.other = b1;
     blackholes.add(b1);
     blackholes.add(b2);
     
     jupiter = new Planet(70,300000,width/2,height/2,0,0);
    jupiter.c = color(255,140,0);
    jupiter.name = "Jupiter";
    planets.add(jupiter);
    centerMass = jupiter;
    
    for(int x=0; x<40; x++){
     Planet p = new Planet(random(5,15),.1,width*.6+random(300),height/2,0,0);
     p.circleOrbit();
     p.name = "an asteroid";
     p.c = color(200+random(-20,20),200+random(-20,20),200+random(-20,20));
     for(int i=0; i<(int)random(160000); i++)
       p.update();
     planets.add(p);
    }
    
     for(int x=0; x<20; x++){
     Planet p = new Planet(random(10,15),.1,width*.7+random(-50,150),height/2,0,0);
     p.v.y = random(1.5,2.2);
     p.v.x = random(-.7,.7);
     p.c = color(72,209,204,172);
     p.name = "a comet";
     for(int i=0; i<(int)random(160000); i++)
       p.update();
     planets.add(p);
    }
    
    Planet moon = new Planet(30,.7,width*.8,height/2,0,0);
    moon.c = color(255,127,80);
    moon.circleOrbit();
    moon.name = "Home";
    goal = moon;
    planets.add(moon);
    start = moon;
    
    Planet moon2 = new Planet(20,.7,width*.8,height/2,0,0);
    moon2.name = "the Space Station";
    moon2.circleOrbit();
    moon2.c = color(230,230,250);
       //  for(int i=0; i<(int)random(800000); i++)
      // moon2.update();
    moon2.pos.x = width*.2;
    moon2.v.y *= -1;
    goal = moon2;
    planets.add(moon2);
    
    
  }
  else if(level == 10){

    
     Planet pl,pl2,star,star2;
       fuel = 20;
    launchSpeed = .2;
    playerSpeed = .2;
    
    star = new Planet(70,100000,width/2-100,height/2,0,0);
    star.c = color(175,238,238);
    planets.add(star);
    star.name = "Hadar A";
    
    
    
    star2 = new Planet(70,100000,width/2+100,height/2,0,0);
    star2.c = color(175,238,238);
    planets.add(star2);
    star2.name = "Hadar B";
    
    centerMass = star;
    
    star.v.y = .8;
    star2.v.y = -.8;

  pl = new Planet(25,1,width/2,height/2,0,0);
  pl.c = color(188,143,143);
  pl.circleOrbit();
  pl.name = "The Doomed Planet";
  
  pl2 = new Planet(25,1,width*.7,height/2,0,0);
  pl2.c = color(102,205,170);
  pl2.circleOrbit();
  pl2.v.mult(.7);
  pl2.name = "The Planet";
 

  goal = pl2;
  start = pl;
 
  planets.add(pl);
  planets.add(pl2);
    
    
  }
  else{
    blackholes = new ArrayList<BlackHole>();
       
     fuel = 999999;
    launchSpeed = .2;
    playerSpeed = .2;
    /*
    int xR = (int)random(9);
    int yR = (int)random(4);
    Planet moon = new Planet(30,.7,xR*100+130,yR*150+155,0,0);
    moon.c = color(255,127,80);
    moon.name = "Planet A";
    planets.add(moon);
    start = moon;
    int xR2 = 1;
    int yR2 = 1;
    do{
    xR2 = (int)random(9);
    yR2 = (int)random(4);
    }while(xR2 == xR || yR2 == yR);
    
   
    
    Planet moon2 = new Planet(30,.7,xR2*100+130,yR2*150+155,0,0);
    moon2.name = "Planet B";
    moon2.c = color(230,230,250);
       //  for(int i=0; i<(int)random(800000); i++)
      // moon2.update();
    goal = moon2;
    planets.add(moon2);
    */
    
    for(int x =0; x<9; x++){
      for(int y = 0; y<4; y++){
      Planet p = new Planet(30,.7,x*100+130,y*150+155,0,0);
      p.name = "Planet " + (int)random(1e6);
      p.c = color(100+random(100),100+random(100),100+random(100));
      planets.add(p);
      }
    }
    
    int r1 = (int)random(36);
    int r2 = 1;
    do{
      r2 = (int)random(36);
    }while(r1 == r2);
    
    start = planets.get(r1);
    goal = planets.get(r2);
    
    for(int x =0; x<10; x++){
      for(int y = 0; y<5; y++)
     blackholes.add(new BlackHole( 300000,x*100+80,y*150+80,70+random(-15,15)));
    }
    for(int x=0; x<blackholes.size(); x++){
      BlackHole b = blackholes.get(x);
      b.other = blackholes.get((int)random(blackholes.size()));
    }
    
    
  }
  

  player = new Player(.0001,width*.6+start.r/2+7,height/2,14,14);
  



  
}

void draw(){

  if(!lose && !win){
     background(bkg);
     if(level == 0)
       welcome();
    if(!started)
      displayText();
      
   
  for(Planet p : planets)
    p.render();
    
   if(blackholes != null){
      for(BlackHole b : blackholes)
        b.render();
   }
    
   player.render();
  
    fill(250);
    textFont(f,30);
    text("Fuel: " + fuel,width-130,40);
    
    if(fuel <= 0)
      text("You ran out of fuel!\nPress 'R' to restart",30,40);
    else  if(player.pos.x < -30 || player.pos.x > width + 30 || player.pos.y < -30 || player.pos.y > height + 30)
      text("Where'd you go?\nPress 'R' to restart",30,40);
  
  }else{
   displayText(); 
  }
  
  
 
}

void welcome(){
  fill(250);
    textFont(f2,100);
    text("Welcome to Voyager!",65,170);
    
    textFont(f,30);
    text("Use the left and right arrow keys to change\nyour initial position. When you're ready,\npress the up arrow to launch. Then use the\nup arrow to boost, and the left and right\narrows to turn. Get to the object highlighted\nin gray to complete a level. Press the 'R' key\nto restart a level. One more thing - try not to\nrun out of fuel!",50,260);
    text("Go here.",width-160,380);
  }

void displayText(){
  textFont(f,48);
  if(!started && !win){
    fill(250);
    if(level==10){
          fill(bkg);
    rect(0,0,800,200);
      fill(250);
    text("Escape Beta Centauri!",20,60); 
    }
    else if(level > 10)
    text("You beat the game!\nNow enjoy this wormhole maze.",20,60);
    else if(level != 0)
    text("Get to " + goal.name + "!",20,60);
    if(level == 6)
    text("\nWatch out for comets!",20,60);

    
  }
  if(lose){
    fill(bkg);
    int len = hit.name.length();
    rect(0,0,200+len*25,200);
    
     if(level == 0){
       fill(bkg);
      rect(0,0,width,200);
    } 
    fill(250);
    
    text("You hit " + hit.name + "!",20,60);
    textFont(f,30);
    text("Press any key to try again",20,110);
    
  
  }
  else if(win){
           fill(bkg);
       int len = goal.name.length();
    rect(0,0,300+len*25,200);
    if(level == 0){
      rect(0,0,width,200);
    } 
    
    
    fill(250);
    
       text("You got to " + goal.name + "!",20,60);
           textFont(f,30);
    text("Press any key to continue",20,110);
  
  }
}

//adding asteroids
/*
void mousePressed(){
  if(!pressed){
    diff = new PVector(mouseX,mouseY);
  }
  pressed = true;
}

void mouseReleased(){
  
  diff.sub(new PVector(mouseX,mouseY));
  diff.div(30);
  planets.add(new Planet(rad,pMass,mouseX,mouseY,diff.x,diff.y));
  pressed = false;
  
}
*/

void keyPressed(){
  if(win && keyCode != UP){
   level++;
   setup(); 
  }
  if(lose && keyCode != UP)
    setup();
  if(key == 'r')
    setup();
 if (!started){
   if(keyCode == UP){
 
  started = true;
  player.m.normalize();
  player.m.mult(launchSpeed);
  player.v = new PVector(start.v.x,start.v.y);
  player.v.add(player.m);
  
   }else if(keyCode == LEFT){
     theta-=pi/4;
     
   }else if(keyCode == RIGHT){
     theta+=pi/4;
     
   }
 }
 if(started){
  if(keyCode == RIGHT){
   theta+=.5;
  } 
    if(keyCode == UP){
    if(fuel > 0){
    player.m = new PVector(cos(theta),sin(theta));
    player.m.normalize();
    player.m.mult(playerSpeed);
    player.v.add(player.m);
    fuel--;
    if(fuel < 0){
    fuelOut = true;
    }
    }
  } 
    if(keyCode == LEFT){
   theta-=.5;
  }

   
 }
  
}


class Planet{
 float r,mass,drawR;
 PVector pos,v,a; 
 color c;
 String name;
  
 Planet(float r,float mass,float x,float y,float vx,float vy){
   this.r = r;
   this.drawR = r;
   this.mass = mass;
   this.pos = new PVector(x,y);
   this.v = new PVector(vx,vy);
   this.a = new PVector(0.0,0.0);
   c = color(200);
 }
 
 Planet(){
   r = mass = 0.0;
   pos = new PVector(0,0);
   v = new PVector(0,0);
   a = new PVector(0,0);
 }
 
 void update(){
   a = new PVector(0.0,0.0);
   for(Planet p : planets){
     if(p != this){
       float d = pos.dist(p.pos);
       if(d > r){
       float accel = g * p.mass / sq(d);
       PVector dA = PVector.sub(p.pos,pos);
       dA.normalize();
       dA.mult(accel);
       a.add(dA);
       }
     }
   }
   v.add(a);
   pos.add(v);
 }
 
 void circleOrbit(){
  update();
  v = new PVector(0,sqrt(a.mag()*(pos.x-centerMass.pos.x)));
  
 }
 
 void render(){
  update();
  
  
  if(this == goal){
  fill(255,10);
  ellipse(pos.x,pos.y,drawR+50,drawR+50);
  }
  
  if(this.name.equals("Saturn")){
   int opac = 20;
   fill(218,165,32,opac);
   ellipse(pos.x,pos.y,drawR+80,drawR+80);
   fill(205,133,63,opac);
   ellipse(pos.x,pos.y,drawR+110,drawR+110);
   fill(218,165,32,opac);
   ellipse(pos.x,pos.y,drawR+140,drawR+140); 
   fill(bkg);
   ellipse(pos.x,pos.y,drawR+50,drawR+50); 
   
    
  }
  
  fill(c);
  ellipse(pos.x,pos.y,drawR,drawR);
 }
  
  
}

class Player extends Planet{
  float w,h,d;
  PVector m; //stick position
  
  Player(float mass,float x,float y,float w, float h){
   super();
   this.mass = mass;
   this.pos = new PVector(x,y);
   this.w = w;
   this.h = h;
   this.v = new PVector(0,0);
   this.a = new PVector(0.0,0.0);
   d = start.drawR/2+w/2;
   c = color(172);
   m = new PVector(1,0);
  }
  
  void update(){
       a = new PVector(0.0,0.0);
   for(Planet p : planets){
       float d = pos.dist(p.pos);
       float accel = g * p.mass / sq(d);
       PVector dA = PVector.sub(p.pos,pos);
       dA.normalize();
       dA.mult(accel);
       a.add(dA);
   }
   v.add(a);
   pos.add(v);
  }
  
  void stick(){
    m = new PVector(cos(theta),sin(theta));
    m.normalize();
    m.mult(d);
    pos = PVector.add(start.pos,m); 
  }
  
  void collisionCheck(){
    for(Planet p: planets){
     if( pos.dist(p.pos) < w/2 + p.drawR/2)
       if(p == goal){ //&& PVector.sub(p.v,v).mag() < 12){
         win = true;
         start = goal;
         started = false;
         d = start.drawR/2+w/2;
         theta = PVector.angleBetween(v,start.pos);
         break;
       }
        else{
          lose = true;
          hit = p;
        }
     }
  }
  
  void render(){
   if(started){
     update();
     collisionCheck();
   }
   else
     stick();
     

   
   fill(200);
   ellipse(pos.x,pos.y,w,h);
    m = new PVector(cos(theta),sin(theta));
    m.normalize();
    m.mult(w);
    stroke(200);
    strokeWeight(5.0);
    strokeCap(ROUND);
    line(pos.x,pos.y,pos.x+m.x*.7,pos.y+m.y*.7);
   //triangle(pos.x+m.x,pos.y+m.y,pos.x-m.x,pos.y,pos.x+m.x,pos.y);
   noStroke();
  }
  
  
}

class BlackHole extends Planet{
  BlackHole other;
  
  BlackHole(float mass,float x,float y,float r){
   super();
   this.mass = mass;
   this.pos = new PVector(x,y);
   this.r =r;
   this.drawR = r;
   c =   color(160,32,240);
   }
   
  void playerCollide(){
    if( pos.dist(player.pos) < r/2 + player.w/2){
      player.m.normalize();
      player.m.mult(r/2+player.w/2);
      player.pos = new PVector(other.pos.x+player.m.x,other.pos.y+player.m.y);
      player.pos.add(player.v);
      
    }
  }
   
   
  void render(){
    
  playerCollide();
  
  fill(c,50);
  ellipse(pos.x,pos.y,r,r);
  ellipse(pos.x,pos.y,r*2/3,r*2/3);
  ellipse(pos.x,pos.y,r/3,r/3);

 }
  
  
}





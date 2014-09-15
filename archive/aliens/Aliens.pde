float triangWidth, blasterSpeed, alienXspeed, alienspeed, alienWidth;
Blaster b;
ArrayList bullets, aliens;
PFont f, f2;
boolean lose, win, roundsbool, gamestarted;
int rounds, points;
color bkg = color(50);

void setup(){
 size(screenWidth,screenHeight);
 smooth();
 background(bkg); 
 triangWidth = 30;
 b = new Blaster();
 blasterSpeed = 6;
 bullets = new ArrayList();
 aliens = new ArrayList();
 alienWidth = width/40;
 //for(int x=1; x<4; x++)
 //  aliens.add(new Alien(5*x*random(5,25),5*x*random(5,25),random(30,50)));
 for(int x=1; x<11; x++)
   for(int y=1; y<9; y++)
     aliens.add(new Alien(x*width/11-20,y*(height-200)/8,alienWidth));
 
 f = createFont("Helvetica",50);
 f2 = createFont("Helvetica",100);
  lose = false;
  alienspeed = .05;
  win = false;
  rounds = 0;
  roundsbool = false;
  alienXspeed = .5;
  gamestarted = false;
  points = 0;
}

void draw(){
  if(gamestarted){
  if(aliens.size() == 0)
  win = true;
  if(!win){
  if(!lose){
  background(bkg);
   if(!keyPressed)
   b.update(0);
   //blaster movement; 
  if(b.v < .2 && b.v > -.2){
    b.resetA();
  }
  if(b.x - triangWidth/2 <= 0 || b.x + triangWidth/2 >= width){
   if(b.x - triangWidth/2 <= 0)
     b.x = 1+triangWidth;
     else
     b.x = width-1-triangWidth;
   b.v *= -1;
   b.a *= -1; 
  }
  b.render();
  
  for(int x=0; x<bullets.size(); x++){
   Bullet temp = (Bullet)bullets.get(x); 
   if(temp.y < 0)
   bullets.remove(temp);
   else
   temp.render();
  }

  for(int x=0; x<bullets.size(); x++){
    Bullet temp = (Bullet)bullets.get(x);
   for(int i=0; i<aliens.size(); i++){
   Alien temp1 = (Alien)aliens.get(i);
   //temp1.render(); 
   if(isKill(temp,temp1)){
     bullets.remove(temp);
     temp1.explode();
     points += 10;
     aliens.remove(temp1);
     break;
   }
   }
  }
  
  for(int i=0; i<aliens.size(); i++){
   Alien temp1 = (Alien)aliens.get(i);
   if(temp1.pos.y+temp1.w > height)
   lose = true;
   temp1.pos.y += alienspeed;
   float p = temp1.pos.x;
   if(p>=50 && p<=width-50){
    if(temp1.dir) 
     temp1.pos.x += alienXspeed;
     else
     temp1.pos.x += -1*alienXspeed;
   }
   else if(p<50){
     temp1.dir = !temp1.dir;
     temp1.pos.x = 50;  
 }
    else if(p> width-50){
     temp1.dir = !temp1.dir;
     temp1.pos.x = width-50;  
 }
   //temp.pos.y 
   temp1.render(); 
  }
  }
  else{
  background(bkg); 
   fill(250);
   textFont(f,width/5);
  text("oops",50,width/5);
  textFont(f,width/15);
  text("press 'o' to retry.",50,width/3);
    if(!roundsbool){
  rounds = 0;
  points = 0;
  alienspeed = .05 - .03;
  alienXspeed = .1 - .03;
  roundsbool = true;
  }
  
  }
  }
  else{
  background(bkg); 
  fill(250);
  textFont(f,width/5);
  text("nice!",50,width/5);
  textFont(f,width/15);
  text("press 'o' to advance\nit gets harder.",50,width/3.5);
  if(!roundsbool){
  rounds++;
  roundsbool = true;
  }
    
  }
  
  fill(250);
  textAlign(RIGHT); 
  textFont(f2,width/15);
  text(points,width-15,width/16);
  textAlign(LEFT);

}
else{
  background(bkg);
     fill(250);
  textFont(f,width/5);
  text("aliens",50,width/5);
  textFont(f,width/15);
  text("use the arrow keys to move\nand SPACE to fire\nclick to start.",50,width/3.5);
  b.render();
}

}
void mousePressed(){
 gamestarted = true; 
}


void keyPressed(){
  //b.resetA();
  if(!lose && !win && gamestarted){
  if(keyCode == LEFT){
    b.resetA();
    b.update(-1*blasterSpeed);

  }
  else if(keyCode == RIGHT){
       b.resetA();
    b.update(blasterSpeed);
  }
  
  
  
  if(key == ' ')
    b.fire();
  }
  else if(key == 'o')
  restart();
}

void keyReleased(){
   
    if(key == 'a')
    b.updateA();
  if(key == 'd')
    b.updateA();
}

boolean isKill(Bullet b,Alien a){
 if(b.x < a.pos.x || b.x > a.pos.x + a.w)
    return false;
 if(b.y -10 < a.pos.y - a.w || b.y-10 > a.pos.y)
   return false;
  return true;
}

void restart(){
  background(bkg); 
 triangWidth = 30;
 b = new Blaster();
 blasterSpeed = 6;
 bullets = new ArrayList();
 aliens = new ArrayList();
 //for(int x=1; x<4; x++)
 //  aliens.add(new Alien(5*x*random(5,25),5*x*random(5,25),random(30,50)));
 for(int x=1; x<11; x++)
   for(int y=1; y<9; y++)
      aliens.add(new Alien(x*width/11-20,y*(height-200)/8,alienWidth));
 
 f = loadFont("Serif-48.vlw");
  lose = false; 
  alienspeed += .03;
  alienXspeed += .03;
  win = false;
  roundsbool = false;
}

class Blaster{
 float x;
 float v;
 float a;
 
 Blaster(){
  x = width/2; 
  v = 0;
  a = 0;
 }
 
 void update(float veloc){
  v = veloc;
 }
 
 void updateA(){
   
  a = v / 8;
  
 }
 
 void resetA(){
  a = 0.0; 
 }
 
 void render(){
   v -= a; 
   x += v;
   noFill();
    strokeWeight(2);
   stroke(255);
   triangle(x-triangWidth/2,height-10,x,height-45,x+triangWidth/2,height-10);
   
 }
 
 void fire(){
   bullets.add(new Bullet(x));
   
   
 }
  
  
}

class Bullet{
  
float x;
float y = height-45.0;
float vy = -3.0;

Bullet(float x1){
  x = x1;
}

void render(){
  y+= vy;
  //stroke(random(255),random(255),random(255));
  stroke(255);
  strokeWeight(2);
  line(x,y,x,y+10);
  
}
  
  
}

class Alien{ 
  PVector pos;
  float w;
  boolean dir;
  int r;
  int g;
  int b;
  
  Alien(float x,float y, float w1){
   pos = new PVector(x,y);
   w = w1;
   float r = random(2);
   if(r<1)
   dir = true;
   else
   dir = false;
   r = (int)random(255);
   g = (int)random(255);
   b = (int)random(255);
  }
  
  void render(){
     strokeWeight(2);
   fill(r,g,b,100);
   stroke(255);
   rect(pos.x,pos.y,w,w);
    
  }
  
  void explode(){
   fill(255,0,0);
   stroke(255,0,0);
   strokeWeight(5);
   rect(pos.x,pos.y,w,w); 
    
  }
  
  
  
}

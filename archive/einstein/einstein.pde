/* @pjs pauseOnBlur="true"; globalKeyEvents="true"; */

ArrayList eins;
PImage[][] es = new PImage[4][2];
PVector eSpeed = new PVector(1,2);
PVector eDimen, playerDimen;
PFont f;
int points, time;
float playerHeight, pSpeed;
Player p;
Timer timer;
boolean started, lost;


void setup(){
  size(screenWidth,screenHeight);
  background(60);
  es[0][0] = loadImage("/px/e1.png");
  es[0][1] = loadImage("/px/e1b.png");
  es[1][0] = loadImage("/px/e2.png");
  es[1][1] = loadImage("/px/e2b.png");
  es[2][0] = loadImage("/px/e3.png");
  es[2][1] = loadImage("/px/e3b.png");
  es[3][0] = loadImage("/px/e4.png");
  es[3][1] = loadImage("/px/e4b.png");
  eins = new ArrayList();
  eDimen = new PVector(27,68);
  //for(int x=0; x<5; x++)
  f = loadFont("Serif-20.vlw");
  playerHeight = height-60;
  playerDimen = new PVector(200,30);
  pSpeed = 15;
  p = new Player(width/2 - playerDimen.x/2);
  time = 3000;
  timer = new Timer(time);
  timer.start();
  started = false;
  points = 0;
  lost = false;


}

void draw(){
  background(30);
  if(started){
  

  for(int x=0; x<eins.size(); x++){
  Einstein temp = (Einstein)eins.get(x);
  temp.render();
  }
  if(!lost)
  p.render();

  
  if(timer.isFinished()){
  eins.add(new Einstein(random(50,width-50)));
  timer = new Timer(time - points*5);
  timer.start();
  }
}
  loadText();
}

void loadText(){
 textFont(f,30);
 fill(255);
 if(!lost)
 text("Score: "+points,width-150,40);
 if(!started)
 text("Use the arrow keys to catch falling Einsteins\nPress any key to start",width/2-350,height/2-50);
 if(lost){
 text("You Lose!\nPress any key to restart",width/2-100,height/2-50);
 }
}

void keyPressed(){
  if(!started || lost)
  started = true;
  if(lost)
  setup();
  else{
 //if(key =='/')
 //eins.add(new Einstein(random(100,width-100)));
 if(keyCode ==LEFT){
 p.v = -1*pSpeed;
 }
 if(keyCode == RIGHT){
 p.v = pSpeed;  
 }
  }
}

class Einstein{
  PVector pos;
  PVector dimen;
  PVector v;
  boolean dir;
  int einsteinNum;
  PImage img;
  int imgNum;
  
  Einstein(float x){
  dimen = eDimen;
  einsteinNum = (int)random(4);
  pos = new PVector(x,-100);
  if((int)random(2)==0){
  dir = true;
  v = new PVector(eSpeed.x,eSpeed.y);
  img = es[einsteinNum][1];
  imgNum = 1;
  }
  else{
  dir = false;
  v = new PVector(-1*eSpeed.x,eSpeed.y);
  img = es[einsteinNum][0];
  imgNum =0; 
  }
  }
  
  void bounceCheck(){
  if(pos.x <= 0 || pos.x + eDimen.x >= width){
    v.x *= -1;  
  if(imgNum ==0){
  img = es[einsteinNum][1];
  imgNum = 1;

  }
  else if(imgNum ==1){
  img = es[einsteinNum][0];
  imgNum = 0;
  }  
  
  }
  if(pos.y > height){
   eins.remove(this);
   points-= 5; 
   if(points < 0)
   lost = true;
  }
  }
  
  void render(){
    bounceCheck();
    pos.add(v);
    image(img,pos.x,pos.y);
    
  }
}

class Player{
  PVector pos;
  PVector dimen;
  float v;
  float decel = 1.1;
  
  Player(float x){
    pos = new PVector(x,playerHeight);
    dimen = playerDimen;
    v = 0;
  }
 
 void check(){
     for(int x=0; x<eins.size(); x++){
  Einstein temp = (Einstein)eins.get(x);
  if(temp.pos.x + temp.dimen.x >= pos.x && temp.pos.x <= pos.x + dimen.x && temp.pos.y + temp.dimen.y >= pos.y && temp.pos.y + temp.dimen.y <= pos.y + dimen.y){
  eins.remove(temp);
  points++;
  }
     }
   
 }
 
 void render(){
  check();
  if(abs(v) > pSpeed/10)
  v /= decel;
  else
  v = 0;
  if(pos.x <= 0){
  pos.x = 0;
  v = pSpeed/6;  
  }
  if(pos.x + dimen.x >= width){
  pos.x = width - dimen.x;
  v = -1*pSpeed/6;  
    
  }
  pos.x += v;
  fill(255);
  rect(pos.x,pos.y,dimen.x,dimen.y);
 } 
}

class Timer {
 
  int savedTime; // When Timer started
  int totalTime; // How long Timer should last
  
  Timer(int tempTotalTime) {
    totalTime = tempTotalTime;
  }
  
  // Starting the timer
  void start() {
    // When the timer starts it stores the current time in milliseconds.
    savedTime = millis(); 
  }
  
  // The function isFinished() returns true if 5,000 ms have passed. 
  // The work of the timer is farmed out to this method.
  boolean isFinished() { 
    // Check how much time has passed
    int passedTime = millis()- savedTime;
    if (passedTime > totalTime) {
      return true;
    } else {
      return false;
    }
  }
}


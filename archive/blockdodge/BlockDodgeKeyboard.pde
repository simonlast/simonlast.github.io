/* @pjs pauseOnBlur="true";  */
PFont f;
ArrayList<Block> blocks;
Block player;
boolean gameOver,started,newLevel;
int level,blockCounter,score,madeCounter;
float translated;

final float playerDimen = 40;
color bkg = color(250,250,250);
final color textCol = color(85,98,112,200);
final float divisor = 10.0;  
final float playerVeloc = 9.0;
float decel = .8;
float startSpeed = -4.0;


interface JavaScript {
       void submitScore(int score);
     }
  
   void bindJavascript(JavaScript js) {
      javascript = js;
    }
  
   JavaScript javascript;



void setup(){
  size(screenWidth,screenHeight);
  background(bkg);
  noStroke();
  smooth();
  player = new Block(width/2-playerDimen/2,height-playerDimen*1.5,playerDimen);
  player.veloc.y = startSpeed;
  blocks = new ArrayList<Block>();
  gameOver = false;
  newLevel = false;
  started = false;
  level = 1;
  blockCounter = 100;
  f = loadFont("Helvetica-50.vlw");
  translated = score = madeCounter =  0;
  player.a = 1;
}

void newGame(){

  if(javascript != null){
	javascript.submitScore(level);
  }
  background(bkg);
  player = new Block(width/2-playerDimen/2,height-playerDimen*1.5,playerDimen);
  player.veloc.y = startSpeed;
  blocks = new ArrayList<Block>();
  gameOver = false;
  newLevel = false;
  started = false;
  level = 1;
  blockCounter = 100;
  translated = score = madeCounter =  0;
  player.a = 1;
}


void draw(){
  background(bkg);
   fill(textCol);
  textFont(f,80);
  
  if(started){
  if(!gameOver){
    if(!newLevel){
    text("level "+level,20,70);
    
    translated = (height-playerDimen*1.5)-player.pos.y;
    translate(0,translated);

  getPlayerPos();
  addMoreBlocks();
  
  Block toRemove = null;
  
  for(Block b : blocks){
    b.render();
    if(b.collides()){
      gameOver = true;
      started = true;
      newLevel = false;
      newGame();
    }
    if(b.pos.y > player.pos.y + playerDimen*1.5){
      toRemove = b;
      score++; 
      
    }
  }
  
  if(toRemove != null){
   blocks.remove(toRemove); 
  }
 
  //println(score);
  if(score >= 10 + level*5){
    newLevel = true;
  }
  player.render();
  }else{
   newlevel(); 
  }
  }else{
   gameOver();
  }
  }else{
    welcome();
  }
  
  
}

void getPlayerPos(){
   
  if(player.pos.x < 0){
    player.pos.x = 0;
    player.veloc.x = 0; 
  }
  else if(player.pos.x + playerDimen > width){
    player.pos.x = width-playerDimen;
       player.veloc.x = 0; 
  } 
  else if(keyPressed && keyCode == LEFT){
    player.veloc.x = -1*playerVeloc;
  }
  else if(keyPressed && keyCode == RIGHT){
    player.veloc.x = playerVeloc;
  }
  
}

void addMoreBlocks(){
  int levelAmount = 150-level*10;
  if(levelAmount - 40 < 0)
  levelAmount = 60;
  blockCounter += (int)abs(player.veloc.y);
  if(blockCounter >= levelAmount && madeCounter < 10 + level*5){
   blockCounter = 0;
   if((int)random(5)==0 && level > 3)
   blocks.add(new MovingBlock(random(width-40),0-translated-60,40+level*3,40));
   else if((int)random(7)==0 && level > 5)
   blocks.add(new BombBlock(random(width-40),0-translated-60,40+level*3,40));
   else if((int)random(5)==0 && level > 7)
   blocks.add(new SizeBlock(random(width-40),0-translated-60,40+level*3,40,40+level*3+50));
   else
   blocks.add(new Block(random(width-40),0-translated-60,40+level*3,40, color(random(100,220),random(100,220),random(100,220))));
   madeCounter++;
  }
  
}

void welcome(){
 textFont(f,100);
 fill(textCol);
 text("Welcome to BlockDodge!",30,160); 
 textFont(f,80);
 text("use left and right to move.\navoid other blocks!\nclick to start.",30,290); 
}

void newlevel(){
 textFont(f,80);
 fill(textCol);
 text("you made it past level " + level + "!",30,120); 
 textFont(f,50);
 if(level+1 == 4)
 text("watch out for rainbow blocks!\n(they move)",30,480);
  if(level+1 == 6)
 text("watch out for bomb blocks!\n(they fall)",30,480);
  if(level+1 == 8)
 text("watch out for growing blocks!\n(they change size)",30,480);
 text("press something to continue.",40,270);
  
}

void gameOver(){
 textFont(f,80);
 fill(textCol);
 text("you Lost!\n\nyou made it to level " + level + "!",30,120); 
 textFont(f,50);
 text("press something try again.",30,300); 

}

void keyPressed(){
 mousePressed(); 
}

void mousePressed(){
 if(!started)
  started = true; 
  if(gameOver){
    newGame();
  }
 if(newLevel){
  newLevel = false;
  level++; 
  player.veloc.y -= .4;
  score = 0;
  madeCounter =  0;
  blocks = new ArrayList<Block>();
  player.pos.x = width/2-playerDimen/2;
 }

}

class Block{
  PVector pos,dimen,veloc;
  color col;
  float a;
  
  Block(float x, float y, float dimen){
    pos = new PVector(x,y);
    this.dimen = new PVector(dimen,dimen);
    col = color(0);
    veloc = new PVector(0,0);
  }
  
  Block(float x, float y, float xDimen, float yDimen,color c){
    pos = new PVector(x,y);
    this.dimen = new PVector(xDimen,yDimen);
    col = c;
    veloc = new PVector(0,0);
  }
  
  void setColor(color c){
    col = c;
  }
  
  void setVeloc(float x, float y){
   veloc = new PVector(x,y); 
  }
  
  void render(){
    fill(col,200);
    if( a != 0){
     veloc.x *= decel;
    }
    pos.add(veloc);
    rect(pos.x,pos.y,dimen.x,dimen.y,5);
  }
  
  boolean collides(){
    if(player.pos.x >= pos.x && player.pos.x <= pos.x + dimen.x && player.pos.y >= pos.y && player.pos.y <= pos.y + dimen.y)
      return true;
    if(player.pos.x + playerDimen >= pos.x && player.pos.x + playerDimen <= pos.x + dimen.x && player.pos.y >= pos.y && player.pos.y <= pos.y + dimen.y)
      return true;
    return false;
    
  }
    
}

class MovingBlock extends Block{
 
 MovingBlock(float x, float y, float xDimen, float yDimen){
  super(x,y,xDimen,yDimen,color(0));
  veloc = new PVector((int)random(-10,10)/10.0*level,0);
 }
 
 void render(){
    fill(random(255),random(255),random(255),200);
    if(pos.x < 0 || pos.x + dimen.x > width)
    veloc.x*= -1;
    pos.add(veloc);

    rect(pos.x,pos.y,dimen.x,dimen.y,5);
 }
  
  
}

class BombBlock extends Block{
 
 boolean alternate; 
  
 BombBlock(float x, float y, float xDimen, float yDimen){
  super(x,y,xDimen,yDimen,color(0));
  veloc = new PVector(0,1);
  alternate = true;
  }
  
  void render(){
    if(alternate){
    fill(270,0,0,200);
    alternate = false;
    }else{
    fill(0,200);
    alternate = true; 
    }
    
    veloc.y += .01;
    pos.add(veloc);

    rect(pos.x,pos.y,dimen.x,dimen.y,5);
 }

}

class SizeBlock extends Block{
 
 float maxSize,minSize;
 boolean increasing;

  
  SizeBlock(float x, float y, float xDimen, float yDimen, float maxSize){
  super(x,y,xDimen,yDimen,color(random(255),random(255),random(255)));
  this.maxSize = maxSize;
  minSize = xDimen;
  increasing = true;
  }
  
  void render(){
    if(dimen.x < maxSize && increasing){
     dimen.x++;
     pos.x -= .5; 
    }else if(dimen.x > minSize && !increasing){
     dimen.x--;
     pos.x+= .5;
    }else if(dimen.x >= maxSize || dimen.x <= minSize){
      increasing = !increasing;
    }
   
    pos.add(veloc);
    fill(col,200);
    rect(pos.x,pos.y,dimen.x,dimen.y,5);
 }

}





    

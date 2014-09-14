//cursor.
 /* @pjs preload="/px/ground_red.png,/px/ground_fall.png,/px/player.png,/px/player2.png,/px/ground.png,/px/coffee.png,/px/flag.png,/px/rocket.png,/px/explode.png";  pauseOnBlur="true";  globalKeyEvents="true";*/ 
PImage p1,p2,g2,coffee,flag,rocket,gRed,gFall,explode;
PVector grav = new PVector(0,.15);
Player p;
float playerSpeed, distance, cloudSpeed, flagPos;
Platform ground;
boolean pDir, started, paused, newLevelPhase, isRocket,died;
ArrayList platforms, clouds;
PVector pDimen,translated;
PFont f;
char[] types = {'l','d','s',}; //'F' type for new level
int stamina, upgrade, maxStamina, points, maxFall, maxRise;
ArrayList rockets;
int levelPoints = 12;
PVector blockDimen = new PVector(400,300);
int flags = 0;
float rocketSpeed = 2;
int rocketChance = 7;
color bkg = color(143,188,143);
color cloudCol = color(255);
color menuCol = color(243,134,48);
color[] buildingColors = new color[] {color(59,134,134),color(11,72,107)};
color[] lavaList = new color[] {color(204,51,63),color(235,104,65)};
int rectRad = 15;

void setup(){
  size(screenWidth,screenHeight);
  noStroke();
  background(bkg);
  f = loadFont("Helvetica-30.vlw");
  p1 = loadImage("/px/player.png");
  p2 = loadImage("/px/player2.png");
  g2 = loadImage("/px/ground.png");
  coffee = loadImage("/px/coffee.png");
  flag = loadImage("/px/flag.png");
  rocket = loadImage("/px/rocket.png");
gRed = loadImage("/px/ground_red.png");
gFall = loadImage("/px/ground_fall.png");
explode = loadImage("/px/explode.png");
  pDimen = new PVector(200,30);
  p = new Player(100,100);
  playerSpeed = 4.0;
  ground = new Platform(50,height*3/4,pDimen.x,pDimen.y);
  ground.setColor(243,134,48);
	ground.type = 'g';
  ground.hit = 2;
  pDir = true;
  platforms = new ArrayList();
  for(int x=0; x<levelPoints+1; x++){
   platforms.add(new Platform(x*600+blockDimen.x+random(-100,100),random(-1*blockDimen.y,blockDimen.y),pDimen.x,pDimen.y));
   if(x==levelPoints){
   Platform temp = (Platform)platforms.get(levelPoints);
   temp.type = 'F'; 
   flagPos = temp.pos.y;
   newLevelPhase = false;
   ground.colorList = buildingColors;
   ground.type = 'g';
   }
  }
  rockets = new ArrayList();
   //Platform temp = (Platform)platforms.get(0);
   //temp.type = 'F'; 
   //flagPos = temp.pos.y;
  clouds = new ArrayList();
  cloudSpeed = .3;
  for(int x=0; x<levelPoints; x++){
   clouds.add(new Cloud(x*600+blockDimen.x+random(-100,100),random(-300,400),200+random(100),130)); 
  }
  
  distance = 0;
  stamina = maxStamina = 200;
  //loadNewGround(0.0);
  started = false;
  paused = false;
  maxFall = 6;
  maxRise = -10;
  isRocket = false;
  died = false;
  translated = new PVector(0,0);
}

void draw(){
  if(!paused && !died){
  background(bkg);
  pushMatrix();
  if(p.pos.y > height)
  restart(); 
  if(p.pos.x > width/2){
   translated.x = (p.pos.x-width/2) *-1;
  translate(translated.x,0);
  
  }
  
  
  if(p.pos.y < height*1/3){
     translated.y = (height*1/3-p.pos.y);
  translate(0,translated.y);
  
  }
  
  
  
    for(int x=0; x<clouds.size(); x++){
   Cloud temp = (Cloud)clouds.get(x);
   if(abs(temp.pos[0].x - p.pos.x) < width)
      temp.render(); 
  }
  for(int x=0; x<platforms.size(); x++){
   Platform temp = (Platform)platforms.get(x);
   if(abs(temp.pos.x - p.pos.x) < width)
    temp.render(); 
  }
	
  ground.render();
  p.render();
  if(isRocket){
    for(int x=0; x<rockets.size(); x++){
   Rocket temp = (Rocket)rockets.get(x);
  if(temp.pos.y > height)
  rockets.remove(temp);
  else if(abs(temp.pos.x - p.pos.x) < width)
  temp.render(); 
  }
  }
  popMatrix();
  }
	
	showText();
}

void keyPressed(){
  //stamina++;
  if(died){
   restart(); 
  }else{
  if(started){
    if(!paused){
 if(key == 'a' || keyCode == LEFT){
   if(stamina>0){
   stamina--;
   p.v.x = -1 * playerSpeed;
   pDir = !pDir;
   if(p.v.y > maxRise)
   p.v.y -= 2;
   }
 }
 /* if(key == ' ' || key == 'w'){

   p.v.y = -1 * playerSpeed;
   //p.onPlat = false;

 }*/
  if(key == 'd' || keyCode == RIGHT){
   if(stamina>=0){
   stamina-=2;
   p.v.x = playerSpeed;
   pDir = !pDir;
   if(p.v.y > maxRise)
   p.v.y -= 2;
   }
 }
 if(key == 'p')
   paused = true;
   
 if(key == 'o'){
   restart();
 }
    }else{
      if(newLevelPhase){
        newLevelPhase = false;
        paused = false;
        levelPoints+= 5;
        flags++;
        maxStamina -= 5;
        rocketChance++;
        rocketSpeed+= .5;
        blockDimen.add(new PVector(100,20));
        restart(); 
      }
      if(key == 'p')
      paused = false;
      
    }
  }else{
    if(p.pos.y >= ground.pos.y - p.dimen.y)
    started = true;
  
  }
}
}

void showText(){
  textFont(f,30);
  fill(255);
  
  if(died){
   fill(menuCol);
   rect(width-80,height-400,20,100);
   rect(width-130,height-450,150,70,rectRad);
   rect(width-300,height-450,200,70,rectRad);
   rect(width-365,height-300,400,300,rectRad);
   fill(255);
   //println((p.pos.x+translated.x-140) + " " + (p.pos.y+translated.y-70));
   image(explode,p.pos.x+translated.x-140,p.pos.y+translated.y-70);
   text("You died...",width-280,height-405);
   text("Press any key to try\nagain.",width-350,height-250); 
   }else{
  
  if(started && !paused){
 points = (int)(distance/10-1.9);
 //text("Distance from Start: " + points +"\nAltitude: " + (int)(height-p.pos.y)/10,width-400,30);
 //text("stamina ",10,30);
 textAlign(RIGHT);
   textFont(f,80);
 text(""+ flags*10 ,width-15,65);
   textFont(f,30);
  textAlign(LEFT);
 fill(menuCol);
 noStroke();
 rect(15,10,stamina,20,rectRad);
 fill(255);
  }
 else{
   fill(menuCol);
   noStroke();
   rect(width-365,height-300,400,300,rectRad);
   if(paused){
   rect(width-80,height-400,20,100);
   rect(width-130,height-450,150,70,rectRad);
   fill(255);
   if(!newLevelPhase)
   text("paused",width-115,height-410);
   else{
     fill(menuCol);
   rect(width-300,height-450,200,70,rectRad);
   fill(255);
   text("Level Cleared!",width-280,height-405);
   }
   }
   
   
   fill(255);
   if(!newLevelPhase && !paused)
   text("Use the arrow keys to fly!\nGet to the flag by\nlanding on platforms.\nPress any key to begin.",width-350,height-250); 
   else if(!newLevelPhase && paused)
   text("Use the arrow keys to fly!\nGet to the flag by\nlanding on platforms.\nPress 'p' to unpause.",width-350,height-250); 
   else
   text("Press any key\nto advance",width-250,height-250);    
 }
}

}

class Player{
  PVector pos;
  PVector dimen;
  PVector v;
  boolean onPlat;
  
  Player(float x, float y){
  pos = new PVector(x,y);
  v = new PVector(0.0,0.0); 
  dimen = new PVector(40.0,140.0); 
  onPlat = false;
  }
  
  boolean isBounce(Platform pl){
   if(v.y > 0 && pos.x + dimen.x >= pl.pos.x && pos.x <= pl.pos.x + pl.dimen.x
     && pos.y + dimen.y >= pl.pos.y && pos.y+dimen.y <= pl.pos.y + pl.dimen.y){
       onPlat = true;
       pl.hit++;
        //int x = (int)sqrt(sq(p.pos.x-100)+sq(p.pos.y-400));
       // if(distance < x)
        //distance = x;
        for(int x=0; x<platforms.size(); x++){
         Platform temp = (Platform)platforms.get(x);
         if(pos.x-temp.pos.x > 5000){
         platforms.remove(temp); 
       }
        }
        if(stamina <= maxStamina)
        stamina++;
        if(pl.type == 'F'){
         if(flagPos - 30 <= pl.pos.y - 80){
         paused = true;
         newLevelPhase = true;
         }
         else
         flagPos-= .5; 
        }
        if(pl.hit <2 && random(rocketChance)>5){
        isRocket = true;
        for(int x=0; x<flags; x++)
        rockets.add(new Rocket(pos.x,x+1));
        }
       return true; 
      }
      else{
        onPlat = false;
        return false;
      }
  }
  
  void correct(){
  //ground
  if(isBounce(ground)){
  v = new PVector(0,0);
  pos.y = ground.pos.y - dimen.y;  
  }
  for(int x=0; x<platforms.size(); x++){
   Platform temp = (Platform)platforms.get(x);
   if(isBounce(temp)){
  if(v.y > playerSpeed/20)
  v = new PVector(v.x/2,-1*v.y/4);
  else
  v = new PVector(0,0);
  pos.y = temp.pos.y - dimen.y; 
  switch(temp.type){
   case 'l': died = true; break;
   case 'd': temp.v.y = 2; break;
   case 's': stamina = maxStamina;
  } 
  }
  }
  }
  
  void render(){ 
    
  correct();  
  if(!onPlat){
  if(v.y < maxFall)
  v.add(grav);
  pos.add(v);  
  
  }
  else
  pos.add(v); 

  if(v.y==0 && !keyPressed)
  v = new PVector(0.0,0.0); 
  //rect(pos.x,pos.y,dimen.x,dimen.y); //testing
  if(pDir)
  image(p1, pos.x,pos.y);  
  else
  image(p2, pos.x-dimen.x/2-20,pos.y); 
  }
}

void restart(){
  died = false;
pDimen = new PVector(200,30);
 p = new Player(100,100);
 playerSpeed = 4.0;
 ground = new Platform(50,height*3/4,pDimen.x,pDimen.y);
 ground.setColor(243,134,48);
	ground.type = 'g';
 ground.hit = 2;
 pDir = true;
 platforms = new ArrayList();
 for(int x=0; x<levelPoints+1; x++){
  platforms.add(new Platform(x*600+blockDimen.x+random(-100,100),random(-1*blockDimen.y,blockDimen.y),pDimen.x,pDimen.y));
  if(x==levelPoints){
  Platform temp = (Platform)platforms.get(levelPoints);
  temp.type = 'F'; 
  flagPos = temp.pos.y;
  newLevelPhase = false;
  }
 }
 rockets = new ArrayList();
  //Platform temp = (Platform)platforms.get(0);
  //temp.type = 'F'; 
  //flagPos = temp.pos.y;
 clouds = new ArrayList();
 cloudSpeed = .3;
 for(int x=0; x<levelPoints; x++){
  clouds.add(new Cloud(x*600+blockDimen.x+random(-100,100),random(-300,400),200+random(100),130)); 
 }
 
 distance = 0;
 stamina = maxStamina = 200;
 //loadNewGround(0.0);
 started = false;
 paused = false;
 maxFall = 6;
 maxRise = -10;
 isRocket = false;
    ground.colorList = buildingColors;
   ground.type = 'g';
}

class Platform{
  PVector pos;
  PVector dimen;
  int r,g,b;
  PVector v;
  char type;
  int hit,numBricks;
  color[] colorList;
  
  Platform(float x, float y, float w, float h){
   pos = new PVector(x,y);
   dimen = new PVector(w,h);
   r = g = b = 60;
  if((int)random(3)==0) 
   type = types[(int)random(types.length)];
   else
   type = 'n';
   v = new PVector(0,0);
   hit = 0;
   numBricks = (int)(abs(pos.y-height)/pDimen.y+1);
   
   if(type == 'l'){
    colorList = lavaList; 
   }else{
    colorList = buildingColors; 
   }

  }
  
 void setColor(int r1, int g1, int b1){
 r = r1;
 g = g1; 
 b = b1; 
 }
  
  void render(){
    if(pos.y > height)
    platforms.remove(this);
    pos.add(v);
      
      
           /* boolean switcher = true;
       for(int x=0; x<numBricks; x++){
         if(switcher){
           fill(colorList[0]);
           if(type == 'd'){
             fill(colorList[0],172);
           }
         }else{
          fill( colorList[1]);
          if(type == 'd'){
            fill(colorList[1],172); 
          }
         }*

        rect(pos.x,pos.y+(x)*dimen.y+10,dimen.x,dimen.y+1);
        switcher = !switcher;
       }*/
    /*if(dimen.x > 500){
    fill(r,g,b); 
    rect(pos.x,pos.y,dimen.x,dimen.y);
    }*/
    //else{
     if(type == 'l'){ //lava
     image(gRed,pos.x,pos.y-10);

    // for(int x=0; x<
 }
     else if(type == 'd'){ //fall
     image(gFall,pos.x,pos.y-10);
}else{
	image(g2,pos.x,pos.y-10);
}
    
    if(type == 's') //coffee
     image(coffee,pos.x+10,pos.y-coffee.height+10);
    if(type == 'F'){
      stroke(0);
      strokeWeight(3);
      line(pos.x+13,pos.y-3,pos.x+13,pos.y-80);
      image(flag,pos.x+15,flagPos-30);
      strokeWeight(0);
    }
      

    
  
  }
  
}

class Cloud{
  PVector[] pos = new PVector[3];
  PVector[] dimen = new PVector[3];
  PVector v;
  
  Cloud(float x, float y, float x1, float y1){
    pos[0] = new PVector(x,y);
    pos[1] = new PVector(x+random(-1*x1/10,x1/8),y+random(-1*y1/8,y1/8));
    pos[2] = new PVector(x+random(-1*x1/10,x1/8),y+random(-1*y1/8,y1/8));
    dimen[0] = new PVector(x1,y1);
    dimen[1] = new PVector(x1,y1);
    dimen[2] = new PVector(x1,y1);
    if((int)random(2) == 0)
    v = new PVector(cloudSpeed,0);
    else v = new PVector(-1*cloudSpeed,0);
    
  }
  
  void render(){
  fill(cloudCol,20);
  noStroke();
  for(int i=0; i<3; i++){
  pos[i].add(v);
  rect(pos[i].x,pos[i].y,dimen[i].x,dimen[i].y);  
  }
  }
  
}

class Rocket{
  PVector pos;
  PVector dimen;
  PVector v;
  float speed;
  
 Rocket(float x, int seed){
  pos = new PVector(x+random(-100,100)*seed,p.pos.y-height/2);
  dimen = new PVector(rocket.width,rocket.height);
  v = new PVector(p.pos.x-pos.x+random(-100,100),p.pos.y-pos.y+random(-100,100));
  v.normalize();
  speed = rocketSpeed;
  v.mult(speed);
 }

 
 boolean isHit(){
   float x = pos.x+dimen.x/2;
   float y = pos.y+dimen.y;
   if(x>= p.pos.x && x<= p.pos.x + p.dimen.x && y<=p.pos.y+p.dimen.y && y>= p.pos.y){
    return true;
     }
    return false;
     
 }
 void render(){
 if(isHit())
   died = true;
 else{
 pos.add(v);
 image(rocket,pos.x,pos.y);
 }
 }
}

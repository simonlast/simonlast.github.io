/* @pjs pauseOnBlur="true"; globalKeyEvents="true"; */
color bkg = color(167,219,216);
color cloudCol = color(249,242,231,100);

float scaleF = 16.0;
float vScale = 30000.0;
//float msecs = 3000;
//int numAdded = 0;
boolean decel = false;

ArrayList<Cloud> clouds;

void setup(){
  size(screenWidth,screenHeight);
  background(bkg);
    //frameRate(12);
    noStroke();
    smooth();
    
    clouds = new ArrayList<Cloud>();
  
  for(int x=0; x<20; x++){
   clouds.add(new Cloud(random(width),random(height),10,-.5,.5)); 
  }
  
  
}

void draw(){
  background(bkg);
  
  
//println(clouds.size());
  for(Cloud c : clouds){
    c.render();
  }

  }
  
void mousePressed(){
  decel = false;
 for(Cloud c : clouds){
  PVector v = new PVector(c.pos.x-mouseX, c.pos.y-mouseY);
  v.normalize();
  float scaleUp = vScale/sq(dist(c.pos.x,c.pos.y,mouseX,mouseY));
  if(scaleUp > 5){
   scaleUp = 5; 
  }
  v.mult(scaleUp);
  c.v.add(v);
 } 
  
}

void mouseReleased(){
 decel = true; 
}

class Cloud{
  ArrayList<CloudFragment> frags;
  PVector pos, v;
 
  
   Cloud(float x, float y, int num, float vXMin, float vXMax){
    pos = new PVector(x,y);
   frags = new ArrayList<CloudFragment>(num); 
   v = new PVector(random(vXMin,vXMax),0);
   for(int i=0; i<num; i++){
    frags.add(new CloudFragment(random(-1.5*width/scaleF,.5*width/scaleF), random(-1.5*height/scaleF,.5*height/scaleF),
      random(width/scaleF,width/scaleF*2), random(height/scaleF,height/scaleF*2), this));
     
   }
  }
  
  void render(){
    
   if(decel){
    v.y *= .95;
    if(abs(v.x) > .5){
     v.x *= .95;
    } 
   }
   pos.add(v);
    
   for(CloudFragment c : frags){
     if(c != null)
    c.render();
  }
  
   if(pos.x < -500){
     v.x *= -1;
     pos.x += random(90,100);
   }else if(pos.x > width + 500){
    v.x *= -1; 
    pos.x -= random(90,100);
   }else if(pos.y < -500){
     v.y *= -1;
   pos.y += random(90,100);
   }
  else if(pos.y > height + 500){
    v.y *= -1;
    pos.y -= random(90,100);
   }
  
}
}

class CloudFragment{
 Cloud parent;
 PVector pos, dimen;

 CloudFragment(float x, float y, float dX, float dY, Cloud parent){
  pos = new PVector(x,y);
  dimen = new PVector(dX,dY);
  this.parent = parent;
 } 
 
 void render(){

   fill(cloudCol);
   rect(parent.pos.x + pos.x, parent.pos.y + pos.y,dimen.x,dimen.y);

   
 }
  
}

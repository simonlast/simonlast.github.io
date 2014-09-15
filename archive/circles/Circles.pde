/* @pjs pauseOnBlur="true"; globalKeyEvents="true";*/
//circle puzzle
color bkg = color(255);
float circRad;
ArrayList<Circle> circles;
int numCircles = 4;
float startRadArc;
float[] arcPositions;
Circle active;
int activeIndex;
float radsAnimated = PI/16;
boolean animating,shuffling;
boolean dir; //left = true, right = false
int maxCol = 200;
int newTime, oldTime;
float fps = 8;
float fps2 = 20;
boolean win;
int count = 0;
int fadeFps = 30;


void setup(){
 size(screenWidth,screenHeight); 
 //size(500,500);
 background(bkg);
 smooth();
 noStroke();
  win = false;
  count = 0;
 circles = new ArrayList<Circle>();
 circRad = (height-40)/numCircles;
 arcPositions = new float[numCircles];
 startRadArc = PI/numCircles/2;
 for(int x=0; x<numCircles; x++){
   arcPositions[x] = ((float)radsAnimated*((int)random(100)));
 }
 for(int x=0; x<numCircles; x++){
  Circle c = new Circle(x+1,random(maxCol),random(maxCol),random(maxCol),numCircles);
  c.shuffle();
  circles.add(c);
 }
 active = circles.get(0);
 activeIndex = 0;
 animating = false;
 
 newTime = oldTime = 0;
 shuffling = true;

}

void draw(){
  background(bkg);
  runAnim();

  for(int x=circles.size()-1; x>=0; x--){
   Circle c = circles.get(x);
   c.render(); 
  }
  
  /*
  if(win){
    float num = (fadeFps - count)/fadeFps*(255/fadeFps);
    //background(bkg,2);
  }
  */
  
}

void keyPressed(){
  if(!win && !animating){
     if(keyCode == UP){
       if(activeIndex == circles.size()-1){
         activeIndex = 0;
       }else{
         activeIndex++;
       }
      
        active = circles.get(activeIndex);
     
    }else if(keyCode == DOWN){
      if(activeIndex == 0){
       activeIndex = circles.size()-1;
       }else{
         activeIndex--;
       }
      
       active = circles.get(activeIndex);
    }else if(keyCode == LEFT){
      animating = true;
      dir = true;
      
    }else if(keyCode == RIGHT){
      animating = true;
      dir = false;
      
    }else if(key == 'r'){
     setup(); 
    }
  }
}

boolean checkForWin(){
  Circle first = circles.get(0);
  for(int x=1; x<circles.size(); x++){
    Circle c = circles.get(x);
    //System.out.println("checked");
    for(int b=0; b<numCircles; b++){
      float th1 = (first.breaks.get(b).theta1+100*PI) % (2*PI+.0001);
      float th2 = (c.breaks.get(b).theta1+100*PI) % (2*PI+.0001);
      //int intth1 = (int)th1*100000;
      //int intth2 = (int)th2*100000;
      //System.out.println(first.breaks.get(b).theta1 + "  " +  c.breaks.get(b).theta1);
      //System.out.println(intth1 + "  " +  intth2);
      if(abs(th1 - th2) > .1){
        return false;
      }
    }
  }
  return true;
}

class Circle{
  int level;
  color c;
  ArrayList<CBreak> breaks;
  float randRads;
  boolean initDir;
  int count;
 
  Circle(int level, float r,float g,float b, int numBreaks){
    breaks = new ArrayList<CBreak>();
   this.level = level;
   count = 0;
   this.c = color(r,g,b);
   for(int x=0; x<numBreaks; x++){
    float th = startRadArc;
    breaks.add(new CBreak(arcPositions[x],arcPositions[x]+startRadArc));
   }
  }
  
  void animate(float rads){
   if(!dir){ //left
    for(CBreak b : breaks){
     b.theta1 += rads;
     b.theta2 += rads; 
    }
    
   }else{ //right
       for(CBreak b : breaks){
     b.theta1 -= rads;
     b.theta2 -= rads; 
    
   } 
    
  }
  }
  
  void shuffle(){
    randRads = radsAnimated*((int)random(15));
    //Random r = new Random();
    if((int)(Math.random()*2) == 0){  
      initDir = true;
    }else{
     initDir = false; 
    }
   /* for(CBreak b : breaks){
     b.theta1 += randRads;
     b.theta2 += randRads; 
    
   } 
   */
   
  }
  
  void render(){
   if(this == active)
   fill(c); 
   else{ 
     fill(bkg);
     ellipse(width/2,height/2,circRad*level,circRad*level);
     fill(c,172);
   
   }
   ellipse(width/2,height/2,circRad*level,circRad*level);
   for(CBreak b : breaks){
    b.render(this); 
   }
  }
  
}

class CBreak{
 float theta1,theta2;

 CBreak(float theta1, float theta2){
  this.theta1 = theta1;
  this.theta2 = theta2; 
 }
 
 void render(Circle c){
  float rad = circRad*c.level;
  fill(bkg);
  arc(width/2, height/2, rad+2, rad+2, theta1, theta2);
  
 }
  
  
  
  
  
  
}
 
 
  // We must implement run, this gets triggered by start()
  void runAnim () {
    //newTime = millis() - oldTime;
    if(shuffling){
      for(Circle c: circles){
        dir = c.initDir;
      c.animate(c.randRads/fps2);
      }
      count++;
      if(count >= fps2){
        shuffling = false;
        count = 0;
        
      }
      
      
    }else if(animating){
      active.animate(radsAnimated/fps);
      count++;
      if(count == fps){
      animating = false;
      count = 0;
      }
      if(!animating){
         if(checkForWin()){
           win = true;
           count=0;
          //System.out.println(win); 
          }
      }

    
    }else if(win){
         
         if(count == fadeFps){
         numCircles++;
         if(numCircles > 30){
          numCircles = 0; 
         }
         setup(); 
         }else{
           count++;
         }
    }   
      
    }
    
    //oldTime = millis();
  

  






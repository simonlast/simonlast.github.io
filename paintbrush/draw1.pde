/* @pjs pauseOnBlur="true"; */
//Arttt
ArrayList<Brush> brushes;
//PFont f;
int numBrushes = 10;
float diff = 150;

int cMin = 150;
int cMax = 220;

float thresh = 400.0;
float rad = 25;

//bools
boolean showPoints = false;
boolean randColor = true;
boolean showControls = true;
PVector lastMouse;

float animDiff = 1.6;
//float brushDistVal = 500.0;
float comp = 2*rad; //complexity
float distThresh = rad*3; //Threshhold to add new vertices
float dampAmount = .9;
float moveThresh = rad; //distance threshhold to move vertices

float circleDrawDiff = 0;//rad/30.0;

//CONTROLS
ArrayList<PVector> colors;
color currColor = color(60);
 float rectWidth = 100.0;
 float rectHeight = 200.0;
 int minBrushWidth = 5;
 float vertexDragThresh = 10;
 BrushVertex dragged = null;
 
 PGraphics buffer;

void setup(){

  size(screenWidth,screenHeight);

  smooth();
  noStroke();


  background(255);
  brushes = new ArrayList<Brush>();
  buffer = createGraphics(width,height, P2D);


  buffer.smooth();
  buffer.noStroke();
  buffer.beginDraw();
  buffer.background(255);
  buffer.endDraw();

  lastMouse = new PVector(mouseX,mouseY);
  colors = new ArrayList<PVector>();
  colors.add(new PVector(202,237,105));
  colors.add(new PVector(242,247,229));
  colors.add(new PVector(133,224,242));
  colors.add(new PVector(54,150,169));
  colors.add(new PVector(45,100,111));
  
  colors.add(new PVector(245,38,87));
  colors.add(new PVector(255,54,87));
  colors.add(new PVector(245,233,201));
  colors.add(new PVector(220,208,175));
  colors.add(new PVector(48,9,15));
  
  colors.add(new PVector(72,150,192));
  colors.add(new PVector(72,192,110));
  colors.add(new PVector(227,236,75));
  colors.add(new PVector(238,90,146));
  colors.add(new PVector(211,80,197));
  
  colors.add(new PVector(239,206,28));
  colors.add(new PVector(239,68,28));
  colors.add(new PVector(228,205,144));
  colors.add(new PVector(206,104,64));
  colors.add(new PVector(206,174,64));
  
  showPoints = false;
  dragged = null;
  
}

void resize(float X, float  Y) {
  size((int)X,(int)Y);
}

void draw(){
   //background(255);
   
   if(dragged != null && showPoints){
      dragged.pos = new PVector(mouseX,mouseY); 
   }
   if(!mousePressed)
    image(buffer, 0,0);
   
   
    for(Brush br : brushes){
      br.render(true);
    }
   
   if(brushes.size() > 5){
        drawToBuffer();
        brushes.remove(0);;
   }


 
 if(showControls){
   //textFont(f,30);
   fill(210,172);
   rect(10,10,rectWidth,rectHeight+10);
   int row = -1;
   int col = -1;
   float yPos = 15-rectHeight/4;
   float xPos = 10;
   
   for(int i=0; i<colors.size(); i++){
     if(i%5 == 0){
       row++; 
       yPos += rectHeight/4;
       xPos = 10;
     }
     PVector p = colors.get(i);
     fill(p.x,p.y,p.z);
     rect(xPos,yPos,rectWidth/5,rectHeight/4);
     
     xPos += rectWidth/5;
     
     
   }
   fill(210);
   ellipse(10+rectWidth/2,80+rectHeight,rectWidth-10,rectWidth-10);
   fill(currColor);
    
    //stroke(210,172);
    //strokeWeight(3);
    
    ellipse(10+rectWidth/2,80+rectHeight,rad*2,rad*2);
    //noStroke();
  }
  
}

void drawToBuffer(){
  buffer.beginDraw();
  buffer.noStroke();
      brushes.get(0).renderToBuffer();
   buffer.endDraw();
}

void mousePressed(){

  //println(brushes.size());
 if(mouseX < 110 && mouseY < 210 && showControls){
   PVector mouse = new PVector(mouseX-10,mouseY-15);
   int xDiv = (int)(mouse.x/(rectWidth/5));
   int yDiv = (int)(mouse.y/(rectHeight/4));
   int pos = xDiv + yDiv*5;
   if(pos < colors.size() && pos >= 0){
     PVector p = colors.get(pos);
     currColor = color(p.x,p.y,p.z);
     randColor = false;
   }
 }else if(mouseX < 110 && mouseY > 210 && mouseY < 330 && showControls){
   float dist = sqrt(sq(10+rectWidth/2-mouseX) + sq(80+rectHeight-mouseY));
   if(dist < minBrushWidth){
     dist = minBrushWidth;
   }
   if(dist < (rectWidth-10)/2){
     rad = dist;
     comp = 2*rad;
     distThresh = rad*3;
     moveThresh = rad;
   }
 }else if(showPoints && brushes.size() > 0 && dragged == null){
    PVector mouse = new PVector(mouseX,mouseY);
      Brush b = brushes.get(brushes.size()-1);
      for(BrushVertex bv : b.vertices){
        float distanceX = abs(bv.pos.x-mouse.x);
        float distanceY = abs(bv.pos.y-mouse.y);
        if(distanceX < vertexDragThresh && distanceY < vertexDragThresh){
         dragged = bv;
         break;
        }
      }
 
 }else{
   lastMouse = new PVector(mouseX,mouseY);
    brushes.add(new Brush(mouseX,mouseY,comp));
 }

}

void mouseReleased(){
 if(showPoints && dragged != null){
  dragged = null;
 } 
 
 if(mouseX < 110 && mouseY > 210 && mouseY < 330 && showControls){
   float dist = sqrt(sq(10+rectWidth/2-mouseX) + sq(80+rectHeight-mouseY));
   if(dist < minBrushWidth){
     dist = minBrushWidth;
   }
   if(dist < (rectWidth-10)/2){
     rad = dist;
     comp = 2*rad;
     distThresh = rad*3;
     moveThresh = rad;
   }
 }
}

void keyPressed(){
  if(key == 'r'){
    setup();
  }
  else if(key == 'z' && brushes.size() > 0){
   brushes.remove(brushes.size()-1); 
  }
  else if(key == 'v'){
   showPoints = !showPoints; 
   dragged = null;
  }
  else if(key == 'c'){
   showControls = !showControls; 
  }
}

void mouseDragged(){
  if(brushes.size() > 0 && !showPoints){
   
  Brush b = brushes.get(brushes.size()-1);
  PVector mouse = new PVector(mouseX,mouseY);

  BrushVertex last = null;
  int bSize = b.vertices.size();
  for(int i=0; i<bSize; i++){
   BrushVertex v = b.vertices.get(i);
   if(last != null && PVector.dist(last.pos,v.pos) > distThresh){
     b.vertices.add(i,new BrushVertex((last.pos.x+v.pos.x)/2,(last.pos.y+v.pos.y)/2,comp));
     i++;
     bSize++;
   }
      last = v;
     
  }

  PVector dV = new PVector(mouse.x-lastMouse.x,mouse.y-lastMouse.y);

  for(BrushVertex bv : b.vertices){
    float dist = PVector.dist(bv.pos,mouse);
    if(dist < moveThresh){
       bv.v = new PVector(dV.x,dV.y);
       bv.v.mult(animDiff); 
       //bv.v.mult(1/dampAmount);
    }

  }
  
  lastMouse = mouse;
  }
}

class Brush{
 PVector center;
 ArrayList<BrushVertex> vertices;
 color c;
 
 Brush(float x, float y, float complexity){
  vertices = new ArrayList<BrushVertex>();
  center = new PVector(x,y);
  float diff = (float)(2*Math.PI/complexity);
  for( int i=0; i<complexity; i++){
    vertices.add(new BrushVertex(center.x + rad*cos(i*diff)+random(-1*circleDrawDiff,circleDrawDiff),
      center.y + rad*sin(i*diff),i*diff*random(-1*circleDrawDiff,circleDrawDiff)));
  }
  if(randColor){
  c = color(random(cMin,cMax),random(cMin,cMax),random(cMin,cMax),172);
  }else{
      c = color(currColor,172);
  }
 }
 
 void render(boolean toProcess){
  fill(c);
  if(mousePressed)
  fill(c,20);
  beginShape();
  for(BrushVertex p : vertices){
    curveVertex(p.pos.x,p.pos.y);
    if(showPoints){
      strokeWeight(3);
      stroke(0);
      point(p.pos.x,p.pos.y);
      noStroke();
    }
    if(toProcess){
      p.process(dampAmount);
    }
  }
  curveVertex(vertices.get(0).pos.x,vertices.get(0).pos.y);  
  curveVertex(vertices.get(1).pos.x,vertices.get(1).pos.y); 
  curveVertex(vertices.get(2).pos.x,vertices.get(2).pos.y);  
  endShape();

 }
 
 void renderToBuffer(){
  buffer.fill(c);
  buffer.beginShape();
  for(BrushVertex p : vertices){
    buffer.curveVertex(p.pos.x,p.pos.y);
  }
  buffer.curveVertex(vertices.get(0).pos.x,vertices.get(0).pos.y);  
  buffer.curveVertex(vertices.get(1).pos.x,vertices.get(1).pos.y); 
  buffer.curveVertex(vertices.get(2).pos.x,vertices.get(2).pos.y);  
  buffer.endShape();
 }
  
  
}

class BrushVertex{
 PVector pos,v;
 float angle;
  
 BrushVertex(float x, float y, float angle){
  pos = new PVector(x,y);
  v = new PVector();
  this.angle = angle;
 } 
  
 void process(float damp){
  v.mult(damp);
  pos.add(v); 
 }
}

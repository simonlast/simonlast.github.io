
/* @pjs preload="px/ex1.jpg";  pauseOnBlur="true";  globalKeyEvents="true";*/ 

//EDITABLE VALUES
float defaultWidth = 13; //width of the stroke in pixels
int lives = 300; //life of each stroke. Higher values will slow down the program
int opacity = 15; //opacity of each stroke from 0-255
String lnk = "px/ex1.jpg"; //The link of whatever image you want goes here


ArrayList<PStroke> strokes;
ArrayList<PStroke> toRemove;

PImage img;
color[] pix;
float scaleVal;

void setup(){
 
  smooth();
  noStroke();
  img = loadImage(lnk);
  if(img.width > img.height){
    scaleVal = screenWidth*.8/img.width;
  }else{
     scaleVal = screenHeight*.8/img.height;
  }
  //println(scaleVal);
   //size((int)(img.width*scaleVal),(int)(img.height*scaleVal));
   size(img.width,img.height);
   img.loadPixels();
  pix = img.pixels;
  

  background(255);
  strokes = new ArrayList<PStroke>();
  //generateStrokes(7,4);
  
  //image(img,0,0,width,height);
}

void changeLink(String l){
 lnk = l;
  setup(); 
}


void draw(){
  
 toRemove = new ArrayList<PStroke>();
 for(PStroke p : strokes){
   if(p.lived >= lives){
     toRemove.add(p);
   }
   p.render(); 
  }
  //System.out.println(strokes.size());
  
  for(PStroke p : toRemove){
   strokes.remove(p); 
  }

  
}

void mouseDragged(){
  if(mouseX > 0 && mouseX < width && mouseY > 0 && mouseY < height)
       strokes.add(new PStroke(mouseX/scaleVal,mouseY/scaleVal)); 
}

void keyPressed(){
  if(key == 'g')
  generateStrokes(10,8);
    if (key == ' ') {

  }
}

 ArrayList<ColorPos> getAdjacentColors(int loc, HashMap visited){
  ArrayList<ColorPos> colors = new ArrayList<ColorPos>();
  for(int y=0; y<3; y++){ 
   int pos = loc - img.width + y*img.width - 1;
   for(int x=0; x<3; x++){
     if(visited.get(pos) == null && pos >= 0 && pos < img.width*height) { 
       colors.add(new ColorPos(pix[pos],pos));
       
     }
     pos++;
   }
  }
   return colors;
  }

void generateStrokes(int d, int dev){
  for(int y=dev/d+1; y<height/d-dev/d-1; y++){
   for(int x=dev/d+1; x<img.width/d-dev/d-1; x++){
     strokes.add(new PStroke(x*d+random(-1*dev,dev),y*d+random(-1*dev,dev)));
   } 
  } 
}

class PStroke{
 PVector pos,v;
 float w;
 color c;
 HashMap visited;
 int lived;
 
  PStroke(float x, float y){
   pos = new PVector(x,y);
   v = new PVector(0,0);
   w = defaultWidth;
   int loc = (int)pos.x + (int)pos.y * img.width;
   c = pix[loc];
   lived = 0;
   visited = new HashMap();
 } 
 
 void render(){
   updateV();
   lived++;
   pos.add(v);
   fill(c,opacity);
   //fill(c);
   ellipse(pos.x,pos.y,w+random(-1*w/2,w/2),w+random(-1*w/2,w/2));
 }
 
 void updateV(){
   int loc = (int)pos.x + (int)pos.y * img.width;
   
   ArrayList<ColorPos> colors = getAdjacentColors(loc, visited);
   //System.out.println(colors.size());
   int minDiff = (int)1e10;
   ColorPos minColor = new ColorPos(c,loc);
   for(ColorPos col : colors){
    int diff = (int)(red(col.c) - red(c) + green(col.c) - green(c) + blue(col.c) - blue(c));
    if(diff < minDiff){
      minDiff = diff;
      minColor = col;
    }
   }
   c = minColor.c;
   visited.put(loc,"");
   loc = minColor.loc;
   pos = new PVector(loc % img.width ,loc / width);
   
 }
  
  
  
}

class ColorPos{
 color c;
 int loc;
 ColorPos(color c, int loc){
  this.c = (color)c;
  this. loc = loc;
 } 

  
}

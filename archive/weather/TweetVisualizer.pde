
/* @pjs pauseOnBlur="true"; globalKeyEvents="true" preload="/px/us.png,/data/file.txt"; */
//Tweet Visualizer
//const


   interface JavaScript {
       void displayInfo(float x, float y, float w, float h, String tweet);
       void clearInfo();
     }
  
   void bindJavascript(JavaScript js) {
      javascript = js;
    }
  
   JavaScript javascript;



color bkg = color(220);
PImage us;
PVector usDimen,usBegin,usCenter;
PVector latRange,lonRange;
PFont f;


float lat0;
float lon0;

//var
ArrayList<Tweet> tweets;
Tweet displayTweet;

float usWidth = 57.425537;
float usHeight = 23.160027;


void setup(){
 size(screenWidth,screenHeight);
 //size(3000,700); 
  loop();
 background(bkg);
 noStroke();
 smooth();

 us = loadImage("/px/us.png");
 lat0 = 39.833333;
 lon0 = -98.583333;
 latRange = new PVector(48.98,25.85); 
 lonRange = new PVector(-124.409866,-66.979694);
 
 imageMode(CENTER);
 f = loadFont("Helvetica-30.vlw");
 //usCenter = new PVector(width*1.9/3,height/2);
 usCenter = new PVector(width/2,height/2);
 float ratio = 1999/1232.0;
 usDimen = new PVector(width*.8,width*.8/ratio);
 usBegin = new PVector(width/2-usDimen.x/2 , height/2-usDimen.y/2);
 /*
 if(width > height){
   float h = (height*.7)/us.height;
   usDimen = new PVector(us.width*h,us.height*h);
 }else{
    float h = (width*.7)/us.width;
   usDimen = new PVector(us.width*h,us.height*h);
 }
 */

 loadTweets();
 
 for(Tweet t : tweets){
   float averageDist = 0;
  for(Tweet t2 : tweets){
    float dis = dist(t.lat,t.lon,t2.lat,t2.lon);
    averageDist += dis;
    if(dis < 300.0/tweets.size() && t.c == t2.c ){
     t.connected.add(t2); 
    }
  }
 
  averageDist /= tweets.size();
  t.rad = width/tweets.size()*3.5*(1/(t.connected.size()*4.0)+1);
  //t.rad = 30;
 }
 displayTweet = null;
 


}

void draw(){
 
 background(bkg); 
 image(us,usCenter.x,usCenter.y,usDimen.x,usDimen.y);
 displayTweet = null;
 for(Tweet t : tweets){
  t.render(); 
 }
 
 if(displayTweet != null){
   displayTweet.displayInfo(); 
 }else if(javascript != null){
  javascript.clearInfo();
 }
 /*
  if(displayTweet != null){
     displayTweet.displayInfo();  
  }
 */
  
}


void mouseMoved(){
  noLoop();
 redraw(); 
}

void mousePressed(){
	for(Tweet t : tweets){
  		if(t.isOver()){
	    displayTweet = t; 
	   }
 }
 redraw();
	
}

public void loadTweets(){
   tweets = new ArrayList<Tweet>();
//String[] file = loadStrings("http://simonlast.org/data/file.txt");
 String[] file = loadStrings("/data/file.txt");
 boolean first = true;
 for(String s : file){

   
  //println(s); 
  int index = s.indexOf(',');

  //print(type);
  if(index == -1){
   continue; 
  }
    String type = s.substring(0,index);
    
  int index2 = s.indexOf(',',index+1);
 
 // print(" " + lat);
    if(index2 == -1){
   continue; 
  }
   String lat = s.substring(index+1,index2);
  int index3 = s.indexOf(',',index2+1);

 // print(" " + lon);
    if(index3 == -1){
   continue; 
  }
    String lon = s.substring(index2+1,index3);
  String tweetText = s.substring(index3+1);
  //println(tweetText);
  //print("\n");
  
	float fLat = float(lat);
	float fLon = float(lon);
	if(fLat <= latRange.x && fLat >= latRange.y && fLon >= lonRange.x && fLon <= lonRange.y){
		tweets.add(new Tweet(type,  fLat, fLon,tweetText));
	}

  
 }

//println(tweets.size());
  
}

class Tweet{
  
 String type,tweetText;
 float lat;
 float lon;
 color c;
 PVector screenPos;
 float rad;
 
 ArrayList<Tweet> connected;
  
 Tweet(String type, float lat, float lon, String tweetText){
  this.type = type;
  this.lat = lat;
  this.lon = lon;
  this.tweetText = tweetText;
  if(type.equals("sun")){
    c = color(236,208,120);
  }else{
    c = color(78,205,196);
  }
  
  connected = new ArrayList<Tweet>();
  
   getScreenPos();
   screenPos.x *= usDimen.x*1.4;
   screenPos.y *= usDimen.y*-2;
   screenPos.x += usBegin.x+usDimen.x/2;
   screenPos.y += usBegin.y + usDimen.y;
   
  //screenPos = new PVector(0,0);
  /*screenPos = new PVector((lon-lonRange.x)*usDimen.x/(lonRange.y-lonRange.x)*1.03 + usCenter.x-usDimen.x/2 , 
	(lat-latRange.x)*usDimen.y/(latRange.y-latRange.x) + usCenter.y-usDimen.y/2); 
  if(screenPos.x - usBegin.x > usDimen.x*2.8/4 && screenPos.y -usBegin.y > usDimen.y*3/4){
   screenPos.x += usDimen.x/18.5;
   screenPos.y -= usDimen.y/20.0; 
   */
  //}//else if(screenPos.x -usBegin.x > usDimen.x*3/4 && screenPos.y -usBegin.y < usDimen.y*1/4){
	//screenPos.x -= usDimen.x/18.5;
	//}
 }
 
 void getScreenPos(){
      
     float lat0 = radians(23.0);  // Latitude_Of_Origin
    float lng0 = radians(-96.0); // Central_Meridian
    float  phi1 = radians(29.5);  // Standard_Parallel_1
    float phi2 = radians(45.5);
     float  n = 0.5 * (sin(phi1) + sin(phi2));
    float  c = cos(phi1);
     float C = c*c + 2*n*sin(phi1);
     float p0 = sqrt(C - 2*n*sin(lat0)) / n;
     
     
      float theta = n * (radians(lon) - lng0);
      float p = sqrt(C - 2*n*sin(radians(lat))) / n;
      
      screenPos = new PVector(p * sin(theta), p0 - p * cos(theta));


 }
 
 boolean isOver(){
  return (PVector.dist(screenPos,new PVector(mouseX,mouseY)) <= rad/2); 
 }
 
 void render(){
   if(isOver()){
    displayTweet = this; 
   }      
  
   stroke(c,70);
       strokeWeight(2);

      for(Tweet t : connected){

       line(t.screenPos.x,t.screenPos.y,screenPos.x,screenPos.y);
       
      }
      noStroke();
       fill(c,172-connected.size()*5.0);
       ellipse(screenPos.x,screenPos.y,rad,rad);
 }
 
 
 void displayInfo(){
   fill(c,255);

   ellipse(screenPos.x,screenPos.y,rad,rad);
   PVector boxLoc = new PVector(0,0);
   if(screenPos.x > width/2){
     boxLoc.x = screenPos.x - 350;
   }else{
      boxLoc.x = screenPos.x + 50; 
   }
   
   if(screenPos.y > height*1/3){
     boxLoc.y = screenPos.y - 200;
   }else{
    boxLoc.y = screenPos.y + 50; 
   }

	if(screenPos.y > height*4.5/6){
		boxLoc.y -= 50;
	}
  /*
   textFont(f,30);
   
   stroke(240);
   strokeWeight(3);
   line(boxLoc.x + 150, boxLoc.y + 50, screenPos.x, screenPos.y);
   noStroke();
   */
   /*
   fill(240);
   rect(boxLoc.x,boxLoc.y,300,30*tweetText.length()/(280/21)+30,15);
   
   int newLines = 0;

    fill(120);
    text(tweetText,boxLoc.x + 10,boxLoc.y+10,280,800);
    */
    if(javascript != null){
    javascript.displayInfo(boxLoc.x,boxLoc.y,width,height,displayTweet.tweetText);
    }
 }
 
 /*void print(){
  println(type + " " + lat + " " + lon); 
 }
 */
 
  
  
}

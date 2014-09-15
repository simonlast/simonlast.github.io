color bkg = color(255);
float constant = 2.0;
int numChildren = 20;
int numLines = 50;
ChildSet myChildren;
PFont f;

float width = screenWidth;
float height = screenHeight;

void setup(){
  size(width,height);
  smooth();
  background(bkg);
  // frameRate(0.5);
  myChildren = new ChildSet();
  fill(0,200);
  f = loadFont("Helvetica");
}

void draw(){
  smooth();
  background(bkg);
  myChildren = myChildren.generateNext();
  textFont(f,30);
  text("Generation: " + myChildren.generationNum,10,30);
  textFont(f,15);
  text("Press any key to reset",width-160,20);
}

void keyPressed(){
 setup();
}


class ChildSet{
 ArrayList<ChildComponentSet> children;
 int generationNum;
 float thresh;

 public ChildSet(){
  children = new ArrayList<ChildComponentSet>();
  for(int x=0; x<numChildren; x++){
    ChildComponentSet newChild = new ChildComponentSet(numLines);
    children.add(newChild);
  }

  this.thresh = width;
 }

  public ChildSet(float thresh,ChildComponentSet other,int generationNum){
  children = new ArrayList<ChildComponentSet>();
  for(int x=0; x<numChildren; x++){
    children.add(new ChildComponentSet(numLines,thresh,other));
  }
  this.thresh = thresh;
  this.generationNum = generationNum;
 }

 public ChildComponentSet getBest(){
   float maxScore =  children.get(0).getScore();
   ChildComponentSet best = children.get(0);
   for(ChildComponentSet curr : children){
     float score =  curr.getScore();
     if(score < maxScore){
       maxScore = score;
       best = curr;
     }
   }


   this.thresh = maxScore/(numLines*2)/constant;

   return best;
 }

 public ChildSet generateNext(){
   ChildComponentSet best = getBest();
   best.render(); //RENDERING
   this.generationNum += 1;
   return new ChildSet(this.thresh,best,this.generationNum);
 }

 public void render(){
  for(ChildComponentSet c : children)
   c.render();
 }


}

class ChildComponentSet{
  float score;
  ArrayList<ChildComponent> children;

  public ChildComponentSet(int childrenAmount){
    children = new ArrayList<ChildComponent>();
    for(int x=0; x<childrenAmount; x++){
     children.add(new ChildComponent());
    }
  }

  public ChildComponentSet(int childrenAmount, float thresh, ChildComponentSet other){
    children = new ArrayList<ChildComponent>();
    Iterator<ChildComponent> itr = other.children.iterator();
    while(itr.hasNext()){
      ChildComponent curr = itr.next();
      children.add(new ChildComponent(curr.pos1.x + random(-1*thresh,thresh),curr.pos1.y + random(-1*thresh,thresh),curr.pos2.x + random(-1*thresh,thresh),curr.pos2.y + random(-1*thresh,thresh)));
    }
  }

  public float getScore(){
    float score = 0;
    for(ChildComponent comp : this.children){
      for(ChildComponent comp2 : this.children){
        float angle = comp.getAngle(comp2);

        angle = abs(angle) % (float)Math.PI;
        score += angle;
      }
    }

    return score;
  }

  public void render(){
    for(ChildComponent comp : children){
     comp.render();
    }
  }

  public void printSet(){
    System.out.println(children.size());
    for(ChildComponent c : children)
      System.out.println(c.pos1.x + "  " + c.pos1.y);
 }
}

class ChildComponent{
  PVector pos1;
  PVector pos2;

  public ChildComponent(float p1x,float p1y,float p2x,float p2y){
   pos1 = new PVector(p1x,p1y);
   pos2 = new PVector(p2x,p2y);
  }

  public ChildComponent(){
   pos1 = new PVector(random(width),random(height));
   pos2 = new PVector(random(width),random(height));
  }

  public float getAngle(ChildComponent other){
   PVector thisDir = new PVector(pos2.x-pos1.x,pos2.y-pos1.y);
   PVector otherDir = new PVector(other.pos2.x-other.pos1.x,other.pos2.y-other.pos1.y);
   float angle = PVector.angleBetween(thisDir,otherDir);

   if(isNaN(angle)){
    return 0;
   }
   else {
    return angle;
   }
  }

  public int hashCode(){
     return (int)pow(pos1.x+1,pos1.y+1) + (int)pow(pos2.x+1,pos2.y+1);
  }

  public boolean equals(ChildComponent other){
    return pos1.equals(other.pos1) && pos2.equals(other.pos2);
  }

  public void render(){
   line(pos1.x,pos1.y,pos2.x,pos2.y);
  }


}

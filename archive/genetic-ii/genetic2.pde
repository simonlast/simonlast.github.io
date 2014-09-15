int numChildren = 20;
int numObjects = 100;
float initThresh = 8;
float constant = 1.0;
color bkg = color(255);
Generation myChildren;
PFont f;

float width = screenWidth;
float height = screenHeight;

void setup() {
  size(width, height);
  background(bkg);
  myChildren = new Generation();
  fill(0, 200);
  f = loadFont("Helvetica");
}

void draw() {
  smooth();
  background(bkg);
  noStroke();
  myChildren = myChildren.generateNext();
  textFont(f, 30);
  text("Generation: " + myChildren.generationNum, 10, 30);
  textFont(f, 15);
  //myChildren.children.get(0).printSet();
  text("Press any key to reset", width-160, 20);
}

void keyPressed() {
  setup();
}

class Generation {
  ArrayList<ChildComponentSet> children;
  int generationNum;
  float thresh;

  public Generation() {
    children = new ArrayList<ChildComponentSet>();
    for (int x=0; x<numChildren; x++)
      children.add(new ChildComponentSet(numObjects));
    thresh = initThresh;
  }

  public Generation(float thresh, ChildComponentSet other, int generationNum) {
    children = new ArrayList<ChildComponentSet>();
    for (int x=0; x<numChildren; x++)
      children.add(new ChildComponentSet(numObjects, thresh, other));
    this.thresh = thresh;
    this.generationNum = generationNum;
  }

  public ChildComponentSet getBest() {
    float minScore =  children.get(0).getScore();
    ChildComponentSet best = children.get(0);
    for (ChildComponentSet curr : children) {
      float score =  curr.getScore();
      if (score < minScore) {
        minScore = score;
        best = curr;
      }
    }

    thresh /= constant;

    return best;
  }

  public Generation generateNext() {
    ChildComponentSet best = getBest();
    best.render(); //RENDERING
    return new Generation(thresh, best, ++generationNum);
  }

  public void render() {
    for (ChildComponentSet c : children)
      c.render();
  }
}

class ChildComponentSet {
  float score;
  ArrayList<ChildComponent> children;

  public ChildComponentSet(int childrenAmount) {
    children = new ArrayList<ChildComponent>();
    for (int x=0; x<childrenAmount; x++) {
      children.add(new ChildComponent());
    }
  }

  public ChildComponentSet(int childrenAmount, float thresh, ChildComponentSet other) {
    children = new ArrayList<ChildComponent>();
    Iterator<ChildComponent> itr = other.children.iterator();
    while (itr.hasNext ()) {
      ChildComponent curr = itr.next();
      children.add(new ChildComponent(curr.pos.x + random(-1*thresh, thresh), curr.pos.y + random(-1*thresh, thresh), curr.r));
    }
  }

  public float getScore() {
    float score = 0;
    for (ChildComponent comp : children) {
      for (ChildComponent comp2 : children) {
        score += comp.compareTo(comp2);
      }
    }

    return score;
  }

  public void render() {
    for (ChildComponent comp : children) {
      comp.render();
    }
  }

  public void printSet() {
    System.out.println(children.size());
    for (ChildComponent c : children)
      System.out.println(c.pos.x + "  " + c.pos.y);
  }
}

class ChildComponent implements Comparable<ChildComponent> {
  PVector pos;
  float r;

  public ChildComponent(float p1x, float p1y, float r) {
    pos = new PVector(p1x, p1y);
    this.r = r;
  }

  public ChildComponent() {
    pos = new PVector(random(width), random(height));
    r = random(-50, 50);
  }

  public int compareTo(ChildComponent other) {
    int comp = 0;
    comp += abs((pos.x-other.pos.x))+abs((pos.y-other.pos.y));
    comp -= r;
    return comp;
  }

  public int hashCode() {
    return (int)pow(pos.x+1, pos.y+1) + (int)r;
  }

  public boolean equals(ChildComponent other) {
    return pos.equals(other.pos) && (r == other.r);
  }

  public void render() {

    ellipse(pos.x,pos.y,r,r);
  }
}


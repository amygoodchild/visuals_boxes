
class Box{
  
  float xrotate;
  float yrotate;
  float zrotate;
  int boxSize;
  int newSize;
  int boxStroke;
  float xChange;
  float yChange;
  float zChange;
  float boxHue;
  float hueChange;
  float x;
  float y;
  int col;
  int row;
  float newx;
  float newy;
  // quite a few variables in here that i haven't really made use of yet,
  // like the stuff relating to hue and rotation, all of these could be
  // controlled by the buttons too
  
  Box(int col_, int row_){
    xrotate = 0.5;
    yrotate = 0.5;
    zrotate = 0.5;
    boxSize = 30;
    newSize = 30;
    boxStroke = 2;
    xChange = 0.01;
    yChange = 0.01;
    zChange = 0.01;
    boxHue = 0;
    hueChange = 0.1;
    col = col_;
    row = row_;
    x = (col * widthgap) + widthgap;
    y = (row * heightgap) + heightgap;
    newx = x;
    newy = y;
  }
  
  
  void move(){
    // rotate and fade through hues all the time
    xrotate += xChange;  
    yrotate += yChange;  
    zrotate += zChange;
    boxHue += hueChange;
    
    if (boxHue >100){
      boxHue = 0;
    }
    
    // animate towards new locations - probably could have done this with vectors
    if (newx > x){
      float gap = newx - x;
      float change = gap/animSpeed;
      x+=change;
    }
    if (newx < x){
      float gap = x - newx;
      float change = gap/animSpeed;
      x-=change;
    }
    if (newy > y){
      float gap = newy - y;
      float change = gap/animSpeed;
      y+=change;
    }
    if (newy < y){
      float gap = y - newy;
      float change = gap/animSpeed;
       y-=change;
    }
    
    // animation towards a new size
    if (newSize > boxSize){
      float gap = newSize - boxSize;
      float change = gap/animSpeed;
      boxSize+=change;
    }
    if (newSize < boxSize){
      float gap = boxSize - newSize;
      float change = gap/animSpeed;
      boxSize-=change;
    }
  }
  
  // figure out new locations when the number of cols or rows changes
  void reCalcX(){
    newx = (col * widthgap) + widthgap;
  }
  
  void reCalcY(){        
    newy = (row * heightgap) + heightgap;
  }
  
  void display(){
    noFill();
    stroke(boxHue,50,100);
    strokeWeight(boxStroke);
    pushMatrix();
      translate(x, y, 50); 
      rotateY(yrotate);
      rotateX(xrotate);
      rotateZ(zrotate);
      box(boxSize);
    popMatrix();
  }
}


class Cube{
  
  PVector location;
  PVector newLocation;
  
  int col;
  int row;
  
  float size;
  float newSize;
  
  float thickness;
  float newThickness;
  
  float hue;
  float hueChange;
  float hueOffset;
  float newHueOffset;
  
  float spin;
  float spinChange;
  float spinOffset;
  float newSpinOffset;
    
  Cube(int col_, int row_){

    col = col_;
    row = row_;
    
    // Calculate location based on the given column and row of this cube
    location = new PVector((col * widthgap) + widthgap, (row * heightgap) + heightgap);
   
    newLocation = new PVector(location.x, location.y);
    
    // Default values the same for all cubes
    size = 100;
    newSize = 100;
    
    thickness = 2;
    newThickness = 2;
  
    hue = 0;
    hueChange = 0.1;
    hueOffset = 0;
    newHueOffset = 0;
  
    spin = 0.5;
    spinChange = 0.01;  
    spinOffset = 0;
    newSpinOffset = 0;
  
  }
  
  void update(){
    spin += spinChange;
    hue += hueChange;
    
    
    
    
    // Animate towards new location when the x and y value change due to number of cols/rows changing    
    PVector direction = PVector.sub(newLocation, location);
    direction = direction.div(animationSpeed);
    location = location.add(direction);

    // Animate towards new size
    float sizeGap = newSize - size;
    sizeGap = sizeGap / animationSpeed;
    size += sizeGap;
    
    // Animate towards new thickness
    float thicknessGap = newThickness - thickness;
    thicknessGap = thicknessGap / animationSpeed;
    thickness += thicknessGap;
    
    // Animate towards new spin offset
    float spinGap = newSpinOffset - spinOffset;
    spinGap = spinGap / animationSpeed;
    spinOffset += spinGap;
    
    // Animate towards new hue offset
    float hueGap = newHueOffset - hueOffset;
    hueGap = hueGap / animationSpeed;
    hueOffset += hueGap;

    
  }
  
  void display(){
    noFill();
    stroke((hue+hueOffset)%100, 100, 100);
    strokeWeight(thickness);
    
    pushMatrix();
      translate(location.x,location.y, 50);
      rotateX(spin + spinOffset);
      rotateY(spin + spinOffset);
      rotateZ(spin + spinOffset);
      box(size); 
    popMatrix();
    
  }
  
  // figure out new locations when the number of cols or rows changes
  void reCalcX(){
    newLocation.x = (col * widthgap) + widthgap;
  }
  
  void reCalcY(){        
    newLocation.y = (row * heightgap) + heightgap;
  }
 
  
}

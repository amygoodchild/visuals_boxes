/*
/ 3D cube based visuals
/
/ Variables controlled by inputs received over Serial port
/ sent by a button pad controlled by an Arduino Mega
/
/ Amy Goodchild Dec 2018
/
*/

// For serial communication
import processing.serial.*;
Serial myPort;

// Array of boxes
Box[] boxes;
int cols = 10;
int rows = 5;
int numOfBoxes = 100;  // the max number of boxes that can be displayed

// neatly arranging the boxes
int widthgap;
int heightgap;

int backgroundOpacity = 5;

// how many frames does it take to fade to the new state when changing # of cols or rows or size. 
int animSpeed = 25;

void setup() {
  frameRate(60);
  //size(1300, 800,P3D);
  fullScreen(P3D);
  
  colorMode(HSB,100);
  
  background(0);
  
  //println(Serial.list());
  // Initialising Serial connection to arduino
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 115200);

  widthgap = width/(cols+1);
  heightgap = height/(rows+1);

  
  boxes = new Box[numOfBoxes];
  
  for (int i=0; i<numOfBoxes; i++){
    int row = i/cols;
    int col = i%cols;    
    boxes[i] = new Box(col, row);
  }
}

void draw() {
  
  // draw a background (large and far away on the Z axis so it doesn't cut into the cubes unless they get stupidly huge)
  fill(0,0,0,backgroundOpacity);
  translate(-width*2, -height*2, -500); 
  rect(0,0,width*5,height*5);
  translate(width*2, height*2, 500);   
  
  for (int i=0; i<numOfBoxes; i++){
    boxes[i].move();
    if (boxes[i].col < cols && boxes[i].row < rows){  // only display the boxes that are within the number of cols and rows we want
      boxes[i].display();
    }
  }
 
  // display framerate for debugging
  fill(0,0,0);
  noStroke();
  rect(0,0,100,30);
  fill(0,0,100);
  text(frameRate,10,10);
  
}


void serialEvent (Serial myPort) {
  
  // get the byte:
  int inByte = myPort.read();
  // print it:
  println(inByte);
  
  // Change variables depending on the button pressed
  
  if (inByte==0){ 
    if(backgroundOpacity<100){
      backgroundOpacity += 1; 
      println("backgroundOpacity: " + backgroundOpacity);
    }
  }
  if (inByte==1){ 
    if(backgroundOpacity>0){
       backgroundOpacity -= 1; 
       println("backgroundOpacity: " + backgroundOpacity);
    }
  }  
    
  if (inByte==2){   
    for (int i=0; i<numOfBoxes; i++){
      boxes[i].newSize+=20;
     }
  }
  if (inByte==3){   
    for (int i=0; i<numOfBoxes; i++){
      boxes[i].newSize-=20;
     }
  }  
    
  if (inByte==6){ 
    if (cols<10){
      cols++;  
      widthgap = width/(cols+1);
      for (int i=0; i<numOfBoxes; i++){
        boxes[i].reCalcX();
      }
    }
  }
    
  if (inByte==7){ 
    if (cols>1){
      cols--;  
      widthgap = width/(cols+1);
      for (int i=0; i<numOfBoxes; i++){
        boxes[i].reCalcX();
      }
    }
  }
  
  if (inByte==4){ 
    if (rows<10){
      rows++;  
      heightgap = height/(rows+1);
      for (int i=0; i<numOfBoxes; i++){
        boxes[i].reCalcY();
      }
    }
  }
  
  if (inByte==5){ 
    if (rows>1){
      rows--;  
      heightgap = height/(rows+1);
      for (int i=0; i<numOfBoxes; i++){
        boxes[i].reCalcY();
      }
    }
  }  
  
  if (inByte==8){   
    for (int i=0; i<numOfBoxes; i++){
      boxes[i].boxStroke+=5;
     }
  }
  if (inByte==9){   
    for (int i=0; i<numOfBoxes; i++){
      if (boxes[i].boxStroke >0){
        boxes[i].boxStroke-=5;
      }
     }
  }  
 
}

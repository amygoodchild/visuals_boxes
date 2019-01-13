/*
/ 3D cube based visuals
/
/ Variables controlled by inputs received over Serial port
/ sent by a button pad controlled by an Arduino Mega
/
/ Amy Goodchild Dec 2018
/
/ Read more in my instructable 
/ https://www.instructables.com/member/amygoodchild/
/
*/

// For serial communication
import processing.serial.*;
Serial myPort;

float widthgap;
float heightgap;
int cols = 10;
int rows = 10;
int numOfCubes;
Cube[] cubes;

float backgroundOpacity = 10;
float totalSpinOffset = 0;
float totalHueOffset = 0;

// how many frames it takes for a transition to take place
int animationSpeed = 20;

void setup(){
  size(1200,800,P3D);
  colorMode(HSB, 100);
  background(0);
  
  // Initialising Serial connection to arduino
  String portName = Serial.list()[2];
  myPort = new Serial(this, portName, 115200);
  
  // Set up gap to lay out spacing between the cubes
  widthgap = width/(cols + 1);
  heightgap = height/(rows + 1);
  
  // Calculate total number of cubes from rows/cols
  numOfCubes = cols*rows;
  
  // Create an array of all the cubes
  cubes = new Cube[numOfCubes]; 
  for (int i=0; i<numOfCubes; i++){
     int row = i/cols;
     int col = i%cols;     
     cubes[i] = new Cube(col, row);     
  }
  
}


void draw(){
  
  // draw a background (large and far away on the Z axis so it doesn't cut
  // into the cubes unless they get stupidly huge)
  fill(0,0,0,backgroundOpacity);
  translate(-width*2, -height*2, -500); 
  rect(0,0,width*5,height*5);
  translate(width*2, height*2, 500);   
  
  
  // Update and draw all the cubes
  for (int i=0; i<numOfCubes; i++){
    cubes[i].update();
    if (cubes[i].row < rows && cubes[i].col < cols){
      cubes[i].display();
    }
  }
}

void serialEvent (Serial myPort) {

  // get the byte:
  int inByte = myPort.read();
    
  // Pause at the start because otherwise the setup printlns from the
  // arduino mess with the variables
  if (millis() < 4000){}
  else{
    // print it:
    println("Serial Message Received: " + inByte);
    
    // Change variables depending on the button pressed
    
    if (inByte==0){ 
      println("hi");
      if (backgroundOpacity < 1){
        backgroundOpacity += 0.1; 
      }
      else if(backgroundOpacity<10){  
        backgroundOpacity += 1; 
      }
      else if (backgroundOpacity<50){
        backgroundOpacity += 10;       
      }    
    }
    
    if (inByte==4){ 
      if(backgroundOpacity>10){
         backgroundOpacity -= 10; 
      }
      else if (backgroundOpacity > 1){
         backgroundOpacity -=1;  
      }
      else if (backgroundOpacity > 0){
         backgroundOpacity -=0.1;  
      }
    }  
      
    if (inByte==11){   
      if (cubes[1].newSize < 500){    
        for (int i=0; i<numOfCubes; i++){
          cubes[i].newSize+=30;
        }
      }
    }
    if (inByte==15){   
      if (cubes[0].newSize > 30){
        for (int i=0; i<numOfCubes; i++){
          cubes[i].newSize-=30;
        }
      }
    }  
      
    if (inByte==2){ 
      if (cols<10){
        cols++;  
        widthgap = width/(cols+1);
        for (int i=0; i<numOfCubes; i++){
          cubes[i].reCalcX();
        }
      }
    }
      
    if (inByte==6){ 
      if (cols>1){
        cols--;  
        widthgap = width/(cols+1);
        for (int i=0; i<numOfCubes; i++){
          cubes[i].reCalcX();
        }
      }
    }
    
    if (inByte==1){ 
      if (rows<10){
        rows++;  
        heightgap = height/(rows+1);
        for (int i=0; i<numOfCubes; i++){
          cubes[i].reCalcY();
        }
      }
    }
    
    if (inByte==5){ 
      if (rows>1){
        rows--;  
        heightgap = height/(rows+1);
        for (int i=0; i<numOfCubes; i++){
          cubes[i].reCalcY();
        }
      }
    }  
    
    if (inByte==3){   
      for (int i=0; i<numOfCubes; i++){
        cubes[i].newThickness+=5;
       }
    }
    
    if (inByte==7){   
      if (cubes[0].newThickness >0){
        for (int i=0; i<numOfCubes; i++){ 
          cubes[i].newThickness-=5;
        }
      }
    }
    
    if (inByte==10){
      if (cubes[0].spinChange < 0.02){
        for (int i=0; i<numOfCubes; i++){
          cubes[i].spinChange  += 0.001;
         }  
      }
      else if (cubes[0].spinChange < 0.05){
        for (int i=0; i<numOfCubes; i++){
          cubes[i].spinChange  += 0.003;
         }  
      }
      else if (cubes[0].spinChange < 0.08){
        for (int i=0; i<numOfCubes; i++){
          cubes[i].spinChange  += 0.005;
         }  
      }
    }
    
    if (inByte==14){
      if (cubes[0].spinChange > 0.05){
        for (int i=0; i<numOfCubes; i++){
          cubes[i].spinChange  -= 0.005;
         }  
      }
      else if (cubes[0].spinChange > 0.02){
        for (int i=0; i<numOfCubes; i++){
          cubes[i].spinChange  -= 0.003;
         }  
      }
      else if (cubes[0].spinChange > 0){
        for (int i=0; i<numOfCubes; i++){
          cubes[i].spinChange  -= 0.001;
         }  
      }
    } 
    
    
    if (inByte==9){
      if (totalSpinOffset < 0.5){
         totalSpinOffset += 0.01;
         for (int i=0; i<numOfCubes; i++){
           cubes[i].newSpinOffset = i*totalSpinOffset;
         }
      }
    }
    if (inByte==13){
      if (totalSpinOffset > 0){
        totalSpinOffset -= 0.01;
         for (int i=0; i<numOfCubes; i++){
           cubes[i].newSpinOffset = i*totalSpinOffset;
         }  
      }
    } 
    
    if (inByte==8){
      if (totalHueOffset < 4.5){
        totalHueOffset += 0.2;
        for (int i=0; i<numOfCubes; i++){
          cubes[i].newHueOffset = i*totalHueOffset;
        }
      }
    }
    if (inByte==12){
      if (totalHueOffset > 0){
        totalHueOffset -= 0.2;
        for (int i=0; i<numOfCubes; i++){
          cubes[i].newHueOffset = i*totalHueOffset;
        } 
      } 
    }
  }
}

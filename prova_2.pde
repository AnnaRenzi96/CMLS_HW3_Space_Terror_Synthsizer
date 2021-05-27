import controlP5.*;
import netP5.*;
import oscP5.*;
import java.util.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
ControlP5 cp5;

Knob volume_knob;
Knob freq_knob;
ScrollableList voiceType;

int[] button = new int[5];
int col=0;

PImage bg;
float volume;
float freq;

void setup(){
  size (740,460);
  noStroke();
  
  frameRate(125);
  oscP5=new OscP5(this,12000);
  myRemoteLocation=new NetAddress("127.0.0.1", 57120);
  
  bg = loadImage("space_im_2.jpg"); 
  surface.setSize(800, 450);
  surface.setResizable(true);
  background(255);
  smooth();
  
  cp5=new ControlP5(this);
  PFont font = createFont("Tahoma", 20, true); 
  cp5.setFont(font);
  
  //KNOB VOLUME 
  volume_knob=cp5.addKnob("volume")
  .setPosition(25,20)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
  
  List typeList = Arrays.asList("sound1", "sound2");
  voiceType = cp5.addScrollableList("voiceTypeDropdown")
  
             .setPosition(200,50)
             .setSize(100,500)
             .setBarHeight(50)
             .setItemHeight(70)
             .addItems(typeList)
             .setColorForeground(200)
             .setColorBackground(color(90,90,90))
             .setColorActive(color(303,50,82))
             .setColorCaptionLabel(color(237,218,218))
             .setOpen(false)
             .setValue(2)
             .setCaptionLabel("ADD");
  
  
  
//KNOB FREQ 

freq_knob=cp5.addKnob("freq")
  .setPosition(400,20)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 

  
button[0]=500;//posizione 
button[1]=20;//posizione 
button[2]=30;//size
button[3]=30;//size 
button[4]=0;
  
  
}

void draw() {
  
  bg.resize(width, height);
    
  //Set background image
  image(bg, 0, 0);

 fill(col, 102, 0);
  rect(button[0],button[1],button[2],button[3]);
  
  
  if (button[4]==1){
    rect(500,60,30,30);
  }
  
  if((mouseY<(button[1]+button[3]))&&(mouseY>(button[1]))){
  if((mouseX<(button[0]+button[2]))&&(mouseX>(button[0]))){
    col=300;
  }
  }
  OscMessage myMessage= new OscMessage("/pos");
 myMessage.add(volume_knob.getValue());
 oscP5.send(myMessage,myRemoteLocation);
 myMessage.print();
}
 
 
 
 
  
  
  
  




void mousePressed(){
  button[4]=0;
  if((mouseY<(button[1]+button[3]))&&(mouseY>(button[1]))){
  if((mouseX<(button[0]+button[2]))&&(mouseX>(button[0]))){
    button[4]=1;
    col=20;
  }
  }
}
 


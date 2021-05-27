import controlP5.*;
import netP5.*;
import oscP5.*;
import java.util.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
ControlP5 cp5;

Knob volume_knob;
ScrollableList voiceType;

PImage bg;
float volume;

void setup(){
  size (740,460);
  noStroke();
  
  frameRate(125);
  oscP5=new OscP5(this,12000);
  myRemoteLocation=new NetAddress("127.0.0.1", 57120);
  bg = loadImage("background_3.PNG"); 
  surface.setSize(800, 450);
  surface.setResizable(true);
  background(255);
  smooth();
  
  cp5=new ControlP5(this);
  PFont font = createFont("Tahoma", 20, true); 
  cp5.setFont(font);
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
  
}

void draw() {
  
    bg.resize(width, height);
    
  
  //Set background image
  image(bg, 0, 0);
  
 
}

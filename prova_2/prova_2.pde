import controlP5.*;
import netP5.*;
import oscP5.*;
import java.util.*;

OscP5 oscP5;
NetAddress myRemoteLocation;
ControlP5 cp5;



//WATER
Knob volume_knob;
Knob freq_knob;
Knob speed_knob;
Knob pan_knob;
Knob dir_knob;
//BLIPBLOP
Knob volume_knob_bb;
Knob period_knob_bb;
Knob mille_knob_bb;
Knob dir_knob_bb;
//YAW
Knob volume_knob_yaw;
Knob freq_knob_yaw;
Knob speed_knob_yaw;
Knob pan_knob_yaw;
Knob dir_knob_yaw;
//ORGANO
Knob volume_knob_org;
Knob freq_knob_org;
Knob pan_knob_org;
Knob dir_knob_org;
//TONE
Knob volume_knob_tone;
Knob freq_knob_tone;
Knob speed_knob_tone;
Knob pan_knob_tone;
Knob dir_knob_tone;
//REVERB
Knob delay_knob;
Knob decay_knob;
// Buttons
Button water_button, bb_button, yaw_button, reverb_button, org_button, tone_button;



PImage bg;
//WATER
float volume, freq, speed,pan,duration;
//BB
float period_bb,volume_bb;
float mille_bb;
float dir_bb;
//YAW
float volume_yaw,freq_yaw,speed_yaw, pan_yaw, dir_yaw;
//ORGANO
float volume_org,freq_org,speed_org,pan_org;
//TONE
float volume_tone,freq_tone,speed_tone,pan_tone, dir_tone;
//REVERB
float delay,decay;

boolean water_flag=false;
boolean bb_flag=false;
boolean yaw_flag=false;
boolean organo_flag=false;
boolean tone_flag=false;
boolean reverb_flag=false;


float indrectx=60; 
float indrecty=100;
float indknobx=indrectx+30; 
float indknoby=indrecty+100;
color all_knob=color(56,5,84);
color color_label_knob=color(220,219,255);

void setup(){
  
  noStroke();//no margin
  
  //for sc processing linking
  frameRate(125);
  oscP5=new OscP5(this, 12000);
  myRemoteLocation=new NetAddress("127.0.0.1", 57120);
  
  //for the space image
  bg = loadImage("space_im_2.jpg"); 
  surface.setSize(2000, 1800);
  surface.setResizable(true);
  background(255);
  smooth();
  
  
  PFont f; //font scritte rect
  cp5=new ControlP5(this);
  PFont font = createFont("Calibri", 14, true); // font scritte knob (20 was too big)
  cp5.setFont(font);
  
  // Buttons 
  // Water
  water_button = cp5.addButton(" ")
     .setValue(0)
     .setPosition(indrectx,indrecty)
     .setSwitch(water_flag)
     .setSize(150,60);
     
  
  // Bb
  bb_button = cp5.addButton("  ")
     .setValue(0)
     .setPosition(indrectx+300,indrecty)
     .setSwitch(bb_flag)
     .setColorActive(color(102,8,153))
     
     .setSize(150,60);
     
  // Yaw
  yaw_button = cp5.addButton("   ")
     .setValue(0)
     .setPosition(indrectx+600,indrecty)
     .setSwitch(yaw_flag)
     .setColorActive(color(102,8,153))
     .setSize(150,60); 
     
  // Organo
  org_button = cp5.addButton("        ")
     .setValue(0)
     .setPosition(indrectx+900,indrecty)
     .setSwitch(organo_flag)
     .setColorActive(color(102,8,153))
     .setSize(150,60); 
  
  // tone
  tone_button = cp5.addButton("            ")
     .setValue(0)
     .setPosition(indrectx+1200,indrecty)
     .setSwitch(tone_flag)
     .setColorActive(color(102,8,153))
     .setSize(150,60); 
  
  // Reverb
  reverb_button = cp5.addButton("                ") // these void space need to avoid button disappear
     .setValue(0)
     .setPosition(indrectx+1500,indrecty)
     .setSwitch(reverb_flag)
     .setColorActive(color(102,8,153))
     .setSize(150,60) ;
     
     
  // WATER
  // shift on y axis -> 120, 240, 360, 480
  
  //KNOB VOLUME 
 
  volume_knob=cp5.addKnob("volume")
  .setPosition(indknobx,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(0.35)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  
  .setColorCaptionLabel(color_label_knob);
  
  //speed
   freq_knob=cp5.addKnob("freq")
  .setPosition(indknobx,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
 //pan
 pan_knob=cp5.addKnob("pan")
  .setPosition(indknobx,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(-1, 1)
  .setValue(0)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  //direction
  dir_knob=cp5.addKnob("direction")
  .setPosition(indknobx,indknoby+480)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(1)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
 
  
  
//KNOB FREQ 

speed_knob=cp5.addKnob("speed")
  .setPosition(indknobx,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000) // check
  .setValue(800) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 

//BB

//volume
 volume_knob_bb=cp5.addKnob("volume_bb")
  .setPosition(indknobx+300,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
//speed
   period_knob_bb=cp5.addKnob("period_bb")
  .setPosition(indknobx+300,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
 
 mille_knob_bb=cp5.addKnob("mille_bb")
  .setPosition(indknobx+300,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  
  dir_knob_bb=cp5.addKnob("dir_bb")
  .setPosition(indknobx+300,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(1)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);


//YAW

volume_knob_yaw=cp5.addKnob("volume_yaw")
  .setPosition(indknobx+600,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(0.35)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  //speed
   speed_knob_yaw=cp5.addKnob("speed_yaw")
  .setPosition(indknobx+600,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
 //pan
 pan_knob_yaw=cp5.addKnob("pan_yaw")
  .setPosition(indknobx+600,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(-1, 1)
  .setValue(0)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  //direction
  dir_knob_yaw=cp5.addKnob("dir_yaw")
  .setPosition(indknobx+600,indknoby+480)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(1)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
 
  
  
//KNOB FREQ 

freq_knob_yaw=cp5.addKnob("freq_yaw")
  .setPosition(indknobx+600,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000) // check
  .setValue(400)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 

//ORGANO

volume_knob_org=cp5.addKnob("volume_org")
  .setPosition(indknobx+900,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(0.35)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  //dir
   dir_knob_org=cp5.addKnob("dir_org")
  .setPosition(indknobx+900,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(1)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
 //pan
 pan_knob_org=cp5.addKnob("pan_org")
  .setPosition(indknobx+900,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(-1, 1)
  .setValue(0)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  
  
//KNOB FREQ 

freq_knob_org=cp5.addKnob("freq_org")
  .setPosition(indknobx+900,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000) // check
  .setValue(400)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);


//TONE
volume_knob_tone=cp5.addKnob("volume_tone")
  .setPosition(indknobx+1200,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(0.35)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  //freq
   freq_knob_tone=cp5.addKnob("freq_tone")
  .setPosition(indknobx+1200,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000) // check
  .setValue(400)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
 //speed
 speed_knob_tone=cp5.addKnob("speed_tone")
  .setPosition(indknobx+1200,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  //pan
  pan_knob_tone=cp5.addKnob("pan_tone")
  .setPosition(indknobx+1200,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(-1, 1)
  .setValue(0)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  //pan
  dir_knob_tone=cp5.addKnob("dir_tone")
  .setPosition(indknobx+1200,indknoby+480)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0, 1)
  .setValue(1)
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
 
//REVERB

 delay_knob=cp5.addKnob("DELAY")
  .setPosition(indknobx+1500,indknoby+140)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
 .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);
  
  
  decay_knob=cp5.addKnob("DECAY")
  .setPosition(indknobx+1500,indknoby+260)
  .setRadius(30)
  .setSize(70, 50) 
  .setRange(0.01, 1) // check
  .setValue(0.35) // check
  .setColorValue(color_label_knob)
  .setColorForeground(all_knob)
  .setColorBackground(color(66,62,87))
  .setColorActive(color(102,8,153))
  .setColorCaptionLabel(color_label_knob);



    size(640, 360);
  er1 = new EggRing(width*0.1, height*0.1);
  er2 = new EggRing(width*0.4, height*0.4);
  er3 = new EggRing(width*0.7, height*0.3);
  er4 = new EggRing(width*0.5, height*0.65);
   
  

  
  // Create the font 
  printArray(PFont.list());
  f = createFont("Tahoma", 24,true);
  textFont(f);
  
  
  
 
}
// end of setup




void draw() {
  
  bg.resize(width, height);
    
  //Set background image
  image(bg, 0, 0);
  
  if (water_button.isOn()){
    water_flag=true;
     water_button.setColorBackground(color(102,8,153));
    
   }else {
      water_flag=false;
      water_button.setColorBackground(color(17,13,94));
   }
   println(water_flag);
   /*
   if(water_flag==true){
      water_button.setColorBackground(color(102,8,153));
   } else {
      water_button.setColorBackground(color(17,13,94));
   }*/
  
   
   if (bb_button.isOn()){
    bb_flag=true;
    bb_button.setColorBackground(color(102,8,153));
    
   }else {
      bb_flag=false;
      bb_button.setColorBackground(color(17,13,94));
   }
   println(bb_flag);
   
   
   
   
   
   
   if (yaw_button.isOn()){
    yaw_flag=true;
    yaw_button.setColorBackground(color(102,8,153));
    
   }else {
      yaw_flag=false;
      yaw_button.setColorBackground(color(17,13,94));
   }
   
   
   if (org_button.isOn()){
    organo_flag=true;
    org_button.setColorBackground(color(102,8,153));
    
   }else {
      organo_flag=false;
      org_button.setColorBackground(color(17,13,94));
   }
   
   
   if (tone_button.isOn()){
     tone_flag=true;
    tone_button.setColorBackground(color(102,8,153));
    
   }else {
      tone_flag=false;
      tone_button.setColorBackground(color(17,13,94));
   }
   
   if (reverb_button.isOn()){
     reverb_flag=true;
    reverb_button.setColorBackground(color(102,8,153));
    
   }else {
      reverb_flag=false;
      reverb_button.setColorBackground(color(17,13,94));
   }
   
   
   
 
   textAlign(CENTER);
  drawType(130,80);
  
  
  
   //for the rings 
  er1.transmit();
  er2.transmit();
  er3.transmit();
  er4.transmit();



 
  OscMessage myMessage = new OscMessage("/pos");
  
  // msg 1-2 Reverb 
  myMessage.add(delay_knob.getValue());
  myMessage.add(decay_knob.getValue());
  // msg 3-7 (5) Yaw
  myMessage.add(volume_knob_yaw.getValue());
  myMessage.add(freq_knob_yaw.getValue());
  myMessage.add(speed_knob_yaw.getValue());
  myMessage.add(pan_knob_yaw.getValue());
  myMessage.add(dir_knob_yaw.getValue());
  // msg 8-12 (5) Tone
  myMessage.add(volume_knob_tone.getValue());
  myMessage.add(freq_knob_tone.getValue());
  myMessage.add(speed_knob_tone.getValue());
  myMessage.add(pan_knob_tone.getValue());
  myMessage.add(dir_knob_tone.getValue());
  // msg 13-17 (5) Water
  myMessage.add(volume_knob.getValue());
  myMessage.add(freq_knob.getValue());
  myMessage.add(speed_knob.getValue());
  myMessage.add(pan_knob.getValue());
  myMessage.add(dir_knob.getValue());
  // msg 18-21 (4) Organo
  myMessage.add(volume_knob_org.getValue());
  myMessage.add(freq_knob_org.getValue());
  myMessage.add(pan_knob_org.getValue());
  myMessage.add(dir_knob_org.getValue());
  // msg 22-24 (3) BlipBlop
  myMessage.add(period_knob_bb.getValue());
  myMessage.add(mille_knob_bb.getValue());
  myMessage.add(dir_knob_org.getValue());  
  // BUTTONS
  myMessage.add(water_flag); 
  
  
   myMessage.add(bb_flag); 
  
   myMessage.add(yaw_flag); 
  
  
   myMessage.add(tone_flag); 

   myMessage.add(organo_flag); 
  
   myMessage.add(reverb_flag); 
 
  
  oscP5.send(myMessage,myRemoteLocation);
  
}
// end of draw
  

 
  
   

 

void drawType( float x, float y){
text("WATER", x,y, 95);
text("BLIPBLOP", x+300,y, 95);
text("YAW", x+600,y, 95);
text("ORGANO", x+900,y, 95);
text("TONE", x+1200,y, 95);
text("REVERB", x+1500,y, 95);
  
}
 
  EggRing er1, er2,er3,er4;






class Egg {
  float x, y; // X-coordinate, y-coordinate
  

  // Constructor
 

  

  void display() {
   
    beginShape();
    vertex(0, -100);
    bezierVertex(25, -100, 40, -65, 40, -40);
    bezierVertex(40, -15, 25, 0, 0, 0);
    bezierVertex(-25, 0, -40, -15, -40, -40);
    bezierVertex(-40, -65, -25, -100, 0, -100);
    endShape();
    popMatrix();
  }
}



class Ring {
  
  float x, y; // X-coordinate, y-coordinate
  float diameter; // Diameter of the ring
  boolean on = false; // Turns the display on and off
  float xpos=500; float ypos=500;
  void start(float xpos, float ypos) {
    x = xpos;
    y = ypos;
    on = true;
    diameter = 1;
  }
  
  void grow() {
    if (on == true) {
      diameter += 0.7;
      if (diameter > width*2) {
        diameter = 0.0;
      }
    }
  }
  
  void display() {
    if (on == true) {
      noFill();
      strokeWeight(3);
      stroke(110,148,150);
      ellipse(x, y, diameter, diameter);
    }
  }
}



class EggRing {
  
  Ring circle = new Ring();

  EggRing(float x, float y) {
   
    circle.start(x, y );
  }

  void transmit() {
   
    circle.grow();
    circle.display();
    if (circle.on == false) {
      circle.on = true;
    }
  }
}

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
//REVERB
Knob delay_knob;
Knob decay_knob;




PImage bg;
//WATER
float volume, freq, speed,pan,duration;
//BB
float period_bb;
float mille_bb;
float dir_bb;
//YAW
float volume_yaw,freq_yaw,speed_yaw, pan_yaw, dir_yaw;
//ORGANO
float volume_org,freq_org,speed_org,pan_org;
//TONE
float volume_tone,freq_tone,speed_tone,pan_tone;
//REVERB
float delay,decay;




float indrectx=60; 
float indrecty=100;
float indknobx=indrectx+30; 
float indknoby=indrecty+100;


void setup(){
  
  noStroke();//no margin
  
  //for sc processing linking
  frameRate(125);
  oscP5=new OscP5(this,12000);
  myRemoteLocation=new NetAddress("127.0.0.1", 57120);
  
  //for the space image
  bg = loadImage("space_im_2.jpg"); 
  surface.setSize(800, 450);
  surface.setResizable(true);
  background(255);
  smooth();
  
  
  PFont f; //font scritte rect
  cp5=new ControlP5(this);
  PFont font = createFont("Tahoma", 20, true); // font scritte knob
  cp5.setFont(font);
  
  
  
  
  // WATER
  
  //KNOB VOLUME 
 
  volume_knob=cp5.addKnob("volume")
  .setPosition(indknobx,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  //speed
   freq_knob=cp5.addKnob("freq")
  .setPosition(indknobx,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
 //pan
 pan_knob=cp5.addKnob("pan")
  .setPosition(indknobx,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  //duration
  dir_knob=cp5.addKnob("direction")
  .setPosition(indknobx,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
 
  
  
//KNOB FREQ 

speed_knob=cp5.addKnob("speed")
  .setPosition(indknobx,indknoby+480)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 

//BB

//speed
   period_knob_bb=cp5.addKnob("period_bb")
  .setPosition(indknobx+300,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
 
 mille_knob_bb=cp5.addKnob("mille_bb")
  .setPosition(indknobx+300,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  
  dir_knob_bb=cp5.addKnob("dir_bb")
  .setPosition(indknobx+300,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));


//YAW

volume_knob_yaw=cp5.addKnob("volume_yaw")
  .setPosition(indknobx+600,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  //speed
   speed_knob_yaw=cp5.addKnob("speed_yaw")
  .setPosition(indknobx+600,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
 //pan
 pan_knob_yaw=cp5.addKnob("pan_yaw")
  .setPosition(indknobx+600,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  //duration
  dir_knob_yaw=cp5.addKnob("dir_yaw")
  .setPosition(indknobx+600,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
 
  
  
//KNOB FREQ 

freq_knob_yaw=cp5.addKnob("freq_yaw")
  .setPosition(indknobx+600,indknoby+480)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 

//ORGANO

volume_knob_org=cp5.addKnob("volume_org")
  .setPosition(indknobx+900,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  //dir
   dir_knob_org=cp5.addKnob("dir_org")
  .setPosition(indknobx+900,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
 //pan
 pan_knob_org=cp5.addKnob("pan_org")
  .setPosition(indknobx+900,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  
  
//KNOB FREQ 

freq_knob_org=cp5.addKnob("freq_org")
  .setPosition(indknobx+900,indknoby+400)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(50, 1000)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));


//TONE
volume_knob_tone=cp5.addKnob("volume_tone")
  .setPosition(indknobx+1200,indknoby)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  //freq
   freq_knob_tone=cp5.addKnob("freq_tone")
  .setPosition(indknobx+1200,indknoby+120)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
 //speed
 speed_knob_tone=cp5.addKnob("speed_tone")
  .setPosition(indknobx+1200,indknoby+240)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  //pan
  pan_knob_tone=cp5.addKnob("pan_tone")
  .setPosition(indknobx+1200,indknoby+360)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
 
//REVERB

 delay_knob=cp5.addKnob("DELAY")
  .setPosition(indknobx+1500,indknoby+140)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));
  
  
  decay_knob=cp5.addKnob("DECAY")
  .setPosition(indknobx+1500,indknoby+260)
  .setRadius(30)
  .setSize(70, 50)
  .setRange(0.01, 1)
  .setValue(0.35)
  .setColorForeground(color(237,218,218))
  .setColorBackground(color(90,90,90))
  .setColorActive(color(303,50,82))
  .setColorCaptionLabel(color(237,218,218));



    size(640, 360);
  er1 = new EggRing(width*1, height*1);
  er2 = new EggRing(width*0.65, height*0.8);
  er3 = new EggRing(width*1.2, height*0.2);
  er4 = new EggRing(width*1.5, height*1.5);
   
  

  
  // Create the font 
  printArray(PFont.list());
  f = createFont("Tahoma", 24,true);
  textFont(f);
  
  
  
  value[0]=150;
  value[1]=150;
  value[2]=150;
  value[3]=150;
  value[4]=150;
  value[5]=150;
}


int[] value = new int[6]; 
int press;

void draw() {
  
  bg.resize(width, height);
    
  //Set background image
  image(bg, 0, 0);
  
  //for the sound button and the text
 stroke(150); 
 fill(value[0]);
rect(indrectx,indrecty, 150,60,3, 6, 12, 18);
 
 
 fill(value[1]);
rect(indrectx+300,indrecty, 150,60,3, 6, 12, 18);

fill(value[2]);
rect(indrectx+600,indrecty, 150,60,3, 6, 12, 18);
fill(value[3]);
rect(indrectx+900,indrecty, 150,60,3, 6, 12, 18);
fill(value[4]);
rect(indrectx+1200,indrecty, 150,60,3, 6, 12, 18);
fill(value[5]);
rect(indrectx+1500,indrecty, 150,60,3, 6, 12, 18);
   
   
   
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
  //myMessage.add(dir_knob_tone.getValue());
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
  
  
  
  oscP5.send(myMessage,myRemoteLocation);
  
}
 
  
 void mousePressed() {
   for(int i=0; i<=5;i++){
  if (value[i] == 150 ) {
    press=1;
    value[i]=color( 303,50,82);
    
  } else {
    press=0;
   value[i]=150;
  }
   }
 }
  
   

 

void drawType( float x, float y){
text("WATER", x,y, 95);
text("BLIPBLOP", x+300,y, 95);
text("YAW", x+600,y, 95);
text("ORGANO", x+900,y, 95);
text("TONE", x+1200,y, 95);
text("REVERB", x+1500,y, 95);
  fill(51);
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
      diameter += 0.5;
      if (diameter > width*2) {
        diameter = 0.0;
      }
    }
  }
  
  void display() {
    if (on == true) {
      noFill();
      strokeWeight(4);
      stroke(155, 153);
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

rocket roc; // main rocket object
body planet; //main planet
object bom;

long frame = 0;
float scale = 0.2; // scale for drawing everything - zoom
float msens = 0.8; // mousewheel sensitivity for zooming
final int fps = 30;
int frameskip = 1; //number of frames skipped for time warping
int predskip = 40; //number of frames skipped for predicting path
int minskip = 10;
int maxskip = 500;
boolean predictjob = false;

final float planetrad = 997100; //radius of planet 
final float planetmass = 1.400e22;  //mass of planet -prev = 0.8e22
final float gconst = 6.674e-11; // the real gravitational constant of the universe;
float thrust = 6f / fps;

PImage skybox;
PImage earf;

boolean attach = true;

void setup(){
  size(1280, 720);
  frameRate(fps);
  
  roc = new rocket(new vec(0, planetrad + 100), 1421000); //initialize rocket with mass of falcon heavy
  roc.sprdim = roc.sprdim.scaley(70.0); // give rocket a height of 70
  //roc.pos.y += roc.sprdim.y / 2; //adjust rocket pos to put gear down

  planet = new body(new vec(0, 0), planetmass);
  bom = new object(new vec(), 50000, "/res/bomb.png");
  bom.sprdim = bom.sprdim.scaley(20.0);
  skybox = loadImage("/res/skybox.png");
  earf = loadImage("res/earf.png");
}

void draw(){
  frame ++;
  background(0);
  
  image(skybox, 0, 0, width, height);
  
  translate(width / 2, height / 2); //centering view
  scale(scale, scale); //aplying zoom
  pushMatrix();
  translate(roc.pos.x, roc.pos.y);
  scale(-1, -1);
  
  if(atmdraw){ drawatm(); }
  
  if(roc.alt() > -10){ // path prediction
    if(plan(10)){
      roc.predictpath();
    }
    roc.showpath();
  }
  
  if(!attach){
  bom.render();
  ellipse(bom.pos.x, bom.pos.y, 100, 100); }
  
  //drawing planet and atmoshphere
  /*noStroke(); fill(24, 207, 181);
  ellipse(0, 0, planetrad * 2, planetrad * 2); // planet
  stroke(255);
  strokeWeight(1);
  line(0, 0, 0, planetrad);
  line(10, planetrad, 10, planetrad + 70);*/
  if(scale < 0.002){
    pushMatrix();
    translate(-planetrad, -planetrad);
    image(earf, 0,  0, planetrad * 2.006, planetrad * 2.006);
    popMatrix();
  }else{
    noStroke(); fill(132, 180, 81);
    ellipse(0, 0, planetrad * 2, planetrad * 2); // planet
    stroke(255);
    strokeWeight(1);
    line(0, 0, 0, planetrad);
    line(10, planetrad, 10, planetrad + 70);
  }
  
  
  popMatrix();
  
  //drawing rocket
  roc.render();
  if(attach){
    pushMatrix();
    rotate(roc.rotation);
    translate(0, -45);
    bom.crender();
    popMatrix();
  }
  
  textSize(12);
  fill(255);
  scale(1 / scale, 1 / scale);
  translate(-width / 2, -height / 2);
  text("height: " + int(roc.alt()) + " meter", 10, 10);
  text("speed:  " + int(roc.heading.scalemag(fps).mag()) + " m/s", 10, 28);
  text("scale: " + scale, 10, 46);
  text("predskip: " + predskip, 10, 64);
  
  gameupdate(); // physics update every frame
  
}

void detach(){
  bom.pos = new vec(roc.pos);
  vec adpos = new vec(0, roc.sprdim.y / 2 + bom.sprdim.y / 2).rotate(roc.rotation) ;
  bom.pos.add(adpos);
  bom.heading = new vec(roc.heading);
  bom.heading = bom.heading.setmag(bom.heading.mag() + 5);
  bom.rotation = new Float(roc.rotation);
  bom.rotheading = roc.rotheading;
  
  attach = false;
}

//controls and control variables
int rot = 0; //rotation status: -1: ccw, 1: cw
void keyPressed(){
  if(key == ' '){
    roc.thruston = true;
    predictjob = true;}
  else if(key == 'e'){
    rot = 1;}
  else if(key == 'a'){
    rot = -1;}
  else if(key == '7'){
    minskip += 4;}
  else if(key == '4'){
    minskip -= 4;}
  else if(key == '9'){
    maxskip += 4;}
  else if(key == '6'){
    maxskip -= 4;}
  else if(key == 'r'){
    detach();}
}

void keyReleased(){
  if(key == ' '){
    roc.thruston = false;
    roc.predictpath();
    predictjob = false;}
  else if(key == 'e' || key == 'a'){
    rot = 0;}
    
  else if(key == CODED){
    if(keyCode == RIGHT){
      frameskip *= 5;
      println(frameskip);}
    else if(keyCode == LEFT && frameskip >= 5){
      frameskip /= 5;
      println(frameskip);}
  }
}

void gameupdate(){
  if(frameskip == 1){
    roc.update();
    if(!attach){ bom.update(); }
  }else{
    roc.update(frameskip);
    if(!attach){ bom.update(frameskip); }
  }
}

boolean atmdraw = true;
void drawatm(){
  int maxh = 60000;
  int incr = 1000;
  int red = 56;
  int green = 176;
  int blue = 222;
  int skip = 1;
  if(scale < 0.002){
    skip = int( map(scale, 0.006, 3.4e-4, 3, 10) );
  }
  noFill();
  stroke(red, green, blue);
  strokeWeight((incr + 0) * skip);
  int h = 0;
  float reduct = 0.98;
  int alpha = 255;
  for(h = 0; h < maxh && blue > 2; h += incr * skip){
    ellipse(0, 0, planetrad * 2 + h + incr, planetrad * 2 + h + incr - 100);
    float sred = pow(reduct, skip);
    alpha *= sred;
    red *= sred; green *= sred; blue *= sred;
    stroke(red, green, blue, alpha);
  }
  //println("exited at " + h);
  
}

void mouseWheel(MouseEvent event) { // for zooming
  float e = event.getCount();
  if(e > 0.2){
    scale *= msens;
  }
  else if(e < 0.2){
    scale /= msens;
  }
  if(atmdraw && scale < 0.0002){
    atmdraw = false;
  }else if (scale > 0.0002){
    atmdraw = true;
  }
  if(scale < 0.003){
    predskip = int( map(scale, 0.003, 0.0001, 40, 600) );
  }else{
    predskip = 40;
  }
  //println(scale);
}

boolean plan(float time){
  if(frame % time * fps == 0){ return true; }
  return false;
}

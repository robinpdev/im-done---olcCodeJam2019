rocket roc; // main rocket object
long frame = 0;

float scale = 0.1; // scale for drawing everything - zoom
float msens = 0.8; // mousewheel sensitivity for zooming

final float planetrad = 997100; //radius of planet
final float planetmass = 0.800e22;  //mass of planet

final float gconst = 6.674e-11; // the real gravitational constant of the universe;
final int fps = 30;
int frameskip = 1;

float thrust = 0.1f;

body planet; //main planet

void setup(){
  size(1280, 720);
  frameRate(fps);
  
  roc = new rocket(new vec(0, planetrad + 100), 1421000); //initialize rocket with mass of falcon heavy
  roc.sprdim = roc.sprdim.scaley(70.0); // give rocket a height of 70
  roc.pos.y += roc.sprdim.y / 2; //adjust rocket pos to put gear down

  planet = new body(new vec(0, 0), planetmass);
}

void draw(){
  frame ++;
  background(0);
  translate(width / 2, height / 2); //centering view
  scale(scale, scale); //aplying zoom
  
  //drawing rocket
  roc.render();
  

  
  translate(roc.pos.x, roc.pos.y);
  scale(-1, -1);
  if(roc.alt() > 2){
    if(plan(5)){
      roc.predictpath();
    }
    roc.showpath();
  }
  
  //drawing planet
  noStroke(); fill(24, 207, 181);
  ellipse(0, 0, planetrad * 2, planetrad * 2);
  stroke(255);
  line(0, 0, 0, planetrad);
  
  gameupdate(); // physics update every frame
  
}

//controls and control variables
int rot = 0; //rotation status: -1: ccw, 1: cw
void keyPressed(){
  if(key == ' '){
    roc.thruston = true;}
  else if(key == 'e'){
    rot = 1;}
  else if(key == 'a'){
    rot = -1;}
}

void keyReleased(){
  if(key == ' '){
    roc.thruston = false;}
  else if(key == 'e' || key == 'a'){
    rot = 0;}
}

void gameupdate(){
  roc.update();
}

void mouseWheel(MouseEvent event) { // for zooming
  float e = event.getCount();
  if(e > 0.2){
    scale *= msens;
  }
  else if(e < 0.2){
    scale /= msens;
  }
}

boolean plan(float time){
  if(frame % time * fps == 0){ return true; }
  return false;
}

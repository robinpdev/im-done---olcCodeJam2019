rocket roc; // main rocket object

float scale = 0.4; // scale for drawing everything - zoom
float msens = 0.8; // mousewheel sensitivity for zooming

float planetrad = 750000; //radius of planet
float planetmass = 7.030e23;
                  
final float gconst = 25.67e-13; // gravitational constant;
final int fps = 30;

body planet; //main planet

void setup(){
  size(1280, 720);
  frameRate(fps);
  
  roc = new rocket(new vec(0, planetrad + 40), 1421000); //initialize rocket with mass of falcon heavy
  roc.sprdim = roc.sprdim.scaley(70.0); // give rocket a height of 70
  roc.pos.y += roc.sprdim.y / 2; //adjust rocket pos to put gear down
  
  
  planet = new body(new vec(0, 0), planetmass);
}

void draw(){
  background(0);
  translate(width / 2, height / 2); //centering view
  scale(scale, scale); //aplying zoom
  
  //drawing rocket
  roc.render();
  
  //drawing planet
  translate(roc.pos.x, roc.pos.y);
  noStroke(); fill(24, 207, 181);
  ellipse(0, 0, planetrad * 2, planetrad * 2);
  stroke(255);
  line(0, 0, 0, planetrad);
  
  gameupdate(); // physics update every frame
  
}

void gameupdate(){
  roc.update();
}

void mousePressed(){
  roc.heading.add(planet.attract(roc));
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

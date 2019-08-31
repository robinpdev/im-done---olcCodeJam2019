rocket roc; // main rocket object

float scale = 0.4; // scale for drawing everything - zoom
float msens = 0.8; // mousewheel sensitivity for zooming

float planetrad = 750000; //radius of planet
final float gconst = 6.67e-11; // gravitational constant;


void setup(){
  size(1280, 720);
  roc = new rocket(new vec(0, planetrad));
  roc.pos.y += roc.sprdim.y / 2; //adjust rocket pos to put gear down
}

void draw(){
  background(0);
  translate(width / 2, height / 2); //centering view
  scale(scale, scale); //aplying zoom
  
  //drawing rocket
  roc.render();
  stroke(255);
  ellipse(0, 0, 10, 10);
  
  //drawing planet
  translate(roc.pos.x, roc.pos.y);
  noStroke(); fill(24, 207, 181);
  ellipse(0, 0, planetrad * 2, planetrad * 2);
  stroke(255);
  line(0, 0, 0, planetrad);
  
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

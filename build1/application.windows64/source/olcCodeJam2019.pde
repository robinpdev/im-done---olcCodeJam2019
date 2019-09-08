//main game objects
rocket roc; // main rocket object
body planet; //main planet
object bom; //the bomb
ArrayList<enemy> ens; //the enemies
ArrayList<bullet> buls; //the bullets

//core variables
long frame = 0;
long prevframe = 0; //for reload timing of cannon
float scale = 0.61; // scale for drawing graphics - zoom
float msens = 0.8; // mousewheel sensitivity for zooming
final int fps = 30;
int frameskip = 1; //number of frames skipped for time warping
int predskip = 40; //number of frames skipped for predicting path
boolean predictjob = false; //is predicting path needed
boolean play = false;

//physics variables
final float planetrad = 997100; //radius of planet 
final float planetmass = 1.400e22;  //mass of planet -prev = 0.8e22
final float gconst = 6.674e-11; // the real gravitational constant of the universe;
float thrust = 6f / fps; //engine force

//assets
PImage skybox;
PImage earf; //planet
PImage tower; //launchtower
PImage bullet;
PImage enemy;
vec towerdim;
PImage gun; //moveable cannon asset
vec gundim;
PImage instructions;
vec insdim;

//gameplay variables
boolean attach = true;     //is bomb attached
boolean faring = true;     //is faring on
boolean launch = false;    //has the rocket launched yet
int health = 100;          //health of rocket
float gundir = 0;          //direction of gun
vec can;                   //postition of cannon
final int damage = 30;     //damage per enemy
final int maxt = 90 * fps; //timer length
int time = maxt;           //time left till launch
boolean zoomlock = true;   //explains itself
boolean hb = true;         //show healthbar
boolean help = false;      //show instructions

//dialog variables
String[] message = {
  "welcome to i'm done by inzywinki for olcCodeJam2019! press enter",
  "prologue: one day you get up and you decide that you are done with the world. press enter",
  "so you make yourself 3 nuclear bombs and put them in 3 powerful rockets you built from something called a space shuttle. press enter",
  "you managed to launch 2 of those bombs into orbit (green dots), but now the rest of the world heard of your plans and wants to stop you. press enter",
  "the objective is to get into a circular orbit around the planet that passes through the two blue dots in the sky",
  "enemies will be attacking you with projectiles from the sky, use the cannon to defend yourself. press enter",
  "controls: click in the direction you want to shoot to use the cannon and destroy the projectiles. press enter",
  "the lauch cycle lasts 90 seconds before liftoff, defend the rocket! press enter to start the cycle",
  "orbit does not seem to be correct, try again. press enter",
  "Ready to launch!\nRocket controls: hold Space to light engines, q to rotate left, a to rotate right.\nuse srollwheel to zoom. left and right arrows to accelerate time\nPRESS R TO RELEAST BOM WHEN IN CORRECT ORBIT\npress TAB to see more instructions",
  "the rocket was destroyed, your plan failed. press enter",
  "bomb was released succesfully, deorbiting all bombs",
  "you shouldn't be seeing this message, please report this incident to me on discor: inzywinki#8200"
};
int curmes = 0; //current message displayed
int maxl = 1; //amount of letters from message displayed, for showing text gameboy style
boolean dispm = false; //is message being diplayed
boolean nextm = false; //is next message needed?

int stage = 0; //progress of game
/*
stage 0: startup
stage 1: loaded everything
stage 2: start dialog
stage 3: rocket scene loaded
stage 4: timer started
stage 5: timer over
stage 6: game over
stage 7: launched
stage 8: faring off
stage 9: bomb deployed, game over
stage 10: bomb deployed, win
stage 11: rocket destroyed, game over
stage 12: bomb delivered correctly, end
*/

void setup(){
  size(1280, 720);
  frameRate(fps);
  
  roc = new rocket(new vec(0, planetrad + 35), 1421000); //initialize rocket with mass of falcon heavy
  roc.sprdim = roc.sprdim.scaley(70.0); // give rocket a height of 70
  roc.flamedim = roc.flamedim.scalex(roc.sprdim.x);
  //roc.pos.y += roc.sprdim.y / 2; //adjust rocket pos to put gear down

  planet = new body(new vec(0, 0), planetmass);
  bom = new object(new vec(), 50000, "/res/bombg.png");
  bom.sprdim = bom.sprdim.scaley(20.0);
  ens = new ArrayList<enemy>();
  buls = new ArrayList<bullet>();
  can = new vec(50, planetrad + 105);
  
  skybox = loadImage("/res/skybox.png");
  earf = loadImage("res/earf.png");
  tower = loadImage("/res/tower.png");
  towerdim = new vec(tower.width, tower.height).scaley(120.0);
  gun = loadImage("/res/gun.png");
  bullet = loadImage("/res/bullet.png");
  enemy = loadImage("/res/enemy.png");
  instructions = loadImage("/res/instructions.png");
  insdim = new vec(instructions.width, instructions.height).scaley(height);
  
  stage = 1;
  stage = 2;
  
  /*stage = 4;
  play = true;
  zoomlock =false;*/

}

//cutscene variables
int cstage = 0;
//int csframe = 0;
object[] boms;
body simearf;
boolean freeze = false;;

void draw(){
  frame ++;
  background(0);

  translate(width / 2, height / 2); //centering view
  
  if(stage == 2){
    dispmess();
    if(curmes == 3){
      stage = 3;
      scale = 1e-4;
      dispm = true;
    }
    return;
  }
  
  if(stage == 10){
    if(cstage == 0){
      boms = new object[3];
      for(int i = 0; i < boms.length; i ++){
        boms[i] = new object(new vec(), 10000, "/res/rbody.png");
        boms[i].pos = new vec(0, 240 + 20 * i).rotate(360 / (boms.length - 1) * i);
      }
      simearf = new body(new vec(), 10000000);
      cstage = 0;
    }else if(freeze){ delay(3000); freeze = false;}
    
    image(skybox, -width / 2, -height / 2, width, height);
    if(cstage <= 1){ image(earf, -height / 4, -height / 4, height / 2, height / 2); }
    
    noStroke();
    fill(0, 255, 0);
    for(int i = 0; i < boms.length; i ++){
      if(!boms[i].bxp){
        boms[i].heading.add(boms[i].pos.to(new vec()).scalemag(0.00005));
        boms[i].pos.add(boms[i].heading);
        ellipse(boms[i].pos.x, boms[i].pos.y, 10, 10);
        if(boms[i].pos.to(new vec()).mag() < height / 4){
          boms[i].bxp = true;
        }
      }else{
        int rad = int( pow(boms[i].bxpt, 1.5) );
        boms[i].bxpt += 1;
        if(rad <= 1280){
          fill(255, 216, 107);
        }else{
          if(cstage == 1){ cstage = 2; }
          int alpha = int( map(rad - 1280, 0, 1280, 255, 0) );
          fill(255, 216, 107, alpha);
          if(alpha <= -200){
            delay(5000);
            println("going to ending");
            stage = 12;
          }
        }
        ellipse(boms[i].pos.x, boms[i].pos.y, rad, rad);
      }
    }
    
    if(cstage == 0){
      freeze = true;
      cstage = 1;
    }
    return;
  }
  
  if(stage == 11){
    image(skybox, -width / 2, -height / 2, width, height);
    image(earf, -height / 4, -height / 4, height / 2, height / 2);
    stroke(0);
    fill(255);
    strokeWeight(2);
    textAlign(CENTER);
    textSize(32);
    text("the end. but there is another ending where you win though...\ntry again!", 0, 0);
    return;
  }
  
  if(stage == 12){
    image(skybox, -width / 2, -height / 2, width, height);
    stroke(0);
    fill(255);
    strokeWeight(2);
    textAlign(CENTER);
    textSize(32);
    text("the end.\nmade by inzywinki / rpdev for olcCodeJam2019", 0, 0);
    return;
  }
  
  image(skybox, -width / 2, -height / 2, width, height);
  
  scale(scale, scale); //aplying zoom
  pushMatrix();
  translate(roc.pos.x, roc.pos.y);
  if(curmes == 3 || curmes == 4){ translate(0, -planetrad * 2); }
  scale(-1, -1);
  
  if(atmdraw){ drawatm(); }
  
  noStroke();
  fill(0, 255, 0);
  ellipse(-planetrad - 70000, -planetrad - 70000, 10 / scale, 10 / scale); //bomb in orbit
  ellipse(planetrad + 70000, -planetrad - 70000, 10 / scale, 10 / scale); //bomb in orbit
  
  if(scale < 3.1e-4){
    fill(0, 0, 180);
    ellipse(0, planetrad + 200000, 90000, 90000);
    ellipse(0, -planetrad - 200000, 90000, 90000);
    strokeWeight(1);
  }
  else if(scale < 0.003){
    noFill();
    stroke(0, 0, 180);
    strokeWeight(3 / scale);
    ellipse(0, planetrad + 200000, 90000, 90000);
    ellipse(0, -planetrad - 200000, 90000, 90000);
    strokeWeight(1);
  }
  
  if(roc.alt() > -10){ // path prediction
    if(plan(0.5)){
      roc.predictpath();
    }
    roc.showpath();
  }
  
  if(!attach){
  bom.render();
  ellipse(bom.pos.x, bom.pos.y, 100, 100); }
  
  for(int i = 0; i < ens.size(); i ++){
    if(ens.get(i).render() == true){
      ens.remove(i);
      checkhb();
    }
  }
  for(int i = 0; i < buls.size(); i ++){
    if(buls.get(i).render() == true){
      buls.remove(i);
      checkhb();
    }
  }
  
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
  
  if(!launch && stage <= 5){
    float px = (mouseX - width / 2) / -scale;
    float py = (mouseY - height / 2) / -scale + planetrad;
    gundir = new vec(can.x, can.y).to(new vec(px, py + 20)).dir();
    if(new vec(can.x, can.y).to(new vec(px, py + 20)).x < 0){
      gundir += radians(180);
    }
    pushMatrix();
    translate(can.x, can.y);
    rotate(gundir);
    noStroke();
    fill(255);
    //rect(-20, -10, 40, 20);
    image(gun, -20, -10, 40, 20);
    popMatrix();
  }
  pushMatrix();
  translate(0, planetrad);
  scale(-1, -1);
  image(tower, -60, -115, towerdim.x, towerdim.y);
  popMatrix();
  
  popMatrix();


  textSize(12);
  fill(255);
  scale(1 / scale, 1 / scale);
  translate(-width / 2, -height / 2);
  text("height: " + int(roc.alt()) + " meter", 10, 10);
  text("speed:  " + int(roc.heading.scalemag(fps).mag()) + " m/s", 10, 28);
  text("scale: " + scale, 10, 46);
  //text("predskip: " + predskip, 10, 64);
  //text("gundir: " + degrees(gundir), 10, 82);
  
  //healthbar
  stroke(0);
  noFill();
  strokeWeight(1);
  if(hb){
    rect(1000, 20, 250, 30);
    fill(0, 255, 0);
    rect(1000, 20, int(map(health, 0, 100, 0, 250)), 30);
  }
  //timer
  if(stage == 4){ 
    noFill();
    rect(1000, 60, 250, 30);
    fill(0, 0, 255);
    rect(1000, 60, int(map(time, 0, maxt, 0, 250)), 30);
  }
  
  if(help){
    image(instructions, width - insdim.x, 0, insdim.x, insdim.y);
  }
  
  if(dispm){
    pushMatrix();
    translate(width / 2, height / 2);
    dispmess();
    popMatrix();
    if(curmes < 5){ return; }
    //println("continueing");
    if(curmes == 5){
      scale = 0.61;
    }else if(curmes == 8 && stage <= 3){
      play = true;
      stage = 4;
      dispm = false;
    }else if(curmes == 9 && stage <= 4){
      play = true;
      dispm = false;
    }
    if(curmes == 10 && stage != 6){
      play = true;
      dispm = false;
    }
    if(curmes == 11 && stage == 6){
      stage = 11;
    }else if(curmes == 12 && stage == 7){
      stage =10;
    }
    else if(curmes == 11 && stage <= 6){
      play = true;
      dispm = false;
    }
  }
  
  //drawing rocket
  translate(width / 2, height / 2);
  roc.render();
  
  if(play){ gameupdate(); } // physics and timing update every frame when not paused
  
}

void gameupdate(){
  if(frameskip == 1){
    if(stage >= 7){
      roc.update();
      if(!attach){ bom.update(); }
      if(plan(1) && faring && roc.alt() > 30000){ //detach faring if above atm
        roc.sprite = loadImage("/res/rbodyg_nof.png");
        faring = false;
      }
    }
    
    if(stage == 4){
      if(time > 0){
        time -= 1;
      }else{
        println("timer over");
        stage = 5;
        dispm = true;
        curmes = 9;
        play = false;
        zoomlock = false;
      }
    }
    
    for(int i = 0; i < ens.size(); i ++){
      ens.get(i).update();
    }
    for(int i = 0; i < buls.size(); i ++){
      buls.get(i).update();
    }
    if(plan(0.5) && hb){
      for(int i = 0; i < ens.size(); i ++){
        String result = ens.get(i).check();
        if(result == "hit" && hb){
          health -= damage;
          if(health <= 0){
            stage = 6;
            dispm = true;
            curmes = 10;
          }
        }
      }
      for(int i = 0; i < buls.size(); i ++){
        String result = buls.get(i).check();
        if(result == "hit"){
          
        }
      }
      if(stage <= 4 && plan(1) && roc.alt() < 10000){
        spawnens();
      }
    }
  }else{
    roc.update(frameskip);
    if(!attach){ bom.update(frameskip); }
  }
}

boolean checkorbit(){
  predskip = 600;
  roc.predictpath();
  boolean p1 = false;
  boolean p2 = false;
  for(int i = 0; i < roc.path.size(); i += 1){
    vec p = roc.path.get(i);
    if(p.to(new vec(0, planetrad + 200000)).mag() < 45000){
      p1 = true;
    }else if(p.to(new vec(0, -planetrad - 200000)).mag() < 45000){
      p2 = true;
    }
  }
  println(p1);
  println(p2);
  println(p1 && p2);
  println();
  
  return p1 && p2;
}

void detach(){
  checkorbit(); //DELETE later, for debugging
  if(attach && checkorbit()){
  bom.pos = new vec(roc.pos);
  bom.pos.add(new vec(0, 20).rotate(roc.rotation));
  bom.heading = new vec(roc.heading);
  bom.heading.add(new vec(0, 2).rotate(roc.rotation));
  bom.rotation = new Float(roc.rotation);
  bom.rotheading = roc.rotheading;
  roc.sprite = loadImage("/res/rbodyg_nob.png");
  
  dispm = true;
  curmes = 11;
  attach = false;
  }else{
    dispm = true;
    play = false;
    curmes = 8;
  }
}

//controls and control variables
int rot = 0; //rotation status: -1: ccw, 1: cw
void keyPressed(){
  if(key == ' ' && stage >= 5 && stage != 6){
    if(stage == 5){
      stage = 7;
      tower = loadImage("/res/towergun.png");
    }
    roc.thruston = true;
    checkhb();
    predictjob = true;}
  else if(key == 'e' && stage >= 7){
    rot = 1;}
  else if(key == 'q' && stage >= 7){
    rot = -1;}
  else if(key == 'r' && stage >= 7){
    detach();}
  else if(key == 'p' && stage >= 3){
    play = !play;}
  else if(key == '9'){
    stage = 7;
    roc.pos = new vec(0, planetrad + 200000);
    roc.heading = new vec(-4888 / fps, 0);
  }
  else if(keyCode == TAB){
    help = !help;}
  else if((keyCode == ENTER || keyCode == RETURN)){
    if(dispm){
      nextm = true;
    }else if(stage == 3){
      println("timer started");
      stage = 4;
    }
  }
}

void keyReleased(){
  if(key == ' '){
    roc.thruston = false;
    roc.predictpath();
    predictjob = false;}
  else if(key == 'e' || key == 'q'){
    rot = 0;}

  else if(key == CODED){
    if(keyCode == RIGHT && frameskip < 625){
      frameskip *= 5;
      println(frameskip);}
    else if(keyCode == LEFT && frameskip >= 5){
      frameskip /= 5;
      println(frameskip);}
    
  }
}

void spawnens(){
  if(true && ens.size() < 4){
    ens.add(new enemy());
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

void mousePressed(){
  if(!launch && stage >= 4 && stage <= 5 && frame - prevframe >= 20){
    buls.add(new bullet(can, gundir));
    prevframe = frame;
  }
}

void mouseWheel(MouseEvent event) { // for zooming
  if(!zoomlock){
    float e = event.getCount();
    if(e > 0.2){                                     
      scale *= msens;
    }
    else if(e < 0.2){                                      
      if(scale < 3.5){ scale /= msens; }
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
  }
  //println(scale);
}

void dispmess(){
  dispm = true;
  if(nextm){
    if(curmes < message.length - 1){ curmes ++; }
    else{ dispm = false; }
    maxl = 0;
    nextm = false;
  }
  stroke(255);
  fill(0);
  //noFill();
  rect(-width / 2 + 10, height / 2 - 10, width - 20, -300);
  textSize(32);
  fill(255);
  text(message[curmes].substring(0, maxl), -width / 2 + 20, height / 2 - 280, width - 40, 240);
  if(maxl < message[curmes].length()){ maxl ++; }
  delay(5);
}

void checkhb(){
  if(stage >= 7 && ens.size() == 0){
    hb = false;
  }
}

boolean plan(float time){
  if(frame % (time * fps) == 0){ return true; }
  return false;
}

boolean chance(int c){
  if(int(random(1, c)) == 2){ return true; }
  return false;
}

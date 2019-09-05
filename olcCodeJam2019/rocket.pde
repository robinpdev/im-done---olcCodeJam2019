

class rocket{
  vec pos;
  vec heading;
  float mass;
  float rotation;
  float rotheading;
  boolean thruston = false;
  
  PImage sprite;
  vec sprdim;
  
  ArrayList<vec> path = null;
  
  public rocket(vec mpos, float mmass){
    pos = mpos;
    heading = new vec();
    sprite = loadImage("/res/rbodyg.png");
    sprdim = new vec(sprite.width, sprite.height);
    mass = mmass;
    rotation = 0f;
    rotheading = 0f;
  }
  
  void update(){
    //rotation
    if(rot == -1){ rotheading -= radians(0.06); }
    else if(rot == 1){ rotheading += radians(0.06); }
    else{
      if(rotheading < radians(-0.14)){ rotheading += radians(0.06); }
      else if(rotheading > radians(0.14)){ rotheading += radians(-0.06); }
      else{ rotheading = 0; }
    }
    rotation += rotheading;
    
    //gravity of planet
    heading.add(planet.attract(this));
    
    //thrust
    if(thruston){
      float force = thrust;
      vec effect = new vec(0, force).rotate(rotation);
      heading.add(effect);
    }
    
    // to not fall through planet
    if(pos.mag() > planetrad + 35 || (thruston && new vec(pos).addv(heading).mag() > pos.mag())){
      pos.add(heading);
    }else{
      heading = new vec(0, 0);
    }
  }
  
  void update(int skip){
    //gravity of planet
    heading.add(planet.attract(this).scalemag(skip));
    
    // to not fall through planet
    if(pos.mag() > planetrad + 34){ 
      pos.add(heading.scalemag(skip));
    }else{
      heading = new vec(0, 0);
    }
  }
  
  void prender(){
    image(sprite, pos.x, pos.y);
  }
  void render(){
    if(scale > 0.1){
      pushMatrix();
        rotate(rotation);
        translate(-sprdim.x / 2 , -sprdim.y / 2);
        image(sprite, 0, 0, sprdim.x, sprdim.y);
      popMatrix();
    }else{
      pushMatrix();
      scale(1 / scale, 1 / scale);
      fill(255);
      noStroke();
      ellipse(0, 0, 10, 10);
      popMatrix();
    }
  }
  
  void predictpath(){
    path = new ArrayList<vec>();
    simrocket simroc = new simrocket(this);
    boolean done = false;
    for(int i = 0; i < 100 && !done; i ++){
      done = simroc.update(predskip);
      path.add(new vec(simroc.pos));
      
    }
    //println(path.size());
  }
  
  void showpath(){
    if(path != null){
      noFill();
      stroke(255, 0, 0);
      strokeWeight(1 / scale);
      beginShape();
      vertex(pos.x, pos.y);
      for(int i = 0; i < path.size(); i ++){ 
        vec p = path.get(i);
        vertex(p.x, p.y);
        //ellipse(p.x, p.y, 10, 10);
      }
      endShape();
    }
  }
  
  float alt(){
    return pos.mag() - planetrad - (sprdim.y / 2);
  }
  
}

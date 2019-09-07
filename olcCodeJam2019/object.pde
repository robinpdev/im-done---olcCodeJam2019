



class object{
  vec pos;
  vec heading;
  float mass;
  float rotation;
  float rotheading;

  PImage sprite;
  vec sprdim;
  
  ArrayList<vec> path = null;
  
  public object(vec mpos, float mmass, String res){
    pos = mpos;
    heading = new vec();
    sprite = loadImage(res);
    sprdim = new vec(sprite.width, sprite.height);
    mass = mmass;
    rotation = 0f;
    rotheading = 0f;
  }
  
  void update(){
    //rotation
    /*if(rot == -1){ rotheading -= radians(0.06); }
    else if(rot == 1){ rotheading += radians(0.06); }
    else{
      if(rotheading < radians(-0.14)){ rotheading += radians(0.06); }
      else if(rotheading > radians(0.14)){ rotheading += radians(-0.06); }
      else{ rotheading = 0; }
    }*/
    rotation += rotheading;
    
    //gravity of planet
    heading.add(planet.attract(this));
    
    // to not fall through planet
    if(pos.mag() > planetrad + 34){ 
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
  
  void render(){
    if(scale > 0.1){
      pushMatrix();
        translate(pos.x, pos.y);
        scale(-1,-1);
        rotate(rotation);
        translate(-sprdim.x / 2 , -sprdim.y / 2);  
        image(sprite, 0, 0, sprdim.x, sprdim.y);
      popMatrix();
    }else{
      fill(255, 0, 0);
      noStroke();
      ellipse(pos.x, pos.y, 10 / scale, 10 / scale);
    }
  }
  void crender(){
    if(scale > 0.1){
      pushMatrix();
        rotate(rotation);
        translate(-sprdim.x / 2 , -sprdim.y / 2);
        image(sprite, 0, 0, sprdim.x, sprdim.y);
      popMatrix();
    }
  }
  
  float alt(){
    return pos.mag() - planetrad - (sprdim.y / 2);
  }
  
}

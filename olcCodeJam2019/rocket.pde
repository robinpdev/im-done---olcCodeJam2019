

class rocket{
  vec pos;
  vec heading;
  float mass;
  
  PImage sprite;
  vec sprdim;
  
  public rocket(vec mpos, float mmass){
    pos = mpos;
    heading = new vec();
    sprite = loadImage("/res/rbody.png");
    sprdim = new vec(sprite.width, sprite.height);
    mass = mmass;
  }
  
  void update(){
    //println(planet.attract(this).mag());
    heading.add(planet.attract(this));
    pos.add(heading);
  }
  
  void prender(){
    image(sprite, pos.x, pos.y);
  }
  void render(){
    pushMatrix();
      translate(-sprdim.x / 2 , -sprdim.y / 2);
      image(sprite, 0, 0, sprdim.x, sprdim.y);
    popMatrix();
  }
  
  
  
}

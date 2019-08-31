

class simrocket{
  vec pos;
  vec heading;
  float mass;
  
  public simrocket(rocket old){
    pos = new vec(old.pos);
    heading = new vec(old.heading);
    mass = new java.lang.Float(old.mass);
  }
  
  void update(float skip){

    //gravity of planet
    heading.add(planet.attract(this, skip).scalemag(skip));
    
    // to not fall through planet
    if(pos.mag() > planetrad + 34){ 
      pos.add(heading.scalemag(skip));
    }else{
      heading = new vec(0, 0);
    }
  }
}

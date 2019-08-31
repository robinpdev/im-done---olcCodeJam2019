

class body{ //class for planets
  vec pos;
  float mass;
  
  public body(vec mpos, float mmass){
    pos = mpos;
    mass = mmass;
  }
  
  vec attract(rocket obj){ // returns vector in direction of planet from object with magnitude of gravity
    vec dir = obj.pos.to(this.pos);
    final float mag = gconst * mass * obj.mass / pos.distto(obj.pos);
    dir.setmag(mag);
    return dir;
  }
  
}



class body{ //class for planets
  vec pos;
  float mass;
  
  public body(vec mpos, float mmass){
    pos = mpos;
    mass = mmass;
  }
  
  vec attract(rocket obj){ // returns vector in direction of planet from object with magnitude of gravity
    vec dir = obj.pos.to(this.pos);
    float mag = gconst * ((mass * obj.mass) / pow(pos.distto(obj.pos), 2));
    mag /= obj.mass;
    mag /= fps;
    dir = dir.setmag(mag);
    return dir;
  }
  
  vec attract(object obj){ // returns vector in direction of planet from object with magnitude of gravity
    vec dir = obj.pos.to(this.pos);
    float mag = gconst * ((mass * obj.mass) / pow(pos.distto(obj.pos), 2));
    mag /= obj.mass;
    mag /= fps;
    dir = dir.setmag(mag);
    return dir;
  }
  
  vec attract(simrocket obj, float skip){ // returns vector in direction of planet from object with magnitude of gravity
    vec dir = obj.pos.to(this.pos);
    float mag = gconst * ((mass * obj.mass) / pow(pos.distto(obj.pos), 2));
    mag /= obj.mass;
    mag /= fps;
    dir = dir.setmag(mag);
    return dir;
  }
  
}

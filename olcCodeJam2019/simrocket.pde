

public class simrocket{ //simulated object for predicting path
  vec pos;
  vec heading;
  float mass;
  
  public simrocket(rocket old){
    pos = new vec(old.pos);
    heading = new vec(old.heading);
    mass = new java.lang.Float(old.mass);
  }
  
  public boolean update(float skip){

    //gravity of planet
    this.heading.add(planet.attract(this, skip).scalemag(skip));
    
    // to not fall through planet
    if(this.pos.mag() > planetrad + 34){ 
      this.pos.add(this.heading.scalemag(skip));
      return false;
    }else{return true; }

  }
}

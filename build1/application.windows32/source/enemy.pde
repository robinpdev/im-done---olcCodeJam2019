
class enemy{
  vec pos;
  vec heading;
  float rotation = 0;
  
  boolean exp = false;
  int ext = 1;
  
  vec sprdim;
  
  
  public enemy(){
    int x = 700;
    if(chance(3)){ x = -700; rotation += radians(180);}
    pos = roc.pos.addv(new vec(x, 0 + int( random(0, 700) )));
    heading = pos.to(roc.pos).setmag(2).addv(new vec(random(-0.25, 0.25), random(-0.25, 0.25)));
    rotation += heading.dir() + degrees(90);
    
    sprdim = new vec(enemy.width, enemy.height);
    sprdim = sprdim.scaley(50);
  }
  
  public void update(){
    if(!exp){
      pos.add(heading);
    }
  }
  
  boolean render(){
    if(scale > 0.1){
      pushMatrix();
        translate(pos.x, pos.y);
        //scale(-1,-1);
        rotate(rotation);
        fill(255);
        noStroke();
        if(exp){
          int exrad = int( pow(ext, 2) );
          fill(252, 168, 3);
          ellipse(0, 0, exrad * 2, exrad * 2);
          ext += 1;
          if(exrad > 60){ popMatrix(); return true; }
          popMatrix();
          return false;
        }
        //rect(-10, -20, 20, 40);
        translate(-sprdim.x / 2 , -sprdim.y / 2);  
        image(enemy, 0, 0, sprdim.x, sprdim.y);
      popMatrix();
    }else{
      fill(255, 0, 0);
      noStroke();
      ellipse(pos.x, pos.y, 10 / scale, 10 / scale);
      if(exp){
        return true;
      }
    }
    return false;
  }
  
  String check(){
    if (pos.to(roc.pos).mag() < 50){
      println("hit");
      exp = true;
      return "hit"; // enemy hit rocket
    }else if(pos.mag() < planetrad){ 
      println("crash");
      exp = true;
      return "crash"; // enemy hit the ground
    }else if(pos.to(roc.pos).mag() >1200){
      exp = true;
      println("far");
      return "far"; // enemy is too far, delete it
    }else{
      return "ok"; // enemy is on track
    }
  }
  
}


class bullet{
  vec pos;
  vec heading;
  float rotation;
  boolean exp;
  int ext = 1;
  
  PImage sprite;
  vec sprdim;
  
  public bullet(vec mpos, float mrotation){
    pos = new vec(mpos);
    rotation = new Float(mrotation);
    heading = new vec(5, 0).rotate(rotation);
    rotation += radians(90);

    sprdim = new vec(bullet.width, bullet.height);
    sprdim = sprdim.scaley(50);
  }
  
  public void update(){
    if(!exp){
      pos.add(heading);
    }
  }
  
  boolean render(){
    if(scale > 0.1){
      pushMatrix();
        translate(pos.x, pos.y);
        //scale(-1,-1);
        rotate(rotation);
        fill(0, 0, 255);
        noStroke();
        if(exp){
          int exrad = int( pow(ext, 2) );
          fill(252, 168, 3);
          ellipse(0, 0, exrad * 2, exrad * 2);
          ext += 1;
          if(exrad > 60){ popMatrix(); return true; }
          popMatrix();
          return false;
        }
        //rect(-6, -20, 12, 40);
        translate(-sprdim.x / 2 , -sprdim.y / 2);  
        image(bullet, 0, 0, sprdim.x, sprdim.y);
      popMatrix();
    }else{
      fill(255, 0, 0);
      noStroke();
      ellipse(pos.x, pos.y, 10 / scale, 10 / scale);
      if(exp){
        return true;
      }
    }
    return false;
  }
  
  String check(){
    for(int i = 0; i < ens.size(); i ++){
      enemy en = ens.get(i);
      if(pos.to(en.pos).mag() < 60){
        exp = true;
        ens.remove(i);
        checkhb();
        return "hit";
      }
    }
    if(pos.mag() < planetrad){ 
      println("crash");
      exp = true;
      return "crash"; // enemy hit the ground
    }else if(pos.to(roc.pos).mag() >1200){
      exp = true;
      println("far");
      return "far"; // enemy is too far, delete it
    }else{
      return "ok"; // enemy is on track
    }
  }
  
}

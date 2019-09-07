

class vec{
  
  float x, y;
  
  public vec(float mx, float my){
    x = mx; y = my;
  }
  public vec(vec mvec){
    x = mvec.x;
    y = mvec.y;
  }
  public vec(){
    x = 0.0f;
    y = 0.0f;
  }
  
  void add(vec input){
    x += input.x;
    y += input.y;
  }
  
  vec addv(vec input){
    vec out = new vec(this);
    out.x += input.x;
    out.y += input.y;
    return out;
  }

  
  vec to(vec input){
    return new vec(input.x - x, input.y - y);
  }
  
  float distto(vec input){
    return sqrt( pow(x - input.x, 2) + pow(y - input.y, 2) );
  }
  
  float mag(){
    return sqrt(x * x + y * y);
  }
  
  vec setmag(float mag){
    return new vec(x / this.mag() * mag, y / this.mag() * mag);
  }
  
  vec scaley(float dy){
    return this.setmag(dy * this.mag() / this.y);
  }
  
  vec rotate(float rot){
    return new vec(
      x * cos(rot) - y * sin(rot),
      x * sin(rot) + y * cos(rot));
  }
  
  vec scalemag(float mag){
    return setmag(mag() * mag);
  }
  
  vec invert(){
    return new vec(x * -1, y * -1);
  }
  
  float dir(){
    return atan(y / x);
  }
  
  float speed(){
    return mag() * fps;
  }
  
  
  
}



class vec{
  
  float x, y;
  
  public vec(float mx, float my){
    x = mx; y = my;
  }
  public vec(){
    x = 0.0f;
    y = 0.0f;
  }
  
  void add(vec input){
    x += input.x;
    y += input.y;
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
  
  
  
}

class Target {
  PVector position;
  float diameter;
  
  Target(float x, float y, float diameter) {
    position = new PVector(x,y);
    this.diameter = diameter;
  }
  
  void show() {
    pushMatrix();
    fill(255, 0, 0);
    ellipse(position.x, position.y, diameter, diameter);
    fill(255);
    ellipse(position.x, position.y, diameter * 0.67, diameter * 0.67);
    fill(255, 0, 0);
    ellipse(position.x, position.y, diameter * 0.33, diameter * 0.33);
    popMatrix();
  }
} 
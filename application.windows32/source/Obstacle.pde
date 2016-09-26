class Obstacle {
  PVector  position;
  float obsWidth;
  float obsHeight;
  
  Obstacle(PVector position, float w, float h) {
    this.position = position;
    obsWidth = w;
    obsHeight = h;
  }
  
  Obstacle(PVector position) {
    this.position = position;
    obsWidth = random(50.0, 500);
    obsHeight = random(10, 300);
  }
  
  void show() {
    fill(255);
    rectMode(CENTER);
    rect(position.x, position.y, obsWidth, obsHeight);
  }
  
  boolean checkCollision(Rocket rocket) {
    float borderLeft = position.x - obsWidth/2;
    float borderRight = position.x + obsWidth/2;
    float borderTop = position.y - obsHeight/2;
    float borderBottom = position.y + obsHeight/2;
    
    float x = rocket.position.x;
    float y = rocket.position.y;
    
    boolean collided = (x >= borderLeft && y >= borderTop && y <= borderBottom && x <= borderRight);
    
    return collided;
  }
}
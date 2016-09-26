class Rocket {
  PVector position;
  PVector acceleration;
  PVector velocity;
  PVector gravity;
  float fitness;
  int flyTime;
  boolean crashed;
  boolean hitTarget;
  DNA dna;
  
  Rocket(DNA dna) {
    crashed = false;
    finished = false;
    this.dna = dna;
    flyTime = 1;
    fitness = 0.0000001f;
    
    position = new PVector(width / 2, height);
    acceleration = new PVector();
    velocity = new PVector();
    gravity = new PVector(0.0, 0.05);
  }
  
  void getFitness(PVector targetPosition) {
    float distanceToTarget = PVector.dist(position, targetPosition);
    
    if(crashed) {
     distanceToTarget = 1000f;
    }
   
 
    float newFitness = 1 / (3*flyTime) + 1 / distanceToTarget;
    
    fitness = newFitness;
   
    
    if(crashed) {
      fitness *= .1;
    }
  }
  
  
  void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  void show() {
    pushMatrix();
    
    translate(position.x, position.y);
    rotate(velocity.heading());
    noStroke();
    fill(77,162,214, 150);
    triangle(0, 10.0, 20.0, 0, 0.0, -10.0);
    
    popMatrix();
  }
  
  void update(){
    //applyForce(gravity);
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0.0);
    velocity.limit(4.0);
    
    checkCollision();
    
    if(!crashed && !hitTarget) {
      flyTime++; 
    }
  }
  
  void checkCollision() {
    if(position.x < 0 || position.x > width) {
      crashed = true;
    } else if (position.y < 0 || position.y > height) {
      crashed = true;
    }
  }
  
  void checkFinished(PVector targetPosition) {
    float distanceToTarget = PVector.dist(position, targetPosition);
    
    if(distanceToTarget <= 25) {
      hitTarget = true;
    }
  }
}
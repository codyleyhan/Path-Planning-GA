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

	/**
	 * Creates a new rocket
	 * @param dna determines how the rocket will behave
	 */
  Rocket(DNA dna) {
    crashed = false;
    finished = false;
    this.dna = dna;
    flyTime = 1;
    fitness = 0.0000001f;

		//sets the initial position of the rocket
    position = new PVector(width / 2, height);

    acceleration = new PVector();
    velocity = new PVector();
    gravity = new PVector(0.0, 0.025);
  }

	/*
	 * Determines the fitness of the rocket with more weight being placed on the
	 * fly time to find the fastest possible route to the target.
	 */
  void getFitness(PVector targetPosition) {
    float distanceToTarget = PVector.dist(position, targetPosition);

		// sets the distance to a very large number if the rocket crashes
    if(crashed) {
     distanceToTarget = 10000f;
    }


    float newFitness = 1 / pow(flyTime,2) + 1 / (2 * distanceToTarget*100);

    fitness = newFitness;

		//rocket inccur an extremely reduced fitness if it crashes
    if(crashed) {
      fitness *= 0.1f;
    }
  }


  void applyForce(PVector force) {
    acceleration.add(force);
  }

	/**
	 * Draws the rocket to the screen
	 */
  void show() {
    pushMatrix();

    translate(position.x, position.y);
    rotate(velocity.heading());
    noStroke();
    fill(77,162,214, 150);
    triangle(0, 10.0, 20.0, 0, 0.0, -10.0);

    popMatrix();
  }

	/**
	 * Applys the forces to the rocket and updates position and ensures rocket
	 * has not crashed
	 */
  void update(){
    applyForce(gravity);
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0.0);
    velocity.limit(4.0);

    checkCollision();

    if(!crashed && !hitTarget) {
      flyTime++;
    }
  }

	/**
	 * ensures that the rocket is still on the screen otherwise sets the rocket to
	 * crashed
	 */
  void checkCollision() {
    if(position.x < 0 || position.x > width) {
      crashed = true;
    } else if (position.y < 0 || position.y > height) {
      crashed = true;
    }
  }

	/**
	 * Checks to see if the rocket has completed the path and hit the target
	 * @param targetPosition the position vector of the center of the target
	 */
  void checkFinished(PVector targetPosition) {
    float distanceToTarget = PVector.dist(position, targetPosition);

    if(distanceToTarget <= 25) {
      hitTarget = true;
    }
  }
}
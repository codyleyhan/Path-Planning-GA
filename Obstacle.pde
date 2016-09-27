class Obstacle {
  PVector  position;
  float obsWidth;
  float obsHeight;

	/**
	 * Creates an obstacle for the path planning algorithm to navigate around
	 * @param position	the center position of the Obstacle
	 * @param w					the width of the Obstacle
	 * @param h					the height of the Obstacle
	 */
  Obstacle(PVector position, float w, float h) {
    this.position = position;
    obsWidth = w;
    obsHeight = h;
  }

	/**
	 * Creates an obstacle at the position given with random width and height
	 * @param position	the center position of the Obstacle
	 */
  Obstacle(PVector position) {
    this.position = position;
    obsWidth = random(125.0, 500);
    obsHeight = random(50, 300);
  }

	/**
	 * Draws the obstacle on the screen
	 */
  void show() {
    fill(255);
    rectMode(CENTER);
    rect(position.x, position.y, obsWidth, obsHeight);
  }

	/**
	 * Checks to see if the given rocket has collided with the obstacle
	 * @param  rocket the rocket that is navigating around the obstacle
	 * @return        returns true if collided
	 */
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
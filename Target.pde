class Target {
  PVector position;
  float diameter;

	/**
	 * Generates a bullseye target at the given position
	 * @param x						the x coordinate for the center of the target
	 * @param y						the y coordinate for the center of the target
	 * @param diameter		the diameter of the target to be drawn
	 */
  Target(float x, float y, float diameter) {
    position = new PVector(x,y);
    this.diameter = diameter;
  }

	/**
	 * draws the target to the screen
	 */
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

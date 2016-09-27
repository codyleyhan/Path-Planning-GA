class DNA {
  // Generates an array of acceleration vectors
  PVector[] genes;

  int lifeSpan;

  /**
   * Generates a new DNA object
   * @param lifeSpan	number of accleration vectors to generate
   */
  DNA(int lifeSpan) {
    genes = new PVector[lifeSpan];
    this.lifeSpan = lifeSpan;

    for(int i = 0; i < lifeSpan; i++) {
			// Generates a random acceleration vector
      PVector randomVector  = new PVector(random(-width/2, width/2),random(-height/20,0));

			// Stores the vector in genes and limits magnitude
      genes[i] = randomVector;
      genes[i].setMag(0.5);
    }
  }

	/**
	 * Crosses the DNA of the current DNA with a partner DNA
	 * @param  partner the DNA to be crossed with
	 * @return         returns a new DNA object
	 */
  DNA crossover(DNA partner) {
    DNA newDNA = new DNA(lifeSpan);

    // Generates a random crossover point
    float crossPoint = random(genes.length);


    for(int i = 0; i < genes.length; i++) {
      if(i > crossPoint) {
        newDNA.genes[i] = partner.genes[i];
      } else  {
        newDNA.genes[i] = genes[i];
      }
    }

    return newDNA;
  }

	/**
	 * Mutates the current DNA
	 * @param mutationRate the rate at which mutation occurs in the DNA
	 */
  void mutate(float mutationRate) {
    for(int i =0; i < lifeSpan; i++) {
      float n = random(1);
      if(n < mutationRate) {
				// Generates a new random acceleration vector
        genes[i] = PVector.random2D();
      }
    }
  }
}

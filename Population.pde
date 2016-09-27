class Population {
  Rocket[] rockets;
  ArrayList<Rocket> matingPool;

  int populationSize;
  float mutationRate;
  int generations;
  int lifeSpan;
  float bestFitness;
  PVector targetPosition;
  Obstacle obstacle;

	/**
	 * Generates a population of rockets with DNA that contains acceleration vectors
	 * @param populationSize	the number of rockets to generate in the population
	 * @param mutationSize		the rate at which mutation should occur
	 * @param target					the position of the rockets' target
	 * @param lifeSpan				how long the rockets should be able to attempt to
	 *                    		target
	 * @param	obstacle				the obstacle the rockets need to navigate around
	 */
  Population(int populationSize, float mutationRate, PVector target, int lifeSpan, Obstacle obstacle) {
    this.populationSize = populationSize;
    this.mutationRate = mutationRate;
    this.targetPosition = target;
    this.lifeSpan = lifeSpan;
    this.obstacle = obstacle;
    bestFitness = 0;

    rockets = new Rocket[populationSize];

		// Generates the initial DNA for the rockets
    for(int i = 0; i < rockets.length; i++) {
      DNA dna = new DNA(lifeSpan);
      rockets[i] = new Rocket(dna);
    }

    matingPool = new ArrayList<Rocket>();
    generations = 0;
  }

	/*
	 * Evolution occurs by determining the the fitness of each rocket's DNA
	 * and then generates a mating pool for offspring to be generated
	 */
  void naturalSelection() {
		// ensures the mating pool is cleared
    matingPool.clear();

    float bestFitness = bestFitness();

    for(int i = 0; i < populationSize; i++) {
      //scale fitness
      float fitness = map(rockets[i].fitness, 0, bestFitness, 0, 1);

			// generates mating pool
      int n = int(fitness * 100);
      for(int j = 0; j < n; j++) {
        matingPool.add(rockets[i]);
      }

    }
  }

  /**
   * Selects two random partners in  the mating pool and generates
   * an offspring from the two partners and attempts mutation of the
   * offspring's DNA.
   */
  void generate() {
    for(int i = 0; i < rockets.length; i++) {
      int a = int(random(matingPool.size()));
      int b = int(random(matingPool.size()));

      while (a == b) {
        b = int(random(matingPool.size()));
      }

      DNA partnerA = matingPool.get(a).dna;
      DNA partnerB = matingPool.get(b).dna;

      DNA child = partnerA.crossover(partnerB);

      child.mutate(mutationRate);
      rockets[i] = new Rocket(child);
    }

    generations++;
  }

	/**
	 * Determines the rocket that has the best fitness
	 * @return bestFitness	returns the bestFitness as a float
	 */
  float bestFitness() {
    float bestFitness = 0.0f;

    for(int i = 0; i < populationSize; i++) {
      rockets[i].getFitness(targetPosition);
      if( rockets[i].fitness > bestFitness) {
        bestFitness = rockets[i].fitness;
      }
    }
    this.bestFitness = bestFitness;
    return bestFitness;
  }

	/**
	 * Returns the current generation
	 * @return generations the integer value of the current generation
	 */
  int getGenerations() {
    return generations;
  }

	/**
	 * Draws each rocket to the screen
	 * @param count used to determine the position in the genes array of the rockets
	 */
  void show(int count) {
    for(int i = 0; i < populationSize; i++) {
      if(rockets[i].hitTarget) {
        rockets[i].show();
      } else if(!rockets[i].crashed) {
        rockets[i].applyForce(rockets[i].dna.genes[count]);
        rockets[i].update();
        rockets[i].checkFinished(targetPosition);
        if(obstacle.checkCollision(rockets[i])) {
          rockets[i].crashed = true;
        }
        rockets[i].show();
      }
    }
  }
}

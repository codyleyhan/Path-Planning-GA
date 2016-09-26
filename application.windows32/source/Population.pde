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
  
  Population(int populationSize, float mutationRate, PVector target, int lifeSpan, Obstacle obstacle) {
    this.populationSize = populationSize;
    this.mutationRate = mutationRate;
    this.targetPosition = target;
    this.lifeSpan = lifeSpan;
    this.obstacle = obstacle;
    bestFitness = 0;
    
    rockets = new Rocket[populationSize];
    
    for(int i = 0; i < rockets.length; i++) {
      DNA dna = new DNA(lifeSpan);
      rockets[i] = new Rocket(dna);
    }
    
    matingPool = new ArrayList<Rocket>();
    generations = 0;
  }
  
  void naturalSelection() {
    matingPool.clear();
    
    float bestFitness = bestFitness();
    
    for(int i = 0; i < populationSize; i++) {
      //scale fitness
      float fitness = map(rockets[i].fitness, 0, bestFitness, 0, 1);
      
      int n = int(fitness * 100);
      for(int j = 0; j < n; j++) {
        matingPool.add(rockets[i]);
      }
      
    }
  }
  
  
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
  
  
  int getGenerations() {
    return generations;
  }
  
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
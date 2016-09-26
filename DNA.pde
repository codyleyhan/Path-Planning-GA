class DNA {
  PVector[] genes;
  int lifeSpan;
  
  DNA(int lifeSpan) {
    genes = new PVector[lifeSpan];
    this.lifeSpan = lifeSpan;
    
    for(int i = 0; i < lifeSpan; i++) {
      PVector randomVector  = new PVector(random(-width/2, width/2),random(-height/20,0));
      genes[i] = randomVector;
      genes[i].setMag(0.5);
    }
  }
  
  DNA crossover(DNA partner) {
    DNA newDNA = new DNA(lifeSpan);
    
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
  
  void mutate(float mutationRate) {
    for(int i =0; i < lifeSpan; i++) {
      float n = random(1);
      if(n < mutationRate) {
        genes[i] = PVector.random2D();
      }
    }
  }
}
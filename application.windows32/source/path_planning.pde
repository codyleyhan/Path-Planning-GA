Population population;
int populationSize;
int lifeSpan;
int timer;
float mutationRate;
Target target;
Obstacle obstacle;


void setup() {
  size(1280, 720);
  lifeSpan = 350;
  timer = 0;
  populationSize = 100;
  mutationRate = 0.01;
  
  
  obstacle = new Obstacle(new PVector(width/2, height/2));
  target = new Target(width / 2, 50, 30);
  population = new Population(populationSize, mutationRate, target.position, lifeSpan, obstacle);
}

void draw() {
  background(51);
  displayInfo();
  obstacle.show();
  target.show();
  
  if(timer < lifeSpan) {
    population.show(timer);
    timer++;
  } else {
    population.naturalSelection();
    population.generate();
    timer = 0;
  }
}

void displayInfo() {
  textAlign(LEFT);
  textSize(18);
  fill(255);
  text("Total generations: " + population.getGenerations(), 20, 20);
  text("Mutation Rate: " + mutationRate * 100 + "%", 20, 40);
  text("Population Size: " + populationSize, 20, 60);
  text("Best Fitness: " + population.bestFitness, 20, 80);
}
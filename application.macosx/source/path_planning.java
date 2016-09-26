import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class path_planning extends PApplet {

Population population;
int populationSize;
int lifeSpan;
int timer;
float mutationRate;
Target target;
Obstacle obstacle;


public void setup() {
  
  lifeSpan = 350;
  timer = 0;
  populationSize = 100;
  mutationRate = 0.01f;
  
  
  obstacle = new Obstacle(new PVector(width/2, height/2));
  target = new Target(width / 2, 50, 30);
  population = new Population(populationSize, mutationRate, target.position, lifeSpan, obstacle);
}

public void draw() {
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

public void displayInfo() {
  textAlign(LEFT);
  textSize(18);
  fill(255);
  text("Total generations: " + population.getGenerations(), 20, 20);
  text("Mutation Rate: " + mutationRate * 100 + "%", 20, 40);
  text("Population Size: " + populationSize, 20, 60);
  text("Best Fitness: " + population.bestFitness, 20, 80);
}
class DNA {
  PVector[] genes;
  int lifeSpan;
  
  DNA(int lifeSpan) {
    genes = new PVector[lifeSpan];
    this.lifeSpan = lifeSpan;
    
    for(int i = 0; i < lifeSpan; i++) {
      PVector randomVector  = new PVector(random(-width/2, width/2),random(-height/20,0));
      genes[i] = randomVector;
      genes[i].setMag(0.5f);
    }
  }
  
  public DNA crossover(DNA partner) {
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
  
  public void mutate(float mutationRate) {
    for(int i =0; i < lifeSpan; i++) {
      float n = random(1);
      if(n < mutationRate) {
        genes[i] = PVector.random2D();
      }
    }
  }
}
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
    obsWidth = random(50.0f, 500);
    obsHeight = random(10, 300);
  }
  
  public void show() {
    fill(255);
    rectMode(CENTER);
    rect(position.x, position.y, obsWidth, obsHeight);
  }
  
  public boolean checkCollision(Rocket rocket) {
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
  
  public void naturalSelection() {
    matingPool.clear();
    
    float bestFitness = bestFitness();
    
    for(int i = 0; i < populationSize; i++) {
      //scale fitness
      float fitness = map(rockets[i].fitness, 0, bestFitness, 0, 1);
      
      int n = PApplet.parseInt(fitness * 100);
      for(int j = 0; j < n; j++) {
        matingPool.add(rockets[i]);
      }
      
    }
  }
  
  
  public void generate() {
    for(int i = 0; i < rockets.length; i++) {
      int a = PApplet.parseInt(random(matingPool.size()));
      int b = PApplet.parseInt(random(matingPool.size()));
      
      while (a == b) {
        b = PApplet.parseInt(random(matingPool.size()));
      }
      
      DNA partnerA = matingPool.get(a).dna;
      DNA partnerB = matingPool.get(b).dna;
      
      DNA child = partnerA.crossover(partnerB);
      
      child.mutate(mutationRate);
      rockets[i] = new Rocket(child);
    }
    
    generations++;
  }
  
  public float bestFitness() {
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
  
  
  public int getGenerations() {
    return generations;
  }
  
  public void show(int count) {
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
    gravity = new PVector(0.0f, 0.05f);
  }
  
  public void getFitness(PVector targetPosition) {
    float distanceToTarget = PVector.dist(position, targetPosition);
    
    if(crashed) {
     distanceToTarget = 1000f;
    }
   
 
    float newFitness = 1 / (3*flyTime) + 1 / distanceToTarget;
    
    fitness = newFitness;
   
    
    if(crashed) {
      fitness *= .1f;
    }
  }
  
  
  public void applyForce(PVector force) {
    acceleration.add(force);
  }
  
  public void show() {
    pushMatrix();
    
    translate(position.x, position.y);
    rotate(velocity.heading());
    noStroke();
    fill(77,162,214, 150);
    triangle(0, 10.0f, 20.0f, 0, 0.0f, -10.0f);
    
    popMatrix();
  }
  
  public void update(){
    //applyForce(gravity);
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(0.0f);
    velocity.limit(4.0f);
    
    checkCollision();
    
    if(!crashed && !hitTarget) {
      flyTime++; 
    }
  }
  
  public void checkCollision() {
    if(position.x < 0 || position.x > width) {
      crashed = true;
    } else if (position.y < 0 || position.y > height) {
      crashed = true;
    }
  }
  
  public void checkFinished(PVector targetPosition) {
    float distanceToTarget = PVector.dist(position, targetPosition);
    
    if(distanceToTarget <= 25) {
      hitTarget = true;
    }
  }
}
class Target {
  PVector position;
  float diameter;
  
  Target(float x, float y, float diameter) {
    position = new PVector(x,y);
    this.diameter = diameter;
  }
  
  public void show() {
    pushMatrix();
    fill(255, 0, 0);
    ellipse(position.x, position.y, diameter, diameter);
    fill(255);
    ellipse(position.x, position.y, diameter * 0.67f, diameter * 0.67f);
    fill(255, 0, 0);
    ellipse(position.x, position.y, diameter * 0.33f, diameter * 0.33f);
    popMatrix();
  }
} 
  public void settings() {  size(1280, 720); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "path_planning" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}

color c1 = color(100, 120, 120);
color c2 = color(100, 150, 200);
color obstacleColorTwo = color(255, 0 , 0);
color obstacleColorOne = color(255, 212, 36);
Player player = new Player(80, 100, 100, c1);
Player player2 = new Player(80, 200, 200, c2);
boolean[] keys = new boolean[4];  // 0: W, 1: A, 2: S, 3: D
boolean[] keys2 = new boolean[4]; // 0: I (w), 2: J (a), 2: K (s), 3: L (d)
float threshold = 0.05;
Obstacle[] obstacles = new Obstacle[50];
boolean triggered = false;
int timer;
final int quarterSecond = 15;
final int halfSecond = 30;
final int fullSecond = 60;
int counter = 0;
boolean isDashingOne = false;
boolean isDashingTwo = false;
// timer
int countSeconds;
PVector safeZonePos;

void setup() {
  size(1920, 1080);
  frameRate(60);
  for(int i = 0; i < obstacles.length; i++) {
    obstacles[i] = new Obstacle((int) random(20, 50), 0, 0, 10, obstacleColorOne, obstacleColorTwo);
  }
  populate(obstacles);
  timer = 0;
  safeZonePos = new PVector(random(player.size+10, width-player.size-10), random(player.size+10, height-player.size));
}

void draw() {
  //safe zone and red zone code
  if(countSeconds<50){
    background(255);}
  else if(countSeconds> 50 && countSeconds%2 == 1){
    background(255,90,120);
    tint(255,200);}
  else{
    background(255);}
  if(countSeconds >= 50){
    fill(173,255,179);
    tint(255,128);
    ellipse(safeZonePos.x + player.radius, safeZonePos.y + player.radius, player.size+60 - player.radius, player.size+60 - player.radius);
  }
  
  
  if(isWinner(player, player2)) {
    background(255);
    fill(0, 0, 0);
    textSize(100);
    fill(c1);
    ellipse(width/2-50, height/2-25, player.size, player.size);
    text("won!", width/2, height/2); 
  }
  else if(isWinner(player2, player)) {
    background(255);
    fill(0, 0, 0);
    textSize(100);
    fill(c2);
    ellipse(width/2-50, height/2-25, player2.size, player2.size);
    text("won!", width/2, height/2); 
  }
  else {
    //every half second spawn a bomb, the time between bombs will get shorter based off of the time
    if(timer % fullSecond*4 == 0 && timer > fullSecond*3) {
      if(counter >= 50) counter = 0;
      obstacles[counter].show();
      counter++;
    }
    //update spawned bombs
    for(Obstacle x : obstacles) {
      if(x.isSpawned)
        x.show();
    }
    player.updateVelocity(false);
    player.dash(isDashingOne);
    player.checkBoundaryCollision(false);
    player.checkPlayerCollision(player2);
    //obstacle collision
    for(Obstacle x : obstacles) {
      player.checkObstacleCollision(x, false);
    }
    player.update();
    player.show(false);
    player2.updateVelocity(true);
    player2.dash(isDashingTwo);
    player2.checkBoundaryCollision(true);
    player2.checkPlayerCollision(player);
    //obstacle collision
    for(Obstacle x : obstacles) {
      player2.checkObstacleCollision(x, true);
    }
    player2.update();
    player2.show(true);
    // update timer code
    if (timer%60 == 0){
      countSeconds +=1;
    }
    timer++;
    fill(0,0,0);
    textSize(64);
    text("Time: " + countSeconds, width/2.7, height/16);
  }
}

void keyPressed() {
  if(key == 'E' || key == 'e' ) {
    isDashingOne = true;
  }
  if(key == 'U' || key == 'u') {
    isDashingTwo = true;
  }
  if (key == 'W' || key == 'w') {
    keys[0] = true;
  }
  if (key == 'A' || key == 'a') {
    keys[1] = true;
  }
  if (key == 'S' || key == 's') {
    keys[2] = true;
  }
  if (key == 'D' || key == 'd') {
    keys[3] = true;
  }
  if (key == 'I' || key == 'i') {
    keys2[0] = true;
  }
  if (key == 'J' || key == 'j') {
    keys2[1] = true;
  }
  if (key == 'K' || key == 'k') {
    keys2[2] = true;
  }
  if (key == 'L' || key == 'l') {
    keys2[3] = true;
  }
}

void keyReleased() {
  if(key == 'E' || key == 'e' ) {
    isDashingOne = false;
  }
  if(key == 'U' || key == 'u') {
    isDashingTwo = false;
  }
  if (key == 'W' || key == 'w') {
    keys[0] = false;
  }
  if (key == 'A' || key == 'a') {
    keys[1] = false;
  }
  if (key == 'S' || key == 's') {
    keys[2] = false;
  }
  if (key == 'D' || key == 'd') {
    keys[3] = false;
  }
  if (key == 'I' || key == 'i') {
    keys2[0] = false;
  }
  if (key == 'J' || key == 'j') {
    keys2[1] = false;
  }
  if (key == 'K' || key == 'k') {
    keys2[2] = false;
  }
  if (key == 'L' || key == 'l') {
    keys2[3] = false;
  }
  
}

void populate(Obstacle[] bombs) {
      for(int i = 0; i < bombs.length; i++) {
        bombs[i].position.x = random(0, width);
        bombs[i].position.y = random(0, height);
      }
    }
boolean isWinner(Player player, Player other) {
  if(player.lives <= 0 && other.lives > 0) {
    return false;
  }
  else if(player.lives > 0 && other.lives <= 0) {
    return true;
  }
  return false;
}

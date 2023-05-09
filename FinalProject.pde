Player player = new Player(50);
boolean[] keys = new boolean[4];  // 0: W, 1: A, 2: S, 3: D
float threshold = 0.05;

void setup() {
  size(1280, 1080);
  fill(color(32, 224, 155));
}

void draw() {
  background(255);
  // adjust velocity based on input
  if (keys[0]) {
    if(player.yVel > 0) player.yVel -= 0.5;
    else player.yVel -= 0.1;
  }
  if (keys[1]) {
    if(player.xVel > 0) player.xVel -= 0.5;
    else player.xVel -= 0.1;
  }
  if (keys[2]) {
    if(player.yVel < 0) player.yVel += 0.5;
    else player.yVel += 0.1;
  }
  if (keys[3]) {
    if(player.xVel < 0) player.xVel += 0.5;
    else player.xVel += 0.1;
  }
  // decelerate if no keys are pressed
  if (!keys[0] && !keys[2]) {
    if (player.yVel < 0) {
      player.yVel += 0.1;
      if (player.yVel > 0) {
        player.yVel = 0;
      }
    } else if (player.yVel > 0) {
      player.yVel -= 0.1;
      if (player.yVel < 0) {
        player.yVel = 0;
      }
    }
  }
  if (!keys[1] && !keys[3]) {
    if (player.xVel < 0) {
      player.xVel += 0.1;
      if (player.xVel > 0) {
        player.xVel = 0;
      }
    } else if (player.xVel > 0) {
      player.xVel -= 0.1;
      if (player.xVel < 0) {
        player.xVel = 0;
      }
    }
  }
  // Set velocities to zero if they're below the threshold
  if(abs(player.yVel) < threshold) {
    player.yVel = 0;
  }
  if(abs(player.xVel) < threshold) {
    player.xVel = 0;
  }
  player.checkBoundaryCollision();
  player.update();
}

void keyPressed() {
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
}

void keyReleased() {
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
}

class Player {
  int x;
  int y;
  float size;
  float xVel = 0;
  float yVel = 0;
  
  public Player(int size) {
    this.x = width / 2;
    this.y = height / 2;
    this.size = size;
  }

  public void update() {
    ellipse(x+=xVel, y+=yVel, size, size);
  }
  
  public void checkBoundaryCollision() {
    // if the x position == is greater than or equal to the edge of the screen
    if(this.x >= width-(size/2)) {
      xVel *= -0.7;
    }
    if(this.y >= height-(size/2)) {
      yVel *= -0.7;
    }
    if(this.x < size/2) {
      x = (int) size/2;
      xVel *= -0.7;
    }
    if(this.y < size/2) {
      y = (int) size/2;
      yVel *= -0.7;
    }
  }
}

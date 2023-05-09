color c1 = color(100, 120, 120);
color c2 = color(100, 150, 200);
Player player = new Player(50, 100, 100, c1);
Player player2 = new Player(50, 150, 150, c2);
boolean[] keys = new boolean[4];  // 0: W, 1: A, 2: S, 3: D
boolean[] keys2 = new boolean[4]; // 0: I (w), 2: J (a), 2: K (s), 3: L (d)
float threshold = 0.05;

void setup() {
  size(1280, 1080);
}

void draw() {
  background(255);
  // adjust velocity based on input
  player.updateVelocity(false);
  player.checkBoundaryCollision();
  player.update();
  player.show();
  player2.updateVelocity(true);
  player2.checkBoundaryCollision();
  player2.update();
  player2.show();
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
  if(key == 'z' ) player.isSlippy = !player.isSlippy;
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

class Player {
  float x;
  float y;
  color c;
  float size;
  PVector position;
  PVector velocity;
  float accelerateSpeed = 0.1;
  float decelerateSpeed = 0.2;
  boolean isSlippy = false;
  float radius;
  
  public Player(float size, int x, int y, color c) {
    this.position = new PVector(x, y);
    this.velocity = new PVector(0, 0);
    this.size = size;
    this.radius = size/2.0;
    this.c = c;
  }

  public void show() {
    fill(c);
    ellipse(position.x, position.y, size, size);
  }

  public void update() {
    position.add(velocity);
  }
  
  public void checkBoundaryCollision() {
    // if the x position == is greater than or equal to the edge of the screen
    if(position.x >= width-(size/2)) {
      velocity.x *= -1;
    }
    if(position.y >= height-(size/2)) {
      velocity.y *= -1;
    }
    if(position.x < size/2) {
      position.x = size/2;
      velocity.x *= -1;
    }
    if(position.y < size/2) {
      position.y = size/2;
      velocity.y *= -1;
    }
  }
  
  public void checkPlayerCollision(Player other) {
    if (position.x > width-radius) {
      position.x = width-radius;
      velocity.x *= -1;
    } else if (position.x < radius) {
      position.x = radius;
      velocity.x *= -1;
    } else if (position.y > height-radius) {
      position.y = height-radius;
      velocity.y *= -1;
    } else if (position.y < radius) {
      position.y = radius;
      velocity.y *= -1;
    }
  }
  
  public void updateVelocity(boolean two) {
    if(!two) {
      if(isSlippy) { decelerateSpeed = 0.05; }
        if (keys[0]) {
          if(this.velocity.y > 0) velocity.y -= decelerateSpeed*2;
          else velocity.y -= accelerateSpeed;
        }
        if (keys[1]) {
          if(velocity.x > 0) velocity.x -= decelerateSpeed*2;
          else velocity.x -= accelerateSpeed;
        }
        if (keys[2]) {
          if(velocity.y < 0) velocity.y += decelerateSpeed*2;
          else velocity.y += accelerateSpeed;
        }
        if (keys[3]) {
          if(velocity.x < 0) velocity.x += decelerateSpeed*2;
          else velocity.x += accelerateSpeed;
        }
        // decelerate if no keys are pressed
        if (!keys[0] && !keys[2]) {
          if (velocity.y < 0) {
            velocity.y += decelerateSpeed;
            if (velocity.y > 0) {
              velocity.y = 0;
            }
          } else if (velocity.y > 0) {
            velocity.y -= decelerateSpeed;
            if (velocity.y < 0) {
              velocity.y = 0;
            }
          }
        }
          if (!keys[1] && !keys[3]) {
            if (velocity.x < 0) {
              velocity.x += decelerateSpeed;
              if (velocity.x > 0) {
                velocity.x = 0;
              }
            } else if (velocity.x > 0) {
              velocity.x -= decelerateSpeed;
              if (velocity.x < 0) {
                velocity.x = 0;
              }
            }
        }
        // Set velocities to zero if they're below the threshold
        if(abs(velocity.y) < threshold) {
          velocity.y = 0;
        }
        if(abs(velocity.x) < threshold) {
          velocity.x = 0;
        }
      }
  else {
     if(isSlippy) { decelerateSpeed = 0.05; }
      if (keys2[0]) {
        if(this.velocity.y > 0) velocity.y -= decelerateSpeed*2;
        else velocity.y -= accelerateSpeed;
      }
      if (keys2[1]) {
        if(velocity.x > 0) velocity.x -= decelerateSpeed*2;
        else velocity.x -= accelerateSpeed;
      }
      if (keys2[2]) {
        if(velocity.y < 0) velocity.y += decelerateSpeed*2;
        else velocity.y += accelerateSpeed;
      }
      if (keys2[3]) {
        if(velocity.x < 0) velocity.x += decelerateSpeed*2;
        else velocity.x += accelerateSpeed;
      }
      // decelerate if no keys are pressed
      if (!keys2[0] && !keys2[2]) {
        if (velocity.y < 0) {
          velocity.y += decelerateSpeed;
          if (velocity.y > 0) {
            velocity.y = 0;
          }
        } else if (velocity.y > 0) {
          velocity.y -= decelerateSpeed;
          if (velocity.y < 0) {
            velocity.y = 0;
          }
        }
      }
        if (!keys2[1] && !keys2[3]) {
          if (velocity.x < 0) {
            velocity.x += decelerateSpeed;
            if (velocity.x > 0) {
              velocity.x = 0;
            }
          } else if (velocity.x > 0) {
            velocity.x -= decelerateSpeed;
            if (velocity.x < 0) {
              velocity.x = 0;
            }
          }
      }
      // Set velocities to zero if they're below the threshold
      if(abs(velocity.y) < threshold) {
        velocity.y = 0;
      }
      if(abs(velocity.x) < threshold) {
        velocity.x = 0;
      }
    }
  }
}

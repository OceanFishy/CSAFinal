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
  player.checkPlayerCollision(player2);
  player.update();
  player.show();
  player2.updateVelocity(true);
  player2.checkBoundaryCollision();
  player2.checkPlayerCollision(player);
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

    // Get distances between the balls components
    PVector distanceVect = PVector.sub(other.position, position);

    // Calculate magnitude of the vector separating the balls
    float distanceVectMag = distanceVect.mag();

    // Minimum distance before they are touching
    float minDistance = radius + other.radius;

    if (distanceVectMag < minDistance) {
      float distanceCorrection = (minDistance-distanceVectMag)/2.0;
      PVector d = distanceVect.copy();
      PVector correctionVector = d.normalize().mult(distanceCorrection);
      other.position.add(correctionVector);
      position.sub(correctionVector);

      // get angle of distanceVect
      float theta  = distanceVect.heading();
      // precalculate trig values
      float sine = sin(theta);
      float cosine = cos(theta);

      /* bTemp will hold rotated ball positions. You 
       just need to worry about bTemp[1] position*/
      PVector[] bTemp = {
        new PVector(), new PVector()
      };

      /* this ball's position is relative to the other
       so you can use the vector between them (bVect) as the 
       reference point in the rotation expressions.
       bTemp[0].position.x and bTemp[0].position.y will initialize
       automatically to 0.0, which is what you want
       since b[1] will rotate around b[0] */
      bTemp[1].x  = cosine * distanceVect.x + sine * distanceVect.y;
      bTemp[1].y  = cosine * distanceVect.y - sine * distanceVect.x;

      // rotate Temporary velocities
      PVector[] vTemp = {
        new PVector(), new PVector()
      };

      vTemp[0].x  = cosine * velocity.x + sine * velocity.y;
      vTemp[0].y  = cosine * velocity.y - sine * velocity.x;
      vTemp[1].x  = cosine * other.velocity.x + sine * other.velocity.y;
      vTemp[1].y  = cosine * other.velocity.y - sine * other.velocity.x;

      /* Now that velocities are rotated, you can use 1D
       conservation of momentum equations to calculate 
       the final velocity along the x-axis. */
      PVector[] vFinal = {  
        new PVector(), new PVector()
      };

      // final rotated velocity for b[0]
      vFinal[0].x = ((size - other.size) * vTemp[0].x + 2 * other.size * vTemp[1].x) / (size + other.size);
      vFinal[0].y = vTemp[0].y;

      // final rotated velocity for b[0]
      vFinal[1].x = ((other.size - size) * vTemp[1].x + 2 * size * vTemp[0].x) / (size + other.size);
      vFinal[1].y = vTemp[1].y;

      // hack to avoid clumping
      bTemp[0].x += vFinal[0].x;
      bTemp[1].x += vFinal[1].x;

      /* Rotate ball positions and velocities back
       Reverse signs in trig expressions to rotate 
       in the opposite direction */
      // rotate balls
      PVector[] bFinal = { 
        new PVector(), new PVector()
      };

      bFinal[0].x = cosine * bTemp[0].x - sine * bTemp[0].y;
      bFinal[0].y = cosine * bTemp[0].y + sine * bTemp[0].x;
      bFinal[1].x = cosine * bTemp[1].x - sine * bTemp[1].y;
      bFinal[1].y = cosine * bTemp[1].y + sine * bTemp[1].x;

      // update balls to screen position
      other.position.x = position.x + bFinal[1].x;
      other.position.y = position.y + bFinal[1].y;

      position.add(bFinal[0]);

      // update velocities
      velocity.x = cosine * vFinal[0].x - sine * vFinal[0].y;
      velocity.y = cosine * vFinal[0].y + sine * vFinal[0].x;
      other.velocity.x = cosine * vFinal[1].x - sine * vFinal[1].y;
      other.velocity.y = cosine * vFinal[1].y + sine * vFinal[1].x;
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

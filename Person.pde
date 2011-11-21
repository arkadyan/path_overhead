class Person {
  
  import toxi.geom.*;
  import toxi.processing.*;
  
  
  static private final color PERSON_COLOR = #000000;
  static private final int BODY_LENGTH = 15;
  static private final int BODY_WIDTH = 30;
  static private final int HEAD_LENGTH = 15;
  static private final int HEAD_WIDTH = 12;
  
  static private final float MAX_SPEED = 3;
  
  private Vec2D position;
  private Vec2D velocity;
  private Vec2D acceleration;
  
  
  Person(Vec2D pos) {
    position = new Vec2D(pos);
    velocity = new Vec2D(MAX_SPEED, 0);
    acceleration = new Vec2D(0, 0);
  }
  
  
  /**
   * Update our position based on the current velocity,
   * and our velocity based on the current acceleration.
   * Reset the acceleration to 0 on every cycle.
   */
  public void update() {
    // Update our velocity based on our current acceleration.
    velocity.addSelf(acceleration);
    // Limit our speed.
    velocity.limit(MAX_SPEED);
    // Update our position based on our current velocity.
    position.addSelf(velocity);
    // Reset acceleration to 0 each cycle.
    acceleration.scale(0);
  }
  
  /**
   * Draw our person at the current position.
   */
  public void draw(ToxiclibsSupport gfx, boolean debug) {
    // Since it is drawn pointing up, we rotate it an additional 90 degrees.
    float theta = velocity.heading() + PI/2;
    
    noStroke();
    fill(PERSON_COLOR);
    
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    
    beginShape();
    // Body oval
    ellipse(0, 0, BODY_WIDTH, BODY_LENGTH);
    // Head oval
    ellipse(0, -0.3*HEAD_LENGTH, HEAD_WIDTH, HEAD_LENGTH);
    endShape();
    popMatrix();
  }
}

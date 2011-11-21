/**
 * Representation of person that lives in this world
 * and walks along paths.
 */
class Person {
  
  import toxi.geom.*;
  import toxi.processing.*;
  
  
  static private final color PERSON_COLOR = #000000;
  static private final int BODY_LENGTH = 8;
  static private final int BODY_WIDTH = 15;
  static private final int HEAD_LENGTH = 8;
  static private final int HEAD_WIDTH = 6;
  
  static private final float MAX_SPEED = 3;
  
  private Vec2D position;
  private Vec2D velocity;
  private Vec2D acceleration;
  
  // Properties shown while debugging
  private Vec2D predictedPosition;
  
  
  /**
   * Creates a new person position at the given location.
   * 
   * @param pos  The position to start at.
   */
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
   *
   * @param gfx  A ToxiclibsSupport object to use for drawing.
   * @param debug  Whether on not to draw debugging visuals.
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
    gfx.ellipse(new Ellipse(0, 0, BODY_WIDTH, BODY_LENGTH));
    // Head oval
    gfx.ellipse(new Ellipse(0, -0.5*HEAD_LENGTH, HEAD_WIDTH, HEAD_LENGTH));
    endShape();
    popMatrix();
    
    if (debug) drawDebugVisuals(gfx);
  }
  
  /**
   * Make the person follow along a given Path.
   *
   * @param path  The Path object the person should follow.
   */
  public void follow(Path path) {
    // Predict location 25 (arbitrary choice) frames ahead.
    predictedPosition = predictPosition(25);
  }
  
  
  /**
   * Translate force on this Person into acceleration.
   */
  private void applyForce(Vec2D force) {
    acceleration.addSelf(force);
  }
  
  /**
   * Predict our position a given number of frames into the future.
   */
  private Vec2D predictPosition(int frames) {
    Vec2D prediction = velocity.getNormalized();
    prediction.scaleSelf(frames);
    return position.add(prediction);
  }
  
  /**
   * Draw extra visuals useful for debugging purposes.
   */
  private void drawDebugVisuals(ToxiclibsSupport gfx) {
    // Draw the predicted future position.
    stroke(#ff00ff);
    fill(#ff00ff);
    gfx.line(position, predictedPosition);
    gfx.ellipse(new Ellipse(predictedPosition, 4));
  }
}

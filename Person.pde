/**
 * Representation of person that lives in this world
 * and walks along paths.
 */
class Person extends Mover {
  
  import toxi.geom.*;
  import toxi.processing.*;
  
  
  static private final color PERSON_COLOR = #000000;
  static private final int BODY_LENGTH = 8;
  static private final int BODY_WIDTH = 15;
  static private final int HEAD_LENGTH = 8;
  static private final int HEAD_WIDTH = 6;
    
  // Properties shown while debugging
  private Vec2D predictedPosition;   // Where we expect to be in the future.
  private Vec2D targetPosition;   // Where we should steer to if too far off course.
  
  
  /**
   * Creates a new person position at the given location.
   * 
   * @param pos  The position to start at.
   */
  Person(Vec2D pos) {
    position = new Vec2D(pos);
/*    velocity = new Vec2D(0, 0);*/
    velocity = new Vec2D(maxSpeed, 0);
    acceleration = new Vec2D(0, 0);
    
    maxSpeed = 3;
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
    
    // Target the closest normal point on the path segment to the predictPosition.
    targetPosition = findClosestNormal(path);
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
   * Determine the closest normal to the predictedPosition
   * on any segments of the given path.
   */
  private Vec2D findClosestNormal(Path path) {
    Vec2D normal = null;
    float shortestDistance = -1;
    
    List<Vec2D> points = path.getPointList();
    for (int i=0; i < points.size()-1; i++) {
      // Look at a line segment.
      Vec2D a = points.get(i);
      Vec2D b = points.get(i+1);
      
      // Get the normal point to this line segment.
/*      Vec2D tmpNormal = getNormalPoint(predictedPosition, a, b);*/
    }
    
    return normal;
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

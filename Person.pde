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
  
  // How far to keep away from other people.
  static private final int DESIRED_SEPARATION = 100;
  static private final float FOLLOW_WEIGHT = 1.0;
  static private final float AVOID_WEIGHT = 0.75;
  
  private int direction;
    
  // Properties shown while debugging
  private Vec2D predictedPosition;   // Where we expect to be in the future.
  private Vec2D targetPosition;   // Where we should steer to if too far off course.
  private boolean isFollowSteering = false;   // Whether we are currently steering towards the targetPosition.
  private Vec2D followSteeringForce = new Vec2D();   // The steering force directing us towards the target.
  private boolean isAvoidSteering = false;   // Whether we are currently steering away from other people.
  private Vec2D avoidSteeringForce = new Vec2D();   // The steering force directing us away from other people.
  
  
  /**
   * Creates a new person position at the given location.
   * 
   * @param pos  The position to start at.
   * @param ms  The maximum speed this person should move.
   * @param dir  The initial direction the person should be moving: -1 for left, +1 for right.
   */
  Person(Vec2D pos, float ms, int dir) {
    position = new Vec2D(pos);
    maxSpeed = ms;
    direction = dir;
    velocity = new Vec2D(maxSpeed * dir, 0);
    
    acceleration = new Vec2D(0, 0);
    maxForce = 0.1;
  }
  
  
  /**
   * Get the position of this person.
   */
  public Vec2D getPosition() {
    return position;
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
    targetPosition = targetAheadOfClosestNormal(path);
    

    // Determine whether to steer towards our targetPosition
    if (predictedPosition.distanceTo(targetPosition) > path.getWidth()*0.4 || isAvoidSteering) {
      isFollowSteering = true;
      seek(targetPosition);
    } else {
      isFollowSteering = false;
    }
  }
  
  /**
   * Avoid other people in the world who are near me.
   * 
   * @param people  A list of all the people in the world.
   */
  public void avoid(ArrayList<Person> people) {
    Vec2D sum = new Vec2D();   // Start with a zero vector
    
    for (Person otherPerson : people) {
      Vec2D otherPersonPosition = otherPerson.getPosition();
      float distance = position.distanceTo(otherPersonPosition);
      if ((distance > 0) && (distance < DESIRED_SEPARATION)) {
        Vec2D diff = position.sub(otherPersonPosition);
        diff.normalize();
        // The closer the other person is, the more we should flee.
        diff.scaleSelf(1/distance);
        sum.addSelf(diff);
      }
    }
    
    if (sum.magnitude() > 0) {
      isAvoidSteering = true;
      sum.normalize();
      sum.scaleSelf(maxSpeed);
      avoidSteeringForce = sum.sub(velocity);
      avoidSteeringForce.limit(maxForce);
      applyForce(avoidSteeringForce.scale(AVOID_WEIGHT));
    } else {
      isAvoidSteering = false;
    }
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
  private Vec2D targetAheadOfClosestNormal(Path path) {
    Vec2D normal = null;
    Vec2D target = null;
    float shortestDistance = -1;
    
    List<Vec2D> points = path.getPointList();
    for (int i=0; i < points.size()-1; i++) {
      // Look at a line segment.
      Vec2D a = points.get(i);
      Vec2D b = points.get(i+1);
      
      // Get the normal point to this line segment.
      Vec2D tmpNormal = getNormalPoint(predictedPosition, a, b);
      
      // This only works because we know that our path goes from left to right.
      // We could have a more sophisticated test to tell if the point
      // is in the line segment or not.
      if (tmpNormal.x < a.x) {
        tmpNormal = a.copy();
      } else if (tmpNormal.x > b.x) {
        tmpNormal = b.copy();
      }
      
      // How far away are we from the path?
      float tmpDistance = predictedPosition.distanceTo(tmpNormal);
      // Is this the new closest segment?
      if (shortestDistance == -1 || tmpDistance < shortestDistance) {
        shortestDistance = tmpDistance;
        normal = tmpNormal;
        
        // Look at the direction of the line segment so we can seek 
        // a little bit ahead of the normal.
        Vec2D pathDirection;
        if (direction > 0) {
          pathDirection = b.sub(a);
        } else {
          pathDirection = a.sub(b);
        }
        pathDirection.normalize();
        // This is an oversimplification.
        // It should be based on distance to the path and velocity.
        pathDirection.scaleSelf(10);
        target = normal.copy();
        target.addSelf(pathDirection);
        
        // Target out to the right of the path center a bit.
        target.addSelf( pathDirection.perpendicular().normalizeTo(10) );
      }
    }
    
    return target;
  }
  
  /**
   * Get the normal point from a point to a line segment.
   * This function could be optimized to make fewer new Vector objects.
   *
   * @param pnt  The point from which to find the normal.
   * @param a  The point at one end of the line.
   * @param b  The point at the other end of the line.
   */
  private Vec2D getNormalPoint(Vec2D pnt, Vec2D a, Vec2D b) {
    // Vector from a to pnt.
    Vec2D ap = pnt.sub(a);
    // Vector from a to b
    Vec2D ab = b.sub(a);
    // Normalize the line.
    ab.normalize();
    // Project vector diff onto the line using the dot product.
    ab.scaleSelf(ap.dot(ab));
    return a.add(ab);
  }
  
  /**
   * Calculate and apply a steering force towards a target.
   */
  private void seek(Vec2D target) {
    // A vector pointing from our current location to the target.
    Vec2D desired = target.sub(position);
    
    // If the distance equals 0, skip out here.
    if (desired.x==0 && desired.y==0) return;
    
    // The distance is the magnitude of the vector pointing from 
    // our position to the target.
    float distance = desired.magnitude();
    
    desired.normalize();
    // If we are closer than 100 pixels (arbitrary distance)…
    if (distance < 100) {
      // …set the magnitude according to how close.
      float m = map(distance, 0, 100, 0, maxSpeed);
      desired.scaleSelf(m);
    } else {
      // Otherwise, proceed at maximum speed.
      desired.scaleSelf(maxSpeed);
    }
    
    // Steering force = desired - velocity
    followSteeringForce = desired.sub(velocity);
    // Limit the magnitude of the steering force.
    followSteeringForce.limit(maxForce);
    // Apply the force to the object's acceleration
    applyForce(followSteeringForce.scale(FOLLOW_WEIGHT));
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
    
    // Draw the target position we might be steering towards.
    stroke(#000000);
    noFill();
    gfx.line(predictedPosition, targetPosition);
    noStroke();
    // Red if we are steering, black otherwise
    if (isFollowSteering) {
      fill(#ff0000);
    } else {
      fill(#000000);
    }
    gfx.ellipse(new Ellipse(targetPosition, 5));
    
    // Draw the follow steering force if active
    if (isFollowSteering) {
      stroke(#00E043);
      noFill();
      Arrow.draw(gfx, position, position.add(followSteeringForce.scale(1000)), 4);
    }
    
    // Draw the desired separation distance ring
    stroke(#0000ff);
    noFill();
    gfx.ellipse(new Ellipse(position, DESIRED_SEPARATION));
    
    // Draw the avoid steering force if active
    if (isAvoidSteering) {
      stroke(#0000ff);
      noFill();
      Arrow.draw(gfx, position, position.add(avoidSteeringForce.scale(1000)), 4);
    }
  }
}

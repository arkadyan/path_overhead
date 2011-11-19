public class Path {
  
  import toxi.geom.*;
  
  
  static private final color PATH_COLOR = #dc982c;
  static private final int PATH_WIDTH = 70;
  
  Spline2D path;
  
  
  /**
   * Constructor
   */
  Path() {
    path = new Spline2D();
    path.add(new Vec2D(50, 50));
    path.add(new Vec2D(100, 70));
    path.add(new Vec2D(200, 200));
    path.add(new Vec2D(250, 220));
    path.add(new Vec2D(320, 245));
    path.add(new Vec2D(500, 700));
  }
  
  /**
   * Draw the path.
   */
  public void draw() {
    stroke(PATH_COLOR);
    strokeWeight(PATH_WIDTH);
    noFill();
    
    beginShape();
    for (Iterator i = path.pointList.iterator(); i.hasNext();) {
      Vec2D v = (Vec2D)i.next();
      vertex(v.x, v.y);
    }
    endShape();
  }
  
}

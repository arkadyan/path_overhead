public class Path {
  
  import toxi.geom.*;
  import toxi.processing.*;
  
  
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
  public void draw(ToxiclibsSupport gfx, boolean debug) {
    // Draw the path with the full width.
    stroke(PATH_COLOR);
    strokeWeight(PATH_WIDTH);
    noFill();
    gfx.lineStrip2D(path.pointList);
    
    if (debug) drawDebugVisuals(gfx);
  }
  
  
  /**
   * Draw extra information for debugging.
   */
  private void drawDebugVisuals(ToxiclibsSupport gfx) {
    // Draw a thin line in the center of the path.
    stroke(50);
    strokeWeight(1);
    noFill();
    gfx.lineStrip2D(path.pointList);
  }
  
}

public class Path {
  
  static private final color PATH_COLOR = #dc982c;
  static private final int PATH_WIDTH = 70;
  
  private Point start;
  private Point end;
  
  
  /**
   * Constructor
   */
  Path() {
    start = new Point(50, 50);
    end = new Point(500, 250);
  }
  
  /**
   * Draw the path.
   */
  public void draw() {
    stroke(PATH_COLOR);
    strokeWeight(PATH_WIDTH);
    line(start.getX(), start.getY(), end.getX(), end.getY());
  }
  
}

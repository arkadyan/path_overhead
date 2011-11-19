public class Tree {
  
  static private final color TREE_COLOR = #084813;
  static private final int TREE_DIAMETER = 30;
  
  private Point loc;
  
  
  /**
   * Constructor
   */
  Tree(float _x, float _y) {
    loc = new Point(_x, _y);
  }
  
  
  /**
   * Draw the tree.
   */
  public void draw() {
    noStroke();
    fill(TREE_COLOR);
    // TODO: Draw a tree shape that's more interesting than a circle.
    ellipse(loc.getX(), loc.getY(), TREE_DIAMETER, TREE_DIAMETER);
  }
}

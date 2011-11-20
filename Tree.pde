public class Tree {
  
  import toxi.geom.*;

  
  static private final color TREE_COLOR = #084813;
  static private final int TREE_DIAMETER = 50;
  
  private Vec2D position;
  
  
  /**
   * Constructor
   */
  Tree(float _x, float _y) {
    position = new Vec2D(_x, _y);
  }
  
  
  /**
   * Draw the tree.
   */
  public void draw() {
    noStroke();
    fill(TREE_COLOR);
    // TODO: Draw a tree shape that's more interesting than a circle.
    ellipse(position.x, position.y, TREE_DIAMETER, TREE_DIAMETER);
  }
}

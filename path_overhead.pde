private static final color GRASS_COLOR = #017f16;
private static final int NUM_TREES = 30;

private Path path;
private Tree[] trees = new Tree[NUM_TREES];


void setup() {
  size(680, 480);
/*  size(1920, 1355);*/
  smooth();
  noCursor();
  ellipseMode(CENTER);
  
  path = new Path();
  placeTrees();
}

void draw() {
  background(GRASS_COLOR);
  
  // Draw the path
  path.draw();
  
  // Draw all the trees
  for (int i=0; i<trees.length; i++) {
    trees[i].draw();
  }
}


/**
 * Place trees randomly around the grounds.
 */
private void placeTrees() {
  // TODO: Keep trees off the path.
  for (int i=0; i<trees.length; i++) {
    trees[i] = new Tree(random(width), random(height));
  }
}

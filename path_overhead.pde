import toxi.processing.*;


private static final int WORLD_WIDTH = 6800;
private static final int WORLD_HEIGHT = 4800;

private static final color GRASS_COLOR = #017f16;
private static final int NUM_TREES = 2000;

// Whether or not to display extra visuals for debugging.
private boolean debug = false;

ToxiclibsSupport gfx;

private Path path;
private Tree[] trees = new Tree[NUM_TREES];


void setup() {
  size(680, 480);
/*  size(1920, 1355);*/
  smooth();
  noCursor();
  ellipseMode(CENTER);
  
  gfx = new ToxiclibsSupport(this);
  
  path = new Path();
  placeTrees();
}

void draw() {
  background(GRASS_COLOR);
  
  // Draw the path
  path.draw(gfx, debug);
  
  // Draw all the trees
  for (int i=0; i<trees.length; i++) {
    trees[i].draw();
  }
}

/**
 * Toggle the debug display by hitting the spacebar.
 */
void keyPressed() {
  if (key == ' ') debug = ! debug;
}


/**
 * Place trees randomly around the grounds.
 */
private void placeTrees() {
  // TODO: Keep the trees off the path.
  // TODO: Keep the trees off each other.
  for (int i=0; i<trees.length; i++) {
    trees[i] = new Tree(random(WORLD_WIDTH), random(WORLD_HEIGHT));
  }
}

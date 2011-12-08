import toxi.processing.*;


/*private static final int WORLD_WIDTH = 7200;*/
private static final int WORLD_WIDTH = 720;
/*private static final int WORLD_HEIGHT = 4800;*/
private static final int WORLD_HEIGHT = 480;

private static final color GRASS_COLOR = #017f16;
private static final int NUM_TREES = 20;

private int timeOfLastPerson;

// Whether or not to display extra visuals for debugging.
private boolean debug = false;

ToxiclibsSupport gfx;

private Path path;
private Tree[] trees = new Tree[NUM_TREES];
private ArrayList<Person> people;


void setup() {
  size(720, 480);
/*  size(1920, 1355);*/
  smooth();
  noCursor();
  ellipseMode(CENTER);
  
  gfx = new ToxiclibsSupport(this);
  
  path = new Path();
  placeTrees();
  
  people = new ArrayList();
  addPerson();
}

void draw() {
  background(GRASS_COLOR);
  
  // Draw the path
  path.draw(gfx, debug);
  
  // Draw all the trees
  for (int i=0; i<trees.length; i++) {
    trees[i].draw();
  }
  
  // Update and draw each person.
  ArrayList<Person> personReapList = new ArrayList();
  for (Person person : people) {
    person.avoid(people);
    person.follow(path);
    person.update();
    if (person.getPosition().x+15 < 0 || person.getPosition().x-15 > width) {
      // Mark for removal if off the canvas.
      personReapList.add(person);
    } else {
      person.draw(gfx, debug);
    }
  }
  // Remove all people who have been marked.
  for (Person person : personReapList) {
    people.remove(person);
  }
  
  // Potentially create a new person
  if (random(millis()-timeOfLastPerson) > 10000) {
    addPerson();
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

/**
 * Add a new person at one end or the other of the path.
 */
private void addPerson() {
  if (random(1) < 0.5) {
    // Start the person at the left end of the path.
    people.add(new Person(new Vec2D(0, 380), random(2), +1));
  } else {
    // Start the person at the right end of the path.
    people.add(new Person(new Vec2D(width, 90), random(2), -1));
  }
  timeOfLastPerson = millis();
}

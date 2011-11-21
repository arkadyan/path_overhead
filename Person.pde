class Person {
  
  import toxi.geom.*;
  import toxi.processing.*;
  
  
  static private final color PERSON_COLOR = #dc982c;
  static private final int BODY_LENGTH = 20;
  static private final int BODY_WIDTH = 50;
  static private final int HEAD_LENGTH = 30;
  static private final int HEAD_WIDTH = 20;
  
  private Vec2D postion;
  private Vec2D velocity;
  private Vec2D acceleration;
  
  
  Person(Vec2D pos) {
    postion = pos.copy();
    velocity = new Vec2D(0, 0);
    acceleration = new Vec2D(0, 0);
  }
}

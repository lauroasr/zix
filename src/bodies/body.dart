part of zix;

class Body extends Sprite {
  Vector2D position;
  Vector2D velocity;
  Vector2D acceleration;

  num angle;
  num angularSpeed;
  num angularAcceleration;

  bool fixed;
  bool visible;

  num mass;
  num coefficientOfRestitution;
  num coefficientOfFriction;
  num momentOfInertia;

  void applyForce(Vector2D force, {Vector2D point}) {
    if (point != null) {
      angularAcceleration = point.cross(force) / momentOfInertia;
    }

    force.divideBy(mass);
    acceleration.addBy(force);
  }

  Body();

  Body.byOther(Body other) {
    position = new Vector2D.byOther(other.position);
    velocity = new Vector2D.byOther(other.velocity);
    acceleration = new Vector2D.byOther(other.acceleration);
    angle = other.angle;
    angularSpeed = other.angularSpeed;
    fixed = other.fixed;
    visible = other.visible;
    mass = other.mass;
    coefficientOfRestitution = other.coefficientOfRestitution;
    coefficientOfFriction = other.coefficientOfFriction;
    momentOfInertia = other.momentOfInertia;
  }

  Vector2D farthestHullPoint(Vector2D direction) => null;
  Vector2D farthestCorePoint(Vector2D direction, num margin) => null;
  AABB aabb({num angle}) => null;
}
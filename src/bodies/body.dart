part of zix;

abstract class Body {
  Vector2D position;
  Vector2D velocity;
  Vector2D acceleration;

  double angle;
  double angularSpeed;
  double angularAcceleration;

  bool fixed;
  bool hidden;

  double mass;
  double coefficientOfRestitution;
  double coefficientOfFriction;
  double momentOfInertia;

  Body({this.position, this.velocity,
        this.acceleration, this.angle,
        this.angularSpeed, this.angularAcceleration,
        this.fixed, this.hidden, this.mass,
        this.coefficientOfRestitution,
        this.coefficientOfFriction,
        this.momentOfInertia
  });

  void applyForce(Vector2D force, {Vector2D point}) {
    if (point != null) {
      angularAcceleration = point.cross(force) / momentOfInertia;
    }

    force.divideBy(mass);
    acceleration.addBy(force);
  }

  AABB aabb({num angle});
  Vector2D farthestHullPoint(Vector2D direction);
  //Vector2D farthestCorePoint(Vector2D direction);
}
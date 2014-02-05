part of zix;

class CircleBody extends Body {
  double radius;

  AABB aabb({num angle}) {
    return new AABB(-radius, -radius, radius, radius);
  }

  Vector2D farthestHullPoint(Vector2D direction) {
    // @optimize : instance
    return direction.normalized() * radius;
  }

  Vector2D farthestCorePoint(Vector2D direction, num margin) {
    // @optimize : instance
    return direction.normalized() * (radius - margin);
  }
}
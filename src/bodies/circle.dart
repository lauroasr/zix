part of zix;

class Circle extends Body {
  double radius;

  AABB aabb({num angle}) {
    return new AABB(-radius, -radius, radius, radius);
  }

  Vector2D farthestHullPoint(Vector2D direction, {num margin}) {
    return direction * radius;
  }
}
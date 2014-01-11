part of zix;

class AABB {
  Vector2D position;
  num halfWidth;
  num halfHeight;

  AABB(minX, minY, maxX, maxY) {
    position = new Vector2D((maxX + minX) * 0.5, (maxY + minY) * 0.5);
    halfWidth = (maxX - minX) * 0.5;
    halfHeight = (maxY - minY) * 0.5;
  }

  bool contains(Vector2D point) {
    return (point.x > position.x - halfWidth) &&
           (point.x < position.x + halfWidth) &&
           (point.y > position.y - halfHeight) &&
           (point.y < position.y + halfHeight);
  }

  void transform(Transform t) {
    Vector2D bottomRight = new Vector2D(halfWidth, halfHeight);
    Vector2D topRight = new Vector2D(halfWidth, -halfHeight);

    position.addBy(t.translation);
    bottomRight.rotateByTransform(t);
    topRight.rotateByTransform(t);

    halfWidth = max(bottomRight.x.abs(), topRight.x.abs());
    halfHeight = max(bottomRight.y.abs(), topRight.y.abs());
  }
}
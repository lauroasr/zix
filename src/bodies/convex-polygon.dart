part of zix;

class ConvexPolygon extends Body {
  List<Vector2D> vertices;

  static bool isConvex(List<Vector2D> hull) {
    if (hull.length == 0) return false;
    if (hull.length <= 3) return true;

    Vector2D previous = hull.first - hull.last,
             current = hull[2] - hull[1];
    bool sign = previous.cross(current) > 0;

    for (int i = 3, hullLength = hull.length; i <= hullLength; i++) {
      current = hull[i % hullLength] - hull[(i - 1) % hullLength];

      if (sign != previous.cross(current) > 0) return false;

      previous = current;
    }

    return true;
  }

  static num momentOfIntertia(List<Vector2D> hull) {
    if (hull.length < 2) return 0;

    if (hull.length == 2) {
      return hull.last.lengthSquaredTo(hull.first);
    }

    Vector2D previous = hull.first, current;

    double cross, deno = 0.0, total = 0.0;
    for (int i = 0, hullLength = hull.length; i < hullLength; i++) {
      current = hull[i];
      cross = current.cross(previous);
      total += cross * (current.lengthSquared()
          + current.dot(previous) + previous.lengthSquared());

      deno += cross;

      previous = current;
    }

    return total / (6 * deno);
  }

  void setVertices(List<Vector2D> hull) {

  }
}
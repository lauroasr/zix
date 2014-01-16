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
  
  static bool isPointInside(Vector2D point, List<Vector2D> hull) {
    if (hull.length == 1) return point.equals(hull.first);
    if (hull.length == 2) {
      return PI == (point.angleBetween(hull.first) + point.angleBetween(hull.last)).abs();       
    }
    
    double angle = 0.0;
    Vector2D last = hull.first - point, current;
    for (int i = 2, hullLength = hull.length; i <= hullLength; i++) {
      current = hull[i % hullLength] - point;
      angle += current.angleBetween(last);
      last = current;
    }
    
    return angle.abs() > 1e-6;
  }
  
  static num areaOf(List<Vector2D> hull) {
    if (hull.length < 3) return 0;
    
    num area = 0;
    Vector2D last = hull.last;
    for (int i = 0, hullLength = hull.length; i < hullLength; ++i) {
      area += last.cross(hull[i]);
      last = hull[i];
    }
    area /= 2;
    return area;
  }
  
  static Vector2D centroidOf(List<Vector2D> hull) {
    if (hull.length == 1) return hull.first;
    
    if (hull.length == 2) {
      Vector2D center = hull.first + hull.last;
      center.divideBy(2);
      return center;
    }
    
    Vector2D last = new Vector2D.byOther(hull.last), cent = new Vector2D();
    for (int i = 0, hullLength = hull.length; i < hullLength; ++i) {
      num cross = last.cross(hull[i]);
      last.addBy(hull[i]);
      last.multiplyBy(cross);
      
      cent.addBy(last);
      last = hull[i];
    }
    cent.divideBy(6 * areaOf(hull));
    return cent;
  }
  
  void setVertices(List<Vector2D> hull) {
    if (!isConvex(hull)) 
      throw new ArgumentError('hull needs to be convex.');
    
    Vector2D polygonCentroid = centroidOf(hull);
    polygonCentroid.negate();
    
    for (int i = 0, hullLength = hull.length; i < hullLength; i++) {
      vertices.add(hull[i] + polygonCentroid);
    }
  }
  
  Vector2D farthestHullPoint(Vector2D direction) {
    int vertsLength = vertices.length;
    
    if (vertsLength == 1) return vertices.first;
    
    num prev = vertices[0].dot(direction),
        curr = vertices[1].dot(direction);
        
    if (vertsLength == 2) {
      if (curr < prev) 
        return vertices.first;
      return vertices.last;
    }
    
    if (curr >= prev) {
      int i;
      for (i = 2; i < vertsLength && curr >= prev; i++) {
        prev = curr;
        curr = vertices[i].dot(direction);
      }
      
      if (curr >= prev) i++;      
      return vertices[i - 2];
    }
    
    int i;
    for (i = vertsLength - 1; i > 1 && prev >= curr; i--) {
      curr = prev;
      prev = vertices[i].dot(direction);
    }
    
    return vertices[(i + 1) % vertsLength];
  }
  
  // can optimize! (instances)
  AABB aabb({num angle: 0}) {
    Vector2D xAxis = new Vector2D.byAngle(-angle),
             yAxis = new Vector2D.byAngle(-(angle + PI / 2));
    num maxX = farthestHullPoint(xAxis).projection(xAxis),
        minX = farthestHullPoint(xAxis.negative()).projection(xAxis),
        maxY = farthestHullPoint(yAxis).projection(yAxis),
        minY = farthestHullPoint(yAxis.negative()).projection(yAxis);
    
    return new AABB(minX, minY, maxX, maxY);
  }
  
  
}
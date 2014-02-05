part of zix;

class GJK {
  static final num ACCURACY = 0.0001;
  static final num MAX_ITERATIONS = 100;

  /**
   * Get the next search direction from two simples points
   */
  static Vector2D nextSearchDirection(Vector2D pointA, Vector2D pointB) {
    num abDotB = pointB.lengthSquared() - pointB.dot(pointA);
    num abDotA = pointB.dot(pointA) - pointA.lengthSquared();

    if (abDotB < 0) {
      return pointB.negative();
    } else if (abDotA > 0) {
      return pointA.negative();
    } else {
      Vector2D direction = pointB - pointA;
      bool clockwise = pointA.cross(direction) < 0;
      return direction.perpendicular(clockwise: clockwise);
    }
  }

  /**
   * Figure out the closest points on the original objects
   * from the last two entries of the simplex
   */
  static Map closestPoints(List<Map> simplex) {
    int simplexLength = simplex.length;
    Map lastSimplex = simplex[simplexLength - 2],
        previousSimplex = simplex[simplexLength - 3];
    Vector2D a = lastSimplex['pt'],
             l = previousSimplex['pt'] - a;

    if (l.equals(Vector2D.ZERO)) {
      return {
        'a': lastSimplex['a'],
        'b': lastSimplex['b']
      };
    }

    num lambdaB = -l.dot(a) / l.lengthSquared(),
        lambdaA = 1 - lambdaB;

    if (lambdaA <= 0) {
      return {
        'a': previousSimplex['a'],
        'b': previousSimplex['b']
      };
    } else if (lambdaB <= 0) {
      return {
        'a': lastSimplex['a'],
        'b': lastSimplex['b']
      };
    }

    return {
      'a': (lastSimplex['a'] * lambdaA) + (previousSimplex['a'] * lambdaB),
      'b': (lastSimplex['b'] * lambdaA) + (previousSimplex['b'] * lambdaB)
    };
  }

  /**
   * Implementation agnostic GJK function
   */
  static Map gjk(Map support(Vector2D d), Vector2D seed, {bool checkOverlapOnly: false, Function debug}) {
    Vector2D direction = seed;
    if (direction == null) {
      direction = new Vector2D(1, 0);
    }

    Map minkDifference = support(direction);
    List<Map> simplex = [];
    simplex.add(minkDifference);
    direction.negate();

    Vector2D current = minkDifference['pt'], last;
    bool overlap = false, noOverlap = false;
    num distance = null, i;

    for (i = 0;; i++) {
      last = current;
      minkDifference = support(direction);
      simplex.add(minkDifference);
      current = minkDifference['pt'];

      // may take it out
      if (debug != null) {
        debug(simplex);
      }

      if (current.equals(Vector2D.ZERO)) {
        overlap = true;
        break;
      }

      if (!noOverlap && current.dot(direction) <= 0) {
        if (checkOverlapOnly) break;
        noOverlap = true;
      }

      if (simplex.length == 2) {
        direction = nextSearchDirection(current, last);
      } else if (noOverlap) {
        direction.normalize();
        num lastDot = last.dot(direction);

        if ((lastDot - current.dot(direction)).abs() < ACCURACY) {
          distance = -lastDot;
          break;
        }

        if (last.lengthSquared() < simplex[0]['pt'].lengthSquared()) {
          simplex.removeAt(0);
        } else {
          simplex.removeAt(1);
        }

        direction = nextSearchDirection(simplex[1]['pt'], simplex[0]['pt']);
      } else {
        Vector2D ab = last - current,
                 ac = simplex.first['pt'] - current;

        bool sign = ab.cross(ac) > 0;
        if (sign != (current.cross(ab) > 0)) {
          simplex.removeAt(0);

          direction = ab.perpendicular(clockwise: sign);
        } else if (sign != (ac.cross(current) > 0)) {
          simplex.removeAt(1);

          direction = ac.perpendicular(clockwise: !sign);
        } else {
          overlap = true;
          break;
        }
      }

      if (i > MAX_ITERATIONS) {
        return {
          'simplex': simplex,
          'iterations': i,
          'distance': 0,
          'maxIterationsReached': true
        };
      }
    }

    Map data = {
      'overlap': overlap,
      'simplex': simplex,
      'iterations': i,
      'maxIterationsReached': false
    };

    if (distance != null) {
      data['distance'] = distance;
      data['closest'] = closestPoints(simplex);
    }

    return data;
  }
}
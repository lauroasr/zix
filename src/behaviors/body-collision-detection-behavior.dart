part of zix;

class BodyCollisionDetectionBehavior extends Behavior {
  World world;
  bool useCheckAll = false;

  // @temp
  Function a;
  Function b;

  BodyCollisionDetectionBehavior({this.useCheckAll}) {
    BodyCollisionDetectionBehavior self = this;
    a = (Map data) {
      self.checkAll(data);
    };
    b = (Map data) {
      self.check(data);
    };
  }

  void connectToWorld(World world) {
    this.world = world;

    world.addEvent('body-collisions');

    if (useCheckAll) {
      world.events['velocity-integration'].addListener(a);
    } else {
      world.events['collisions-candidates'].addListener(b);
    }
  }

  void disconnectFromWorld() {
    if (useCheckAll) {
      world.events['velocity-integration'].removeListener(a);
    } else {
      world.events['collisions-candidates'].removeListener(b);
    }
  }

  Function _support(Body bodyA, Body bodyB, Map information) {
    return (Vector2D searchDirection) {
      Vector2D pointA, pointB;

      // @optimize : not use transform
      Transform transA = new Transform(translation: bodyA.position, angle: bodyA.angle),
                transB = new Transform(translation: bodyB.position, angle: bodyB.angle);


      Vector2D dirA = new Vector2D.byOther(searchDirection),
               dirB = new Vector2D.byOther(searchDirection);

      // @optimize : instance (would probably increase code size)
      dirA.rotateInverseByTransform(transA);
      dirB.rotateInverseByTransform(transB);
      dirB.negate();

      if (information['useCore']) {
        pointA = bodyA.farthestCorePoint(dirA, information['marginA']);
        pointB = bodyB.farthestCorePoint(dirB, information['marginB']);
      } else {
        pointA = bodyA.farthestHullPoint(dirA);
        pointB = bodyA.farthestHullPoint(dirB);
      }

      pointA.applyTransform(transA);
      pointB.applyTransform(transB);

      // @understand wtf?
      searchDirection.negate();
      searchDirection.rotateByTransform(transB);

      return {
        'a' : pointA,
        'b' : pointB,
        'pt' : pointA - pointB
      };
    };
  }

  Map checkGJK(Body bodyA, Body bodyB) {
    Map info = {
      'marginA': 0,
      'marginB': 0,
      'useCore': false
    };
    Function support = _support(bodyA, bodyB, info);
    Vector2D distance = bodyA.position - bodyB.position;
    Map result = GJK.gjk(support, distance, checkOverlapOnly: true);

    if (!result['overlap']) return null;

    info['marginA'] = 0; // not required
    info['marginB'] = 0; // not required
    info['useCore'] = true;

    AABB aabb = bodyA.aabb();
    num dimA = min(aabb.halfWidth, aabb.halfHeight);
    aabb = bodyB.aabb();
    num dimB = min(aabb.halfWidth, aabb.halfHeight);

    while (result['overlap'] && (info['marginA'] < dimA || info['marginB'] < dimB)) {
      if (info['marginA'] < dimA) info['marginA']++;
      if (info['marginB'] < dimB) info['marginB']++;

      result = GJK.gjk(support, distance);
    }
    if (result['overlap'] || result['maxIterationsReached']) {
      return null;
    }

    // @optimize : instance
    Vector2D norm = (result['closest']['b'] - result['closest']['a']).normalized();
    num overlap = max(0, (info['marginA'] + info['marginB']) - result['distance']);

    return {
      'bodyA': bodyA,
      'bodyB': bodyB,
      'overlap': overlap,
      'norm': norm,
      // @optimize : instance
      'mtv': distance * overlap,
      // @check : margin was probably not used anywhere else
      'pos': norm * info['margin'] + result['closest']['a'] - bodyA.position
    };
  }

  Map checkCircles(CircleBody bodyA, CircleBody bodyB) {
    Vector2D distance = bodyB.position - bodyA.position;

    num overlap = distance.length() - (bodyA.radius + bodyB.radius);
    if (distance.equals(Vector2D.ZERO)) distance.set(1, 0);

    if (overlap > 0) return null;

    // @optimize : instance
    return {
      'bodyA': bodyA,
      'bodyB': bodyB,
      'norm': distance.normalized(),
      'mtv': distance * -overlap,
      'pos': distance.normalized() * bodyA.radius
    };
  }

  Map checkPair(Body bodyA, Body bodyB) {
    if (bodyA is CircleBody && bodyB is CircleBody)
      return checkCircles(bodyA, bodyB);

    return checkGJK(bodyA, bodyB);
  }

  void check(Map data) {
    List<Map> candidates = data['candidates'];
    List<Map> collisionsData = [];

    for (int i = 0, length = candidates.length; i < length; i++) {
      Map<String, Body> pair = candidates[i];
      Map collisionData = checkPair(pair['bodyA'], pair['bodyB']);

      if (collisionData != null) {
        collisionsData.add(collisionData);
      }
    }

    if (collisionsData.length > 0) {
      world.events['body-collisions'].fire(eventData: {
        'collisionsData': collisionsData
      });
    }
  }

  void checkAll(Map data) {
    List<Body> bodies = data['bodies'];
    List<Map> collisionsData = [];

    for (int i = 0, length = bodies.length; i < length; i++) {
      Body bodyA = bodies[i];

      for (int j = i + 1; j < length; j++) {
        Body bodyB = bodies[j];
        if (bodyA.fixed && bodyB.fixed) continue;

        Map collisionData = checkPair(bodyA, bodyB);
        if (collisionData != null) {
          collisionsData.add(collisionData);
        }
      }
    }

    if (collisionsData.length > 0) {
      world.events['body-collisions'].fire(eventData: {
        'collisionsData': collisionsData
      });
    }
  }
}
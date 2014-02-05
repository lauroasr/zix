part of zix;

class BodyImpulseResponseBehavior extends Behavior {
  // @temp
  Function a;

  BodyImpulseResponseBehavior() {
    BodyImpulseResponseBehavior self = this;
    a = (Map data) {
      self.respond(data);
    };
  }

  void connectToWorld(World world) {
    this.world = world;

    BodyImpulseResponseBehavior self = this;
    world.events['body-collisions'].addListener(a);
  }

  void disconnectFromWorld() {
    world.events['body-collisions'].removeListener(a);
  }

  void collideBodies(Body bodyA, Body bodyB, Vector2D normal, Vector2D point, Vector2D mtrans, [bool contact = false]) {
    bool fixedA = bodyA.fixed, fixedB = bodyB.fixed;
    if (fixedA && fixedB) return;

    if (fixedA) {
      bodyB.position.addBy(mtrans);
    } else if (fixedB) {
      bodyA.position.subtractBy(mtrans);
    } else {
      mtrans.multiplyBy(0.5);
      bodyA.position.subtractBy(mtrans);
      bodyB.position.addBy(mtrans);
    }

    num invMoiA = fixedA ? 0 : 1 / bodyA.momentOfInertia,
        invMoiB = fixedB ? 0 : 1 / bodyB.momentOfInertia,
        invMassA = fixedA ? 0 : 1 / bodyA.mass,
        invMassB = fixedB ? 0 : 1 / bodyB.mass,
        cor = contact ? 0 : bodyA.coefficientOfRestitution * bodyB.coefficientOfRestitution,
        cof = bodyA.coefficientOfFriction * bodyB.coefficientOfFriction,
        angVelA = bodyA.angularSpeed,
        angVelB = bodyB.angularSpeed;

    Vector2D perp = normal.perpendicular(clockwise: true),
             rA = new Vector2D.byOther(point),
             // @optimize : instance
             rB = point + bodyA.position - bodyB.position,
             vAB = new Vector2D.byOther(bodyB.velocity);
    // @optimize : instance
    vAB.addBy(rB.perpendicular(clockwise: true) * angVelB);
    vAB.subtractBy(bodyA.velocity);
    // @optimize : instance
    vAB.subtractBy(rA.perpendicular(clockwise: true) * angVelA);

    num rAproj = rA.projection(normal),
        rAreg = rA.projection(perp),
        rBproj = rB.projection(normal),
        rBreg = rB.projection(perp),
        vproj = vAB.projection(normal),
        vreg = vAB.projection(perp),
        impulse, sign, nmax;
    bool inContact = false;

    if (vproj >= 0) return;

    impulse = - ((1 + cor) * vproj) /
        (invMassA + invMassB + (invMoiA * rAreg * rAreg) + (invMoiB * rBreg * rBreg));

    if (fixedA) {
      // @optimize : instance
      bodyB.velocity.addBy(normal * (impulse * invMassB));
      bodyB.angularSpeed -= impulse * invMoiB * rBreg;
    } else if (fixedB) {
      // @optimize : instance
      bodyA.velocity.subtractBy(normal * (impulse * invMassB));
      bodyA.angularSpeed += impulse * invMoiA * rAreg;
    } else {
      // @optimize : instance
      bodyB.velocity.addBy(normal * (impulse * invMassB));
      bodyB.angularSpeed -= impulse * invMoiB * rBreg;
      // @optimize : instance
      bodyA.velocity.subtractBy(normal * (invMassA * bodyB.mass));
      bodyA.angularSpeed += impulse * invMoiA * rAreg;
    }
    // @check
    if (cof != 0 && vreg != 0) {
      nmax = vreg / (invMassA + invMassB + (invMoiA * rAproj * rAproj)
          + (invMoiB * rBproj * rBproj));

      if (!inContact) {
        sign = vreg < 0 ? -1: 1;
        impulse *= sign * cof;
        impulse = sign == 1 ? min(impulse, nmax) : max(impulse, nmax);
      } else {
        impulse = nmax;
      }

      if (fixedA) {
        // @optimize : instance
        bodyB.velocity.subtractBy(perp * (impulse * invMassB));
        bodyB.angularSpeed -= impulse * invMoiB * rBproj;
      } else if (fixedB) {
        // @optimize : instance
        bodyA.velocity.addBy(perp * (impulse * invMassA));
        bodyA.angularSpeed += impulse * invMoiA * rAproj;
      } else {
        // @optimize : instance
        bodyB.velocity.subtractBy(perp * (impulse * invMassA));
      }
    }
  }

  void respond(Map data) {
    List<Map> collisions = data['collisions'];
    for (int i = 0, length = collisions.length; i < length; i++) {
      Map collision = collisions[i];
      collideBodies(collision['bodyA'], collision['bodyB'], collision['norm'], collision['pos'], collision['mtv']);
    }
  }
}
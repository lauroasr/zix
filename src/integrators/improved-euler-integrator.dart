part of zix;

class ImprovedEulerIntegrator extends Integrator {
  List<Body> oldBodiesState;

  void integrateVelocities(int deltaTime) {

    for (int i = 0, length = bodies.length; i < length; i++) {
      if (bodies[i].fixed) continue;

      Body body = bodies[i],
           oldBodyState = oldBodiesState[i];

      oldBodyState.velocity.copy(body.velocity);
      oldBodyState.acceleration.copy(body.acceleration);
      // @moved
      oldBodyState.angularSpeed = body.angularSpeed;

      body.acceleration.multiplyBy(deltaTime);
      body.velocity.addBy(body.acceleration);
      body.angularSpeed += body.angularAcceleration * deltaTime;

      // @add : drag

      // @understand @moved
      body.acceleration.set(0, 0);
      // @understand
      body.angularAcceleration = 0;
    }
  }

  void integratePositions(int deltaTime) {
    num halfDeltaTimeSquared = deltaTime * deltaTime * 0.5;

    for (int i = 0, length = bodies.length; i < length; i++) {
      if (bodies[i].fixed) continue;

      Body body = bodies[i],
           oldBodyState = oldBodiesState[i];

      oldBodyState.position.copy(body.position);
      // @moved
      oldBodyState.angle = body.angle;

      // @optimize : instance
      body.position.addBy(oldBodyState.velocity * deltaTime);
      // @optimize : instance
      body.position.addBy(oldBodyState.acceleration * halfDeltaTimeSquared);
      body.angle += oldBodyState.angularSpeed
          * deltaTime + oldBodyState.angularAcceleration * halfDeltaTimeSquared;

      // @understand
      oldBodyState.acceleration.set(0, 0);
      // @understand
      oldBodyState.angularAcceleration = 0;
    }
  }

  // Need to be called everytime bodies.length is changed
  void updateOldBodiesState() {
    if (bodies.length > oldBodiesState.length) {
      for (int i = oldBodiesState.length; i < bodies.length; i++) {
        oldBodiesState.add(new Body.byOther(bodies[i]));
      }
    } else if (bodies.length < oldBodiesState.length) {
      oldBodiesState.length = bodies.length;
    }
  }
}
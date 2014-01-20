part of zix;

class VerletIntegrator extends Integrator {
  List<Body> oldBodiesState;

  void integrateVelocities(int deltaTime) {
    int deltaTimeSquared = deltaTime * deltaTime;

    for (int i = 0, length = bodies.length; i < length; i++) {
      if (bodies[i].fixed) continue;

      Body body = bodies[i],
           oldBodyState = oldBodiesState[i];

      // @understand : if velocity didn't change
      if (body.velocity.equals(oldBodyState.velocity)) {
        body.velocity.copy(body.position);
        body.velocity.subtractBy(oldBodyState.position);
      } else {
        oldBodyState.position.copy(body.position);
        oldBodyState.position.subtractBy(body.velocity);

        body.velocity.multiplyBy(deltaTime);
      }

      // @add : drag

      // @optimize : instance
      body.velocity.addBy(body.acceleration * deltaTimeSquared);
      body.velocity.multiplyBy(1 / deltaTime);
      oldBodyState.velocity.copy(body.velocity);

      // @understand : if angularSpeed didn't change
      if (body.angularSpeed == oldBodyState.angularSpeed) {
        body.angularSpeed = body.angle - oldBodyState.angle;
      } else {
        oldBodyState.angle = body.angle - body.angularSpeed;
        body.angularSpeed *= deltaTime;
      }

      body.angularSpeed += body.angularAcceleration * deltaTimeSquared;
      body.angularSpeed /= deltaTime;
      oldBodyState.angularSpeed = body.angularSpeed;

      // @understand @moved
      body.acceleration.set(0, 0);
      // @undestand
      body.angularAcceleration = 0;
    }
  }

  void integratePositions(int deltaTime) {

    for (int i = 0, length = bodies.length; i < length; i++) {
      if (bodies[i].fixed) continue;

      Body body = bodies[i],
           oldBodyState = oldBodiesState[i];

      body.velocity.multiplyBy(deltaTime);

      oldBodyState.position.copy(body.position);
      body.position.addBy(body.velocity);
      body.velocity.multiplyBy(1 / deltaTime);
      oldBodyState.velocity.copy(body.velocity);

      body.angularSpeed *= deltaTime;
      oldBodyState.angle = body.angle;
      body.angle += body.angularSpeed;
      body.angularSpeed /= deltaTime;
      oldBodyState.angularSpeed = body.angularSpeed;
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
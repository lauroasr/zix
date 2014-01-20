part of zix;

abstract class Integrator {
  List<Body> bodies;

  void integrateVelocities(int deltaTime);
  void integratePositions(int deltaTime);
}
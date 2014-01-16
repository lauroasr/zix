part of zix;

abstract class Integrator {
  List<Body> bodies;
  
  
  void integrateVelocity(int timestep);
  void integratePosition(int timestep);
  
  
  
  void integrate(List<Body> bodies, int timestep) {
    
  }
  
  
}
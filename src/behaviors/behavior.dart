part of zix;

abstract class Behavior {
  World world;

  void connectToWorld(World world);
  void disconnectFromWorld();
}
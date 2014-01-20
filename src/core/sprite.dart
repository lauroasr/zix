part of zix;

class Sprite {
  Vector2D position;
  num angle;
  ImageData view;
  bool visible;

  Sprite({this.position, this.angle, this.view});
}
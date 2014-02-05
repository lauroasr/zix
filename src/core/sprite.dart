part of zix;

class Sprite {
  Vector2D position;
  num angle;
  ImageElement view;
  bool visible;

  Sprite({this.position, this.angle: 0.0, this.view, this.visible: true});
}
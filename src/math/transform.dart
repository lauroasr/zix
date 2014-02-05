part of zix;

class Transform {
  Vector2D translation;
  Vector2D rotationOrigin;
  num angleCos, angleSin;

  Transform({this.translation, this.rotationOrigin, num angle}) {
    if (angle != null) setRotation(angle);
  }

  void setRotation(num angle, {Vector2D origin}) {
    if (origin != null) {
      rotationOrigin = origin;
    } else {
      rotationOrigin = Vector2D.ZERO;
    }

    angleCos = cos(angle);
    angleSin = sin(angle);
  }
}
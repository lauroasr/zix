part of zix;

class Transform {
  Vector2D translation;
  Vector2D rotationOrigin;
  num angleCos, angleSin;

  Transform(this.translation, this.rotationOrigin, num angle) {
    setRotation(angle);
  }

  void setRotation(num angle) {
    angleCos = cos(angle);
    angleSin = sin(angle);
  }
}
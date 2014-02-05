part of zix;

abstract class Renderer {
  num width;
  num height;
  List<Sprite> sprites;
  List<Sprite> repeatableSprites;

  void render();
}
part of zix;

class CanvasRenderer extends Renderer {
  CanvasElement element;
  CanvasRenderingContext2D context;

  CanvasRenderer({num width, num height}) {
    this.width = width != null ? width : window.innerWidth;
    this.height = height != null ? height : window.innerHeight - 5;

    element = new CanvasElement(width: this.width, height: this.height);
    context = element.context2D;
    document.body.append(element);
  }

  void render() {
    /*for (int i = 0, length = repeatableSprites.length; i < length; i++) {
      Sprite sprite = repeatableSprites[i];
      if (!sprite.visible) continue;

      /*
       * implement repeatable sprites
       *
       * to make the sprite easier to rotate
       * is to think that the sprite itself is not rotated
       * but the canvas is...
       * so you need to know if that particular repetition of the sprite
       * is inside the bounds of the rotated canvas.
       */
    }*/

    for (int i = 0, length = sprites.length; i < length; i++) {
      Sprite sprite = sprites[i];
      if (!sprite.visible) continue;

      context..save()
             ..translate(sprite.position.x, sprite.position.y)
             ..rotate(sprite.angle)
             ..drawImage(sprite.view, 0, 0)
             ..restore();
    }
  }

  void renderAt(Vector2D position) {
    for (int i = 0, length = sprites.length; i < length; i++) {
      sprites[i].position.subtractBy(position);
    }
    render();
    for (int i = 0, length = sprites.length; i < length; i++) {
      sprites[i].position.addBy(position);
    }
  }

  void resize(num width, num height) {
    this.width = width;
    this.height = height;
    element.width = width;
    element.height = height;
  }

  ImageElement frame() {
    return new ImageElement(src: element.toDataUrl());
  }
}
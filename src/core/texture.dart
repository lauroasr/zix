part of zix;

class Texture {
  static final CanvasElement canvas = hiddenCanvasElement();
  static final CanvasRenderingContext2D context = canvas.context2D;
  static CanvasElement hiddenCanvasElement() {
    CanvasElement canvas = new CanvasElement();
    document.body.append(canvas);
    canvas.style.display = 'none';
    return canvas;
  }

  static ImageData imageDataFrom(ImageElement iE) {
    // imageElement must be loaded
    canvas.width = iE.width;
    canvas.height = iE.height;
    context.drawImage(iE, 0, 0);
    return context.getImageData(0, 0, iE.width - 1, iE.height - 1);
  }

  static void blackAndWhite(ImageData img) {
    List<int> data = img.data;

    for (int i = 0, length = data.length; i < length; i += 4) {
      int average = (data[i + 0] + data[i + 1] + data[i + 2]) ~/ 3;
      data[i + 0] = average;
      data[i + 1] = average;
      data[i + 2] = average;
    }
  }

  static ImageData circleView(num radius, {String color: '#000', num borderWidth}) {
  }
}
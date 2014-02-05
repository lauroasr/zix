part of zix;

class ImageHandler {
  static final CanvasElement canvas = hiddenCanvasElement();
  static final CanvasRenderingContext2D context = canvas.context2D;
  static CanvasElement hiddenCanvasElement() {
    CanvasElement canvas = new CanvasElement();
    document.body.append(canvas);
    canvas.style.display = 'none';
    return canvas;
  }

  static ImageData imageDataFrom(ImageElement ie) {
    //context.clearRect(0, 0, canvas.width, canvas.height);

    // imageElement must be loaded
    canvas.width = ie.width;
    canvas.height = ie.height;
    context.drawImage(ie, 0, 0);
    return context.getImageData(0, 0, ie.width - 1, ie.height - 1);
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

  static ImageElement circleView(num radius, {String color: '#000', num borderWidth: 0, String borderColor: '#000', bool fill: true}) {
    //context.clearRect(0, 0, canvas.width, canvas.height);

    canvas.width = radius * 2 + borderWidth * 2;
    canvas.height = radius * 2 + borderWidth * 2;

    if (fill) {
      context..beginPath()
             ..arc(radius + borderWidth, radius + borderWidth, radius, 0, PI * 2)
             ..fillStyle = color
             ..fill();
    }

    if (borderWidth > 0) {
      context..beginPath()
             ..arc(radius + borderWidth, radius + borderWidth, radius + borderWidth / 2, 0, PI * 2)
             ..lineWidth = borderWidth
             ..strokeStyle = borderColor
             ..stroke();
    }

    return new ImageElement(src: canvas.toDataUrl());
  }

  // @implement : border
  static ImageElement polygonView(List<Vector2D> vertices, {String color: '#000', num borderWidth: 0, String borderColor: '#000', bool fill: true}) {
    //context.clearRect(0, 0, canvas.width, canvas.height);

    num width = vertices.first.x, height = vertices.first.y;
    for (int i = 1, length = vertices.length; i < length; i++) {
      if (width < vertices[i].x) width = vertices[i].x;
      if (height < vertices[i].y) height = vertices[i].y;
    }
    canvas.width = width + borderWidth * 2;
    canvas.height = height + borderWidth * 2;

    context.beginPath();
    context.moveTo(vertices.first.x + borderWidth, vertices.first.y + borderWidth);
    for (int i = 1, length = vertices.length; i < length; i++) {
      context.lineTo(vertices[i].x + borderWidth / 2, vertices[i].y + borderWidth / 2);
    }
    context.closePath();

    if (fill) {
      context.fillStyle = color;
      context.fill();
    }

    if (borderWidth > 0) {
      context.lineWidth = borderWidth;
      context.strokeStyle = borderColor;
      context.stroke();
    }
    return new ImageElement(src: canvas.toDataUrl());
  }

  static ImageElement imageScaledFrom(ImageElement ie, num width, num height) {
    canvas.width = width;
    canvas.height = height;

    context.clearRect(0, 0, canvas.width, canvas.height);
    context.drawImageScaled(ie, 0, 0, width, height);
    return new ImageElement(src: canvas.toDataUrl());
  }
}
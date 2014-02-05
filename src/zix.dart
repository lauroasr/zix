library zix;

// dart
import 'dart:core';
import 'dart:math';
import 'dart:html';
import 'dart:async';

// math
part 'math/vector.dart';
part 'math/transform.dart';
part 'math/gjk.dart';
part 'math/aabb.dart';

// bodies
part 'bodies/body.dart';
part 'bodies/circle-body.dart';
part 'bodies/convex-polygon-body.dart';

// integrators
part 'integrators/integrator.dart';
part 'integrators/improved-euler-integrator.dart';
part 'integrators/verlet-integrator.dart';

// core
part 'core/event.dart';
part 'core/time-event.dart';
part 'core/image-handler.dart';
part 'core/sprite.dart';
part 'core/interactivity.dart';
part 'core/world.dart';

// renderers
part 'renderers/renderer.dart';
part 'renderers/canvas-renderer.dart';

// behaviors
part 'behaviors/behavior.dart';
part 'behaviors/body-collision-detection-behavior.dart';
part 'behaviors/body-impulse-response-behavior.dart';

toRadians(num degrees) => degrees * PI / 180;


class Zix {

}

num seconds = 0, minutes = 0;
printTime(num) {
  print('$minutes:$seconds');
  seconds++;

  if (seconds == 60) {
    seconds = 0;
    minutes++;
  }
}

num now() => new DateTime.now().millisecondsSinceEpoch;

void main() {
  World world = new World();

  TimeEvent te = new TimeEvent(1000, now());
  world.onRendering.addListener((e) {
    te.update(now(), te.interval);
  });
  te.addListener(printTime);

  // start the loop
  window.requestAnimationFrame((num time) {
    world.main(time);
  });

}
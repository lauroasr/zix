library zix;

import 'dart:core';
import 'dart:math';
//import 'dart:html';
import 'dart:async';

// math
part 'math/vector.dart';
part 'math/transform.dart';
part 'math/gjk.dart';
part 'math/aabb.dart';

// bodies
part 'bodies/body.dart';
part 'bodies/circle.dart';
part 'bodies/convex-polygon.dart';

// integrators
part 'integrators/integrator.dart';

/*
Timer t = new Timer.periodic(new Duration(seconds: 5), (Timer t) {
  print('5 seconds ${(new DateTime.now()).millisecondsSinceEpoch}');
});
*/

class Zix {

}

void main() {
  var a = new Vector2D(1, 0);
  a.rotate(PI / 2);
  print(a);
  
  a.set(1, 0);
  a.rotateInverse(-PI / 2);
  print(a);
}
library zix;

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
part 'bodies/circle.dart';
part 'bodies/convex-polygon.dart';

/*
Timer t = new Timer.periodic(new Duration(seconds: 5), (Timer t) {
  print('5 seconds ${(new DateTime.now()).millisecondsSinceEpoch}');
});
*/

class Zix {

}
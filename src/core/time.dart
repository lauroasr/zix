part of zix;

class ManualTimer {
  int interval;
  Function callback;
  int lastCallbackTime;
  
  ManualTimer({this.interval, this.callback});
  
  void start(int time) {
    lastCallbackTime = time;
    callback();
  }
  
  void update(int time) {
    if (time >= lastCallbackTime + interval) {
      lastCallbackTime = time;
      callback();
    }
  }
}


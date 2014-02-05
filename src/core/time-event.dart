part of zix;

class TimeEvent extends Event {
  num interval;
  num time;

  void update(num currentTime, dynamic data) {
    if (currentTime >= interval + time) {
      time = currentTime;
      fire(eventData: data);
    }
  }

  TimeEvent(this.interval, this.time);
}
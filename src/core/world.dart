part of zix;

class World {
  final Map<String, Event> events = new Map<String, Event>();
  final Event onRendering = new Event();

  void addEvent(String eventName, {Event event}) {
    if (event == null) {
      event = new Event();
    }
    events[eventName] = event;
  }

  void removeEvent(String eventName) {
    if (!events.containsKey(eventName)) {
      throw new ArgumentError('Event not found');
    }
    events.remove(eventName);
  }

  void main(num time) {
    onRendering.fire(eventData: time);

    window.requestAnimationFrame((num time) {
      main(time);
    });
  }
}
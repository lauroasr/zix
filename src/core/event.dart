part of zix;

class Event {
  final List<Function> _permanentListeners = new List<Function>();
  final List<Function> _temporaryListeners = new List<Function>();

  void addListener(Function listener, {bool removeAfterFirstCall: false}) {
    if (removeAfterFirstCall) {
      _temporaryListeners.add(listener);
    } else {
      _permanentListeners.add(listener);
    }
  }

  void removeListener(Function listener) {
    bool wasRemoved = _permanentListeners.remove(listener);
    if (wasRemoved) return;

    wasRemoved = _temporaryListeners.remove(listener);
    if (!wasRemoved) {
      throw new ArgumentError('Listener not found.');
    }
  }

  void fire({dynamic eventData}) {
    for (int i = 0, length = _permanentListeners.length; i < length; i++) {
      _permanentListeners[i](eventData);
    }
    for (int i = 0, length = _temporaryListeners.length; i < length; i++) {
      _temporaryListeners[i](eventData);
    }
    _temporaryListeners.clear();
  }
}
import 'dart:async';

class Debouncer {
  Debouncer({required this.milliseconds});

  final int milliseconds;

  Timer? _timer;

  Completer<void>? _completer;

  Future<void> get completerFuture => _completer?.future ?? Future.value();

  bool get isCompleted => _completer?.isCompleted ?? true;

  void run(void Function() action) {
    if (isCompleted) _completer = Completer();
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), () {
      action();
      if (!isCompleted) _completer?.complete();
    });
  }

  void dispose() {
    _timer?.cancel();
    if (!isCompleted) {
      _completer?.complete();
    }
  }
}

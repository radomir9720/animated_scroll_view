import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:meta/meta.dart';

/// {@template default_event_controller}
/// {@macro event_controller}
///
/// The default implementation of [EventController]
/// {@endtemplate}
class DefaultEventController<T> extends EventController<T> {
  /// {@macro default_event_controller}
  DefaultEventController() : controller = StreamController.broadcast();

  /// [ModificationEvent]'s stream controller.
  @protected
  @nonVirtual
  @visibleForTesting
  final StreamController<ModificationEvent<T>> controller;

  @override
  @nonVirtual
  StreamSubscription<ModificationEvent<T>> listen(
    void Function(ModificationEvent<T> event)? onData, {
    Function? onError,
    bool? cancelOnError,
    void Function()? onDone,
  }) {
    return controller.stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }

  @override
  @nonVirtual
  Stream<ModificationEvent<T>> asBroadcastStream({
    void Function(
      StreamSubscription<ModificationEvent<T>> subscription,
    )? onListen,
    void Function(
      StreamSubscription<ModificationEvent<T>> subscription,
    )? onCancel,
  }) {
    return controller.stream.asBroadcastStream(
      onListen: onListen,
      onCancel: onCancel,
    );
  }

  @override
  @nonVirtual
  void add(ModificationEvent<T> data) {
    if (controller.isClosed) return;

    controller.add(data);
  }

  /// Whether the controller is closed for adding more events.
  ///
  /// See [StreamController.isClosed] for more info.
  @nonVirtual
  bool get isClosed {
    return controller.isClosed;
  }

  @override
  @nonVirtual
  bool get isBroadcast {
    return controller.stream.isBroadcast;
  }

  @override
  void close() {
    controller.close();
  }
}

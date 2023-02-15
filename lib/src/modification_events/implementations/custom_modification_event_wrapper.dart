import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

class CustomModificationWrapper<T> extends ModificationEvent<T> {
  CustomModificationWrapper({required this.onExecute});

  @protected
  @visibleForTesting
  final Future<void> Function(
    TickerProvider vsync,
    Sink<AnimationEntity> animationSink,
    ItemsNotifier<T> itemsNotifier,
    EventController<T> eventController,
  ) onExecute;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required Sink<AnimationEntity> animationSink,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
  }) {
    return onExecute(
      vsync,
      animationSink,
      itemsNotifier,
      eventController,
    );
  }
}

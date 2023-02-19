import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

class CustomModificationWrapper<T> extends ModificationEvent<T> {
  CustomModificationWrapper({required this.onExecute});

  @protected
  @visibleForTesting
  final Future<void> Function(
    TickerProvider vsync,
    ItemsNotifier<T> itemsNotifier,
    EventController<T> eventController,
    ItemsAnimationController itemsAnimationController,
  ) onExecute;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
  }) {
    return onExecute(
      vsync,
      itemsNotifier,
      eventController,
      itemsAnimationController,
    );
  }
}

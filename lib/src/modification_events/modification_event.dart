import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';

/// {@template modification_event}
/// Base class of modification event.
/// Its descendants should contain modification information.
/// (i.e. move/add/remove some item of type [T] in/to/from items list)
/// {@endtemplate}
abstract class ModificationEvent<T> {
  ModificationEvent();

  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required Sink<AnimationEntity> animationSink,
    required EventController<T> eventController,
  });
}

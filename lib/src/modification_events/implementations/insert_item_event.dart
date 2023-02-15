import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

class InsertItemEvent<T> extends ModificationEvent<T>
    with AnimationControllerMixin {
  InsertItemEvent({
    this.index,
    required this.item,
    this.animationConfig = const AnimationControllerConfig(initialValue: 0),
    this.forceNotify = false,
  });

  @protected
  @visibleForTesting
  final int? index;

  @protected
  @visibleForTesting
  final T item;

  @protected
  @visibleForTesting
  final AnimationControllerConfig animationConfig;

  final bool forceNotify;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required Sink<AnimationEntity> animationSink,
    required EventController<T> eventController,
  }) async {
    final _index = index ?? itemsNotifier.value.length;
    final itemId = itemsNotifier.idMapper(item);

    itemsNotifier
      ..addQueuedAnimation(
        itemId,
        QueuedAnimation<AnimationController>(
          createAnimationCallback: (vsync) {
            return getAnimation(
              vsync,
              config: animationConfig,
            );
          },
          runCallback: (animation) => animation.forward(),
          disposeCallback: (animation) => animation.dispose(),
        ),
      )
      ..insert(_index, item, forceNotify: forceNotify);
  }
}

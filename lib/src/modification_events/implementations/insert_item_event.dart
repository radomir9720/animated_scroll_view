import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

class InsertItemEvent<T> extends ModificationEvent<T>
    with AnimationControllerMixin, CheckInsertIndexIsValidMixin {
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
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
  }) async {
    final _index = index ?? itemsNotifier.value.length;

    throwIfIndexIsInvalid(itemsNotifier, _index);

    final itemId = itemsNotifier.idMapper(item);

    itemsAnimationController.cachedAnimationValue[itemId] =
        animationConfig.lowerBound;

    final delayedAnimation = DelayedInMemoryAnimation<AnimationController>(
      createAnimationCallback: (vsync) {
        return getAnimation(
          vsync,
          config: animationConfig,
        );
      },
      runCallback: (animation) => animation.forward(),
      disposeCallback: (animation) {
        itemsAnimationController.cachedAnimationValue[itemId] =
            animationConfig.uppedBound;

        animation
          ..stop()
          ..dispose();
      },
    );

    itemsAnimationController.inMemoryAnimationMap[itemId] = delayedAnimation;

    itemsNotifier.insert(_index, item, forceNotify: forceNotify);
  }
}

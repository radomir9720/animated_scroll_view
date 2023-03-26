import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:animated_scroll_view/src/models/modification.dart';
import 'package:flutter/animation.dart';

/// Mixin, which keeps common item deletion logic
///
/// Uses also [AnimationControllerMixin]
mixin RemoveItemEventAnimationMixin<T> on AnimationControllerMixin<T> {
  /// Instantiates an animation, runs it, and disposes on execution end
  T generateRemoveAnimation({
    required AnimationControllerConfig removeAnimationConfig,
    required ItemsAnimationController itemsAnimationController,
    required ItemsNotifier<T> itemsNotifier,
    required String itemId,
    bool forceNotify = false,
  }) {
    final modificationId = Modification.remove.interpolate(itemId);

    itemsAnimationController.cachedAnimationValue[modificationId] =
        removeAnimationConfig.uppedBound;

    final delayedAnimation = DelayedInMemoryAnimation<AnimationController>(
      createAnimationCallback: (vsync) {
        return getAnimation(
          vsync,
          config: removeAnimationConfig,
        );
      },
      runCallback: (animation) {
        itemsAnimationController.cachedAnimationValue[modificationId] =
            removeAnimationConfig.lowerBound;
        return animation.reverse();
      },
      disposeCallback: (animation) {
        animation
          ..stop()
          ..dispose();
        itemsNotifier.removeById(itemId, forceNotify: forceNotify);
      },
    );

    itemsAnimationController.inMemoryAnimationMap[modificationId] =
        delayedAnimation;

    return itemsNotifier.markRemovedById(
      itemId,
      modificationId: modificationId,
    );
  }
}

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';

mixin RemoveItemEventAnimationMixin<T> on AnimationControllerMixin {
  Future<void> runRemoveAnimation({
    required TickerProvider vsync,
    required AnimationControllerConfig removeAnimationConfig,
    required ItemsAnimationController itemsAnimationController,
    required String itemId,
    void Function()? onAnimationEnd,
  }) async {
    final animationController = getAnimation(
      vsync,
      config: removeAnimationConfig,
    );

    itemsAnimationController.add(
      AnimationEntity(
        itemId: itemId,
        animation: animationController,
      ),
    );

    return animationController.reverse().then(
      (value) {
        itemsAnimationController.cachedAnimationValue[itemId] =
            removeAnimationConfig.lowerBound;

        dispose();
        onAnimationEnd?.call();
      },
    );
  }
}

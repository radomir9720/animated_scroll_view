import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';

mixin RemoveItemEventAnimationMixin<T> {
  AnimationController getAnimation(
    TickerProvider vsync, {
    AnimationControllerConfig config = const AnimationControllerConfig(),
  });

  void dispose();

  Future<void> runRemoveAnimation({
    required TickerProvider vsync,
    required AnimationControllerConfig removeAnimationConfig,
    required Sink<AnimationEntity> animationSink,
    required String itemId,
    void Function()? onAnimationEnd,
  }) async {
    final animationController = getAnimation(
      vsync,
      config: removeAnimationConfig,
    );

    animationSink.add(
      AnimationEntity(
        itemId: itemId,
        animation: animationController,
      ),
    );

    return animationController.reverse().then(
      (value) {
        dispose();
        onAnimationEnd?.call();
      },
    );
  }
}

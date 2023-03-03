import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

mixin AnimationControllerMixin<T> on ModificationEvent<T> {
  AnimationController? _animation;

  AnimationController getAnimation(
    TickerProvider vsync, {
    AnimationControllerConfig config = const AnimationControllerConfig(),
  }) {
    return _animation ??= AnimationController(
      vsync: vsync,
      value: config.initialValue,
      duration: config.duration,
      lowerBound: config.lowerBound,
      upperBound: config.uppedBound,
      animationBehavior: config.behavior,
      reverseDuration: config.reverseDuration,
    );
  }

  void dispose() {
    _animation
      ?..stop()
      ..dispose();
    _animation = null;
  }
}

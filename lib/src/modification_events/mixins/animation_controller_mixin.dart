import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/widgets.dart';

/// Mixin, which helps with creation and disposing of an [AnimationController]
mixin AnimationControllerMixin<T> on ModificationEvent<T> {
  AnimationController? _animation;

  /// Instantiates(if wasn't previously) an [AnimationController] and returns
  /// it. If an [AnimationController] was instantiated, returns that instance.
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

  /// Stops and disposes instansiated previously [AnimationController].
  /// If [AnimationController] was not instantiated, does nothing.
  void dispose() {
    _animation
      ?..stop()
      ..dispose();
    _animation = null;
  }
}

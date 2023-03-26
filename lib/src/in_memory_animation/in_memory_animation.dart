import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';

/// {@template in_memory_animation}
/// Animation, which is meant to be executed later, when
/// certain conditions are met.
/// {@endtemplate}
abstract class InMemoryAnimation<A extends DoubleAnimation> {
  /// An animation of type `Animation<double>`
  A? get animation;

  /// Method, which should be called to init the animation.
  A init(TickerProvider vsync);

  /// Method, wich runs the animation
  ///
  /// Be sure to init the animation by calling [init()] method,
  /// before run, otherwise the [AnimationNotInstantiatedException] will
  /// be thrown
  Future<void> run();

  /// Disposes the animation
  void dispose();
}

/// {@template animation_not_instantiated_exception}
/// Exception, which is thrown when [InMemoryAnimation.run] is
/// called before [InMemoryAnimation.init]
/// {@endtemplate}
class AnimationNotInstantiatedException extends AnimatedScrollViewException {
  /// {@macro animation_not_instantiated_exception}
  const AnimationNotInstantiatedException()
      : super('init() should be called first!');
}

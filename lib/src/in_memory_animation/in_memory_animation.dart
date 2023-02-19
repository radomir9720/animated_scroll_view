import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';

abstract class InMemoryAnimation<A extends DoubleAnimation> {
  A? get animation;

  A init(TickerProvider vsync);

  Future<void> run();

  void dispose();
}

class AnimationNotInstantiatedException extends AnimatedScrollViewException {
  const AnimationNotInstantiatedException()
      : super('init() should be called first!');
}

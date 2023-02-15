import 'package:animated_scroll_view/src/exceptions/animated_scroll_view_exception.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

class AnimationNotInstantiatedException extends AnimatedScrollViewException {
  const AnimationNotInstantiatedException()
      : super('QueuedAnimation().initAnimation() should be called first!');
}

class QueuedAnimation<A extends Animation<double>> {
  QueuedAnimation({
    required this.createAnimationCallback,
    required this.runCallback,
    required this.disposeCallback,
  });

  A? _animation;

  @protected
  final A Function(TickerProvider vsync) createAnimationCallback;

  @protected
  final Future<void> Function(A animation) runCallback;

  @protected
  final void Function(A animation) disposeCallback;

  A get animation {
    final a = _animation;

    if (a == null) throw const AnimationNotInstantiatedException();

    return a;
  }

  A initAnimation(TickerProvider vsync) {
    return _animation ??= createAnimationCallback(vsync);
  }

  Future<void> runAnimation() {
    return runCallback(animation);
  }

  void dispose() {
    disposeCallback(animation);
    _animation = null;
  }
}

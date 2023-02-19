import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

class DelayedInMemoryAnimation<A extends DoubleAnimation>
    implements InMemoryAnimation<A> {
  DelayedInMemoryAnimation({
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

  @override
  A? get animation => _animation;

  @override
  A init(TickerProvider vsync) {
    return _animation ??= createAnimationCallback(vsync);
  }

  @override
  Future<void> run() {
    final a = animation;
    if (a == null) throw const AnimationNotInstantiatedException();
    return runCallback(a);
  }

  @override
  void dispose() {
    final a = _animation;
    if (a == null) return;
    disposeCallback(a);
    _animation = null;
  }
}

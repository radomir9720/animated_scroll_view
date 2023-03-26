import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template delayed_in_memory_animation}
/// {@macro in_memory_animation}
///
/// Implementation of [InMemoryAnimation]
/// {@endtemplate}
class DelayedInMemoryAnimation<A extends DoubleAnimation>
    implements InMemoryAnimation<A> {
  /// {@macro delayed_in_memory_animation}
  DelayedInMemoryAnimation({
    required this.runCallback,
    required this.disposeCallback,
    required this.createAnimationCallback,
  });

  A? _animation;

  /// Callback, which is called when animation should be created.
  /// Passes a [TickerProvider], and expects an instance of animation as result.
  @protected
  final A Function(TickerProvider vsync) createAnimationCallback;

  /// Callback, which is called when animation should start its execution.
  /// Provides created earlier animation for running it
  @protected
  final Future<void> Function(A animation) runCallback;

  /// Callback, which is called when animation is no longer needed.
  /// Provides created earlier animation fir disposing it.
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

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template static_in_memory_animation}
/// {@macro in_memory_animation}
///
/// This implementation of [InMemoryAnimation] provides a static animation(value
/// of which is never changed). It uses for this purpose
/// [AlwaysStoppedAnimation].
/// {@endtemplate}
class StaticInMemoryAnimation
    implements InMemoryAnimation<AlwaysStoppedAnimation<double>> {
  /// {@macro static_in_memory_animation}
  const StaticInMemoryAnimation(this.value);

  /// Value, which is provided to [AlwaysStoppedAnimation].
  @protected
  final double value;

  @override
  AlwaysStoppedAnimation<double> get animation => AlwaysStoppedAnimation(value);

  @override
  void dispose() {}

  @override
  AlwaysStoppedAnimation<double> init(TickerProvider vsync) {
    return AlwaysStoppedAnimation(value);
  }

  @override
  Future<void> run() async {}
}

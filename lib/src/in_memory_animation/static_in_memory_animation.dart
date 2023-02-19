import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

class StaticInMemoryAnimation
    implements InMemoryAnimation<AlwaysStoppedAnimation<double>> {
  const StaticInMemoryAnimation(this.value);

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

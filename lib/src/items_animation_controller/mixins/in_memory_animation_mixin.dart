import 'package:animated_scroll_view/animated_scroll_view.dart';

/// Mixin, that implements [ItemsAnimationController.inMemoryAnimationMap]
/// getter
mixin InMemoryAnimationMixin<A extends DoubleAnimation>
    on ItemsAnimationController<A> {
  final _inMemoryAnimationMap = <String, InMemoryAnimation<A>>{};

  @override
  Map<String, InMemoryAnimation<A>> get inMemoryAnimationMap =>
      _inMemoryAnimationMap;
}

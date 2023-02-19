import 'package:animated_scroll_view/animated_scroll_view.dart';

abstract class ItemsAnimationController<A extends DoubleAnimation>
    extends Stream<AnimationEntity> implements Sink<AnimationEntity> {
  Map<String, double> get cachedAnimationValue;

  Map<String, InMemoryAnimation<A>> get inMemoryAnimationMap;
}

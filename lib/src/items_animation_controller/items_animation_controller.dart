import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:animated_scroll_view/src/widgets/animated_item/animated_item_widget.dart';

/// {@template items_animation_controller}
/// Controller, which manages items animations.
/// {@endtemplate}
abstract class ItemsAnimationController<A extends DoubleAnimation>
    extends Stream<AnimationEntity> implements Sink<AnimationEntity> {
  /// Used as initial animation value.
  /// The main idea: on widget build to check if there is a cached animation
  /// value in this map, and if there is one - provide an
  /// `AlwaysStoppedAnimation` with this cached value.
  ///
  /// It is ecpected to use item id(from [IDMapper]) as the key.
  ///
  /// For more info see [AnimatedItemWidget].
  Map<String, double> get cachedAnimationValue;

  /// Map with animations, which are waiting for execution.
  /// The main idea is to wait for the widget's build, and after that run the
  /// animation. After animation run, it is expected to delete the animation
  /// from the map.
  ///
  /// It is ecpected to use item id(from [IDMapper]) as the key.
  ///
  /// For more info see [AnimatedItemWidget].
  Map<String, InMemoryAnimation<A>> get inMemoryAnimationMap;
}

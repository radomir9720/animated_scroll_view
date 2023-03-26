import 'package:animated_scroll_view/animated_scroll_view.dart';

/// {@template remove_and_insert_animation_configs}
/// Model that contains animation settings both for remove and insert events.
///
/// See also [AnimationControllerConfig]
/// {@endtemplate}
class RemoveAndInsertAnimationConfigs {
  /// Creates a [RemoveAndInsertAnimationConfigs]
  const RemoveAndInsertAnimationConfigs({
    this.remove = const AnimationControllerConfig(),
    this.insert = const AnimationControllerConfig(initialValue: 0),
  });

  /// Animations settings for remove event
  final AnimationControllerConfig remove;

  /// Animation settings for insert event
  final AnimationControllerConfig insert;
}

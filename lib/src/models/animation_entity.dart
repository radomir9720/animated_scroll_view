import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

/// Model, which contains the [animation], and [itemId](id of the item
/// for which this animation is intended).
@immutable
class AnimationEntity<A extends DoubleAnimation> {
  /// Creates an [AnimationEntity]
  const AnimationEntity({required this.itemId, required this.animation});

  /// The item's id
  final String itemId;

  /// Animation
  final A animation;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnimationEntity<A> &&
        other.itemId == itemId &&
        other.animation == animation;
  }

  @override
  int get hashCode => itemId.hashCode ^ animation.hashCode;
}

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

@immutable
class AnimationEntity<A extends DoubleAnimation> {
  const AnimationEntity({required this.itemId, required this.animation});

  final String itemId;
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

import 'package:animated_scroll_view/src/queued_animation/queued_animation.dart';

mixin QueuedAnimationMixin {
  final Map<String, QueuedAnimation> _queuedAnimationMap = {};

  Map<String, QueuedAnimation> get queuedAnimationMap => _queuedAnimationMap;

  void addQueuedAnimation(String itemId, QueuedAnimation queuedAnimation) {
    _queuedAnimationMap[itemId] = queuedAnimation;
  }

  QueuedAnimation? popQueuedAnimation(String itemId) {
    return _queuedAnimationMap.remove(itemId);
  }
}

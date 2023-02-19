import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:animated_scroll_view/src/items_animation_controller/mixins/cached_animation_value_mixin.dart';
import 'package:animated_scroll_view/src/items_animation_controller/mixins/in_memory_animation_mixin.dart';
import 'package:meta/meta.dart';

class DefaultItemsAnimationController extends ItemsAnimationController
    with CachedAnimationValueMixin, InMemoryAnimationMixin {
  DefaultItemsAnimationController() : controller = StreamController.broadcast();

  @protected
  @nonVirtual
  @visibleForTesting
  final StreamController<AnimationEntity<DoubleAnimation>> controller;

  @override
  void add(AnimationEntity<DoubleAnimation> data) {
    controller.add(data);
  }

  @override
  void close() {
    controller.close();
  }

  @override
  StreamSubscription<AnimationEntity<DoubleAnimation>> listen(
    void Function(AnimationEntity<DoubleAnimation> event)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    return controller.stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }
}

import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:meta/meta.dart';

/// {@template default_items_animation_controller}
/// {@macro items_animation_controller}
///
/// The default implementation of [ItemsAnimationController]
/// {@endtemplate}
class DefaultItemsAnimationController extends ItemsAnimationController
    with CachedAnimationValueMixin, InMemoryAnimationMixin {
  /// {@macro default_items_animation_controller}
  DefaultItemsAnimationController() : controller = StreamController.broadcast();

  /// Stream controller, used for animations, that should be played immediately.
  /// It is intended that animation will be played only if the widget,
  /// this animation is for, is mounted. If the widget is unmounted,
  /// animation won't be executed, and, the animation **WON'T be cached**
  /// to execute it later, when the widget is built.
  ///
  /// For these purposes see [cachedAnimationValue] and [inMemoryAnimationMap].
  ///
  /// See also [AnimationEntity]
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
    bool? cancelOnError,
    void Function()? onDone,
  }) {
    return controller.stream.listen(
      onData,
      onDone: onDone,
      onError: onError,
      cancelOnError: cancelOnError,
    );
  }
}

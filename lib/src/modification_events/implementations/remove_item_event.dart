import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template remove_item_event}
/// Implements remove logic of the [item]. Manages remove animation.
///
/// Descendant of [ModificationEventWithItemAndItemIdConstructors].
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [InsertAllItemsEvent]
///  * [InsertInfluencedItemEvent]
///  * [InsertAdaptiveItemEvent]
///  * [RemoveInfluencedItemEvent]
///  * [RemoveAdaptiveItemEvent]
///  * [MoveItemEvent]
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class RemoveItemEvent<T>
    extends ModificationEventWithItemAndItemIdConstructors<T>
    with AnimationControllerMixin, RemoveItemEventAnimationMixin {
  /// Creates a [RemoveItemEvent] using an [item] instance.
  RemoveItemEvent({
    required T item,
    this.animationConfig = const AnimationControllerConfig(),
    this.forceNotify = false,
  }) : super(item);

  /// Creates a [RemoveItemEvent] using an item's id
  RemoveItemEvent.byId({
    required String itemId,
    this.animationConfig = const AnimationControllerConfig(),
    this.forceNotify = false,
  }) : super.byId(itemId);

  /// {@template remove_item_event.force_notify}
  /// Whether should [ItemsNotifier] notify its listeners immediately
  /// after removing the item, or delegate this task to the
  /// [ItemsNotifier] itself
  /// {@endtemplate}
  ///
  /// Defaults to `false`
  @protected
  @visibleForTesting
  final bool forceNotify;

  /// The animation settings, item should be removed with
  @protected
  @visibleForTesting
  final AnimationControllerConfig animationConfig;

  @override
  Future<void> execute({
    required ItemsNotifier<T> itemsNotifier,
    required TickerProvider vsync,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    required Type scrollViewType,
  }) async {
    final itemId = getItemId(itemsNotifier.idMapper);

    generateRemoveAnimation(
      itemId: itemId,
      forceNotify: forceNotify,
      itemsNotifier: itemsNotifier,
      removeAnimationConfig: animationConfig,
      itemsAnimationController: itemsAnimationController,
      // onAnimationEnd: () => itemsNotifier.removeById(itemId),
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [RemoveItemEvent]
extension RemoveItemEventExtension<T> on EventController<T> {
  /// Adds a [RemoveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(RemoveItemEvent(...))
  /// ```
  void remove({
    required T item,
    AnimationControllerConfig animationConfig =
        const AnimationControllerConfig(),
    bool forceNotify = false,
  }) {
    return add(
      RemoveItemEvent(
        item: item,
        animationConfig: animationConfig,
        forceNotify: forceNotify,
      ),
    );
  }

  /// Adds a [RemoveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(RemoveItemEvent.byId(...))
  /// ```
  void removeById({
    required String itemId,
    AnimationControllerConfig animationConfig =
        const AnimationControllerConfig(),
    bool forceNotify = false,
  }) {
    return add(
      RemoveItemEvent.byId(
        itemId: itemId,
        animationConfig: animationConfig,
        forceNotify: forceNotify,
      ),
    );
  }
}

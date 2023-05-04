import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template remove_influenced_item_event}
/// {@macro remove_item_event}
///
/// Differs from [RemoveItemEvent] in that, in addition to removing the [item]
/// with animation, it also animates the items, that are affected by this
/// insertion.
///
/// Namely, it removes with animation all the items, index of which is greater
/// than or equal to the [item]'s index, and then inserts
/// (with animation, of course) them back, excluding [item].
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [InsertAllItemsEvent]
///  * [InsertInfluencedItemEvent]
///  * [InsertAdaptiveItemEvent]
///  * [RemoveItemEvent]
///  * [RemoveAdaptiveItemEvent]
///  * [MoveItemEvent]
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class RemoveInfluencedItemEvent<T>
    extends ModificationEventWithItemAndItemIdConstructors<T>
    with AnimationControllerMixin {
  /// Creates a [RemoveInfluencedItemEvent] using an [item] instance.
  RemoveInfluencedItemEvent({
    required T item,
    this.removeAnimationConfig = const AnimationControllerConfig(),
    this.insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    this.forceNotify = false,
  }) : super(item);

  /// Creates a [RemoveInfluencedItemEvent] using an item's id
  RemoveInfluencedItemEvent.byId({
    required String itemId,
    this.removeAnimationConfig = const AnimationControllerConfig(),
    this.insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    this.forceNotify = false,
  }) : super.byId(itemId);

  /// {@macro remove_item_event.force_notify}
  ///
  /// Defaults to `false`
  @protected
  @visibleForTesting
  final bool forceNotify;

  /// The animation settings, item should be removed with
  @protected
  @visibleForTesting
  final AnimationControllerConfig removeAnimationConfig;

  /// The animation settings, affected items should be inserted with
  @protected
  @visibleForTesting
  final AnimationControllerConfig insertInfluencedAnimationConfig;

  @override
  Future<void> execute({
    required ItemsNotifier<T> itemsNotifier,
    required TickerProvider vsync,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    required Type scrollViewType,
  }) async {
    final itemId = getItemId(itemsNotifier.idMapper);

    // getIndexById() will throw an Excception if the item with specified id
    // is not found, therefore code execution will stop, as intended.
    final currentIndex = itemsNotifier.getIndexById(itemId);

    final mounted = itemsNotifier.mountedWidgetsIndexRange;

    final influencedRange = IndexRange(
      start: currentIndex,
      end: itemsNotifier.actualList.length,
    );
    final intersection = mounted.getIntersection(influencedRange);

    final intersectionList = intersection == null
        ? <T>[]
        : itemsNotifier.actualList
            .sublist(intersection.start, intersection.end + 1);

    if (intersectionList.isNotEmpty) {
      final animation = getAnimation(
        vsync,
        config: removeAnimationConfig,
      );

      for (final item in intersectionList) {
        itemsAnimationController.add(
          AnimationEntity(
            itemId: itemsNotifier.idMapper(item),
            animation: animation,
          ),
        );
      }

      await animation.reverse();
    }

    final items = itemsNotifier.removeRangeInstantly(
      influencedRange.start,
      influencedRange.end,
    );

    eventController.add(
      InsertAllItemsEvent(
        index: influencedRange.start,
        forceVisible: true,
        items: items.sublist(1),
        forceNotify: forceNotify,
        animationConfig: insertInfluencedAnimationConfig,
      ),
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [RemoveInfluencedItemEvent]
extension RemoveInfluencedItemEventExtension<T> on EventController<T> {
  /// Adds a [RemoveInfluencedItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(RemoveInfluencedItemEvent(...))
  /// ```
  void removeInfluenced({
    required T item,
    AnimationControllerConfig removeAnimationConfig =
        const AnimationControllerConfig(),
    AnimationControllerConfig insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    bool forceNotify = false,
  }) {
    return add(
      RemoveInfluencedItemEvent(
        item: item,
        forceNotify: forceNotify,
        removeAnimationConfig: removeAnimationConfig,
        insertInfluencedAnimationConfig: insertInfluencedAnimationConfig,
      ),
    );
  }

  /// Adds a [RemoveInfluencedItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(RemoveInfluencedItemEvent.byId(...))
  /// ```
  void removeInfluencedById({
    required String itemId,
    AnimationControllerConfig removeAnimationConfig =
        const AnimationControllerConfig(),
    AnimationControllerConfig insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    bool forceNotify = false,
  }) {
    return add(
      RemoveInfluencedItemEvent.byId(
        itemId: itemId,
        forceNotify: forceNotify,
        removeAnimationConfig: removeAnimationConfig,
        insertInfluencedAnimationConfig: insertInfluencedAnimationConfig,
      ),
    );
  }
}

import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

/// {@template insert_influenced_item_event}
/// {@macro insert_item_event}
///
/// Differs from [InsertItemEvent] in that, in addition to inserting the [item]
/// to the list, it also animates the items, that are affected by this
/// insertion.
///
/// Namely, it removes with animation all the items, index of which is greater
/// than or equal to [index], and then inserts(with animation, of course)
/// them back, preceded by the [item]
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [InsertAllItemsEvent]
///  * [InsertAdaptiveItemEvent]
///  * [RemoveItemEvent]
///  * [RemoveInfluencedItemEvent]
///  * [RemoveAdaptiveItemEvent]
///  * [MoveItemEvent]
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class InsertInfluencedItemEvent<T> extends ModificationEvent<T>
    with AnimationControllerMixin, CheckInsertIndexIsValidMixin {
  /// Creates an [InsertInfluencedItemEvent]
  InsertInfluencedItemEvent({
    this.index,
    required this.item,
    this.forceNotify = false,
    this.removeInfluencedAnimationConfig = const AnimationControllerConfig(),
    this.insertAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
  });

  /// Index, at which [item] should be inserted
  @protected
  @visibleForTesting
  final int? index;

  /// The item, that should be inserted
  @protected
  @visibleForTesting
  final T item;

  /// The animation settings, item should be inserted with
  @protected
  @visibleForTesting
  final AnimationControllerConfig insertAnimationConfig;

  /// The animation settings, affected items should be removed with
  @protected
  @visibleForTesting
  final AnimationControllerConfig removeInfluencedAnimationConfig;

  /// {@macro insert_item_event.force_notify}
  ///
  /// Defaults to `false`
  @protected
  @visibleForTesting
  final bool forceNotify;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    required Type scrollViewType,
  }) async {
    final _index = index ?? itemsNotifier.value.length;

    throwIfIndexIsInvalid(itemsNotifier, _index);

    final mounted = itemsNotifier.mountedWidgetsIndexRange;

    final influencedRange = IndexRange(
      start: _index,
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
        config: removeInfluencedAnimationConfig,
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
        items: [item, ...items],
        forceNotify: forceNotify,
        animationConfig: insertAnimationConfig,
      ),
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [InsertInfluencedItemEvent]
extension InsertInfluencedItemEventExtension<T> on EventController<T> {
  /// Adds an [InsertInfluencedItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(InsertInfluencedItemEvent(...))
  /// ```
  void insertInfluenced({
    required T item,
    int? index,
    bool forceNotify = false,
    AnimationControllerConfig animationConfig =
        const AnimationControllerConfig(initialValue: 0),
    AnimationControllerConfig removeInfluencedAnimationConfig =
        const AnimationControllerConfig(),
  }) {
    return add(
      InsertInfluencedItemEvent(
        item: item,
        index: index,
        forceNotify: forceNotify,
        insertAnimationConfig: animationConfig,
        removeInfluencedAnimationConfig: removeInfluencedAnimationConfig,
      ),
    );
  }
}

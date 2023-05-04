import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';

import 'package:animated_scroll_view/src/models/modification.dart';
import 'package:flutter/widgets.dart';

/// {@template insert_all_items_event}
/// Implements insert logic of the [items]. Manages insert animation.
///
/// Descendant of [ModificationEvent].
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [InsertInfluencedItemEvent]
///  * [InsertAdaptiveItemEvent]
///  * [RemoveItemEvent]
///  * [RemoveInfluencedItemEvent]
///  * [RemoveAdaptiveItemEvent]
///  * [MoveItemEvent]
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class InsertAllItemsEvent<T> extends ModificationEvent<T>
    with AnimationControllerMixin, CheckInsertIndexIsValidMixin {
  /// Creates an [InsertAllItemsEvent]
  InsertAllItemsEvent({
    this.index,
    required this.items,
    this.forceNotify = false,
    this.forceVisible = false,
    this.animationConfig = const AnimationControllerConfig(initialValue: 0),
  });

  /// Index, at which [items] should be inserted
  @protected
  @visibleForTesting
  final int? index;

  /// The items, that should be inserted
  @protected
  @visibleForTesting
  final List<T> items;

  /// The animation settings, item should be inserted with
  @protected
  @visibleForTesting
  final AnimationControllerConfig animationConfig;

  /// {@macro insert_item_event.force_notify}
  ///
  /// Defaults to `false`
  @protected
  @visibleForTesting
  final bool forceNotify;

  /// {@macro items_entity.forceVisible}
  ///
  /// Defaults to `false`
  final bool forceVisible;

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

    final mountedRange = itemsNotifier.mountedWidgetsIndexRange;

    final insertRange = IndexRange(start: _index, end: _index + items.length);

    final intersectionRange = mountedRange.getIntersection(insertRange);

    final modified = [...itemsNotifier.actualList]..insertAll(_index, items);
    final intersectionList = intersectionRange == null
        ? <T>[]
        : modified.sublist(intersectionRange.start, intersectionRange.end + 1);
    final intersectionListIds = intersectionList.map(itemsNotifier.idMapper);
    final intersectionListModificationIds =
        intersectionListIds.map(Modification.insert.interpolate);

    for (final modificationId in intersectionListModificationIds) {
      itemsAnimationController.cachedAnimationValue[modificationId] =
          animationConfig.lowerBound;
    }

    final delayedAnimation = DelayedInMemoryAnimation<AnimationController>(
      createAnimationCallback: (vsync) {
        return getAnimation(vsync, config: animationConfig);
      },
      runCallback: (animation) {
        for (final modificationId in intersectionListModificationIds) {
          itemsAnimationController.cachedAnimationValue[modificationId] =
              animationConfig.uppedBound;
        }

        return animation.forward();
      },
      disposeCallback: (animation) {
        animation
          ..stop()
          ..dispose();
      },
    );

    for (final modificationId in intersectionListModificationIds) {
      itemsAnimationController.inMemoryAnimationMap[modificationId] =
          delayedAnimation;
    }

    itemsNotifier.insertAll(
      _index,
      items
          .map(
            (e) => MapEntry(
              e,
              Modification.insert.interpolate(itemsNotifier.idMapper(e)),
            ),
          )
          .toList(),
      forceVisible: forceVisible,
      forceNotify: forceNotify,
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [InsertAllItemsEvent]
extension InsertAllItemsEventExtension<T> on EventController<T> {
  /// Adds an [InsertAllItemsEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(InsertAllItemsEvent(...))
  /// ```
  void insertAll({
    required List<T> items,
    int? index,
    bool forceNotify = false,
    bool forceVisible = false,
    AnimationControllerConfig animationConfig =
        const AnimationControllerConfig(initialValue: 0),
  }) {
    return add(
      InsertAllItemsEvent(
        items: items,
        index: index,
        forceNotify: forceNotify,
        animationConfig: animationConfig,
        forceVisible: forceVisible,
      ),
    );
  }
}

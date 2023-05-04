import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template move_influenced_item_event}
/// {@macro move_item_event}
///
/// Differs from [MoveItemEvent] in that, in addition to moving the [item] with
/// animation, it also animates the items, that are affected by this
/// insertion.
///
/// Namely, it removes with animation all the items, index of which is between
/// the current index and the new index, and then
/// inserts(with animation, of course)
/// them back, preliminarily moving the [item] to the proper index.
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [InsertAllItemsEvent]
///  * [InsertInfluencedItemEvent]
///  * [InsertAdaptiveItemEvent]
///  * [RemoveItemEvent]
///  * [RemoveInfluencedItemEvent]
///  * [RemoveAdaptiveItemEvent]
///  * [MoveItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class MoveInfluencedItemEvent<T>
    extends ModificationEventWithItemAndItemIdConstructors<T>
    with AnimationControllerMixin, CheckInsertIndexIsValidMixin {
  /// Creates a [MoveInfluencedItemEvent] using an [item] instance.
  MoveInfluencedItemEvent({
    required T item,
    required this.newIndex,
    this.animateWhenIndexDidNotChanged = false,
    this.animationConfigsBuilder,
    this.forceNotify = false,
  }) : super(item);

  /// Creates a [MoveInfluencedItemEvent] using an item's id
  MoveInfluencedItemEvent.byId({
    required String itemId,
    required this.newIndex,
    this.animateWhenIndexDidNotChanged = false,
    this.animationConfigsBuilder,
    this.forceNotify = false,
  }) : super.byId(itemId);

  /// Index, at which item should be inserted
  @protected
  @visibleForTesting
  final int newIndex;

  /// Whether should animations be executed if the old index and new index are
  /// equal
  ///
  /// Defaults to `false`
  @protected
  @visibleForTesting
  final bool animateWhenIndexDidNotChanged;

  /// {@macro insert_item_event.force_notify}
  ///
  /// Defaults to `false`
  @protected
  @visibleForTesting
  final bool forceNotify;

  /// {@macro move_item_event.animation_configs_builder}
  ///
  /// Optional. if not specified, an instance of
  /// [RemoveAndInsertAnimationConfigs] is created using its default constructor
  @protected
  @visibleForTesting
  final AnimationConfigsBuilder? animationConfigsBuilder;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    required Type scrollViewType,
  }) async {
    final itemId = getItemId(itemsNotifier.idMapper);
    // getIndexById() will throw an Excception if the item with specified id
    // is not found, therefore code execution will stop, as intended.
    final currentIndex = itemsNotifier.getIndexById(itemId);

    if (currentIndex == newIndex && !animateWhenIndexDidNotChanged) {
      final newItem = item ?? itemsNotifier.actualList[currentIndex];
      if (newItem != null) {
        if (newItem != itemsNotifier.value[currentIndex]) {
          itemsNotifier
            ..markRemovedById(itemId)
            ..removeAt(currentIndex)
            ..insert(currentIndex, newItem);
        }
        return;
      }
      throw ItemNotFoundException(itemId);
    }

    final _newIndex = newIndex == itemsNotifier.actualList.length - 1
        ? newIndex
        : currentIndex < newIndex
            ? newIndex + 1
            : newIndex;

    throwIfIndexIsInvalid(itemsNotifier, _newIndex);

    final animationConfigs = animationConfigsBuilder?.call(currentIndex) ??
        const RemoveAndInsertAnimationConfigs();

    final mounted = itemsNotifier.mountedWidgetsIndexRange;

    final influencedRange = IndexRange(
      start: currentIndex < newIndex ? currentIndex : newIndex,
      end: newIndex > currentIndex ? newIndex : currentIndex,
    );
    final intersection = mounted.getIntersection(influencedRange);

    final removeAnimationConfig = animationConfigs.remove;

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
      influencedRange.end + 1,
    );

    eventController.add(
      InsertAllItemsEvent(
        index: influencedRange.start,
        forceVisible: true,
        items: items.length <= 1
            ? items
            : _newIndex < currentIndex
                ? items.moveLastToStart
                : items.moveFirstToEnd,
        forceNotify: forceNotify,
        animationConfig: animationConfigs.insert,
      ),
    );
  }
}

extension _MoveToExtension<T> on List<T> {
  List<T> get moveLastToStart {
    return [
      last,
      ...sublist(0, length - 1),
    ];
  }

  List<T> get moveFirstToEnd {
    return [
      ...sublist(1),
      first,
    ];
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [MoveInfluencedItemEvent]
extension MoveInfluencedItemEventExtension<T> on EventController<T> {
  /// Adds a [MoveInfluencedItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(MoveInfluencedItemEvent(...))
  /// ```
  void moveInfluenced({
    required T item,
    required int newIndex,
    bool forceNotify = false,
    bool animateWhenIndexDidNotChanged = false,
    AnimationConfigsBuilder? animationConfigsBuilder,
  }) {
    return add(
      MoveInfluencedItemEvent(
        item: item,
        newIndex: newIndex,
        forceNotify: forceNotify,
        animationConfigsBuilder: animationConfigsBuilder,
        animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
      ),
    );
  }

  /// Adds a [MoveInfluencedItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(MoveInfluencedItemEvent.byId(...))
  /// ```
  void moveInfluencedById({
    required String itemId,
    required int newIndex,
    bool forceNotify = false,
    bool animateWhenIndexDidNotChanged = false,
    AnimationConfigsBuilder? animationConfigsBuilder,
  }) {
    return add(
      MoveInfluencedItemEvent.byId(
        itemId: itemId,
        newIndex: newIndex,
        forceNotify: forceNotify,
        animationConfigsBuilder: animationConfigsBuilder,
        animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
      ),
    );
  }
}

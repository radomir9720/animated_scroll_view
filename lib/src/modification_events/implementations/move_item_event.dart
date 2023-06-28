import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template move_item_event.animation_configs_builder}
/// Callback, which builds a [RemoveAndInsertAnimationConfigs]
/// using given `currentIndex`
/// {@endtemplate}
typedef AnimationConfigsBuilder = RemoveAndInsertAnimationConfigs Function(
  int currentIndex,
);

/// {@template move_item_event}
/// Implements move logic of the [item]. Manages remove and insert animations.
///
/// Descendant of [ModificationEventWithItemAndItemIdConstructors].
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
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class MoveItemEvent<T> extends ModificationEventWithItemAndItemIdConstructors<T>
    with
        AnimationControllerMixin,
        CheckInsertIndexIsValidMixin,
        RemoveItemEventAnimationMixin {
  /// Creates a [MoveItemEvent] using an [item] instance.
  MoveItemEvent({
    required T item,
    required this.newIndex,
    this.animateWhenIndexDidNotChanged = false,
    this.animationConfigsBuilder,
    this.forceNotify = false,
  }) : super(item);

  /// Creates a [MoveItemEvent] using an item's id
  MoveItemEvent.byId({
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

    final visible = itemsNotifier.value.any((element) {
      return itemsNotifier.idMapper(element.value) == itemId;
    });

    final _newIndex =
        visible && currentIndex < newIndex ? newIndex + 1 : newIndex;

    throwIfIndexIsInvalid(itemsNotifier, _newIndex);

    final animationConfigs = animationConfigsBuilder?.call(currentIndex) ??
        const RemoveAndInsertAnimationConfigs();

    final current = visible
        ? generateRemoveAnimation(
            itemId: itemId,
            itemsNotifier: itemsNotifier,
            removeAnimationConfig: animationConfigs.remove,
            itemsAnimationController: itemsAnimationController,
          )
        : itemsNotifier.markRemovedById(itemId);

    eventController.add(
      InsertItemEvent(
        index: _newIndex,
        item: item ?? current,
        forceNotify: forceNotify,
        animationConfig: animationConfigs.insert,
      ),
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [MoveItemEvent]
extension MoveItemEventExtension<T> on EventController<T> {
  /// Adds a [MoveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(MoveItemEvent(...))
  /// ```
  void move({
    required T item,
    required int newIndex,
    bool forceNotify = false,
    bool animateWhenIndexDidNotChanged = false,
    AnimationConfigsBuilder? animationConfigsBuilder,
  }) {
    return add(
      MoveItemEvent(
        item: item,
        newIndex: newIndex,
        forceNotify: forceNotify,
        animationConfigsBuilder: animationConfigsBuilder,
        animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
      ),
    );
  }

  /// Adds a [MoveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(MoveItemEvent.byId(...))
  /// ```
  void moveById({
    required String itemId,
    required int newIndex,
    bool forceNotify = false,
    bool animateWhenIndexDidNotChanged = false,
    AnimationConfigsBuilder? animationConfigsBuilder,
  }) {
    return add(
      MoveItemEvent.byId(
        itemId: itemId,
        newIndex: newIndex,
        forceNotify: forceNotify,
        animationConfigsBuilder: animationConfigsBuilder,
        animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
      ),
    );
  }
}

import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template move_adaptive_item_event}
/// {@macro move_item_event}
///
/// {@macro insert_adaptive_item_event.adaptive_base_info}
///
/// Namely, if the runtimeType of current ScrollView is one of:
/// - [AnimatedGridView],
/// - [SliverAnimatedGridView]
/// - [AnimatedPageView]
///
/// then an [MoveInfluencedItemEvent] will be added to [EventController].
///
/// If the runtimeType is [AnimatedListView] or [SliverAnimatedListView], then
/// [MoveItemEvent] will be added.
///
/// If the runtimeType is of any other type - take a look at
/// [MoveAdaptiveItemEvent.customScrollViewEventBuilder] docstring.
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
///  * [MoveInfluencedItemEvent]
///  * [CustomModificationEventWrapper]
class MoveAdaptiveItemEvent<T>
    extends ModificationEventWithItemAndItemIdConstructors<T> {
  /// Creates a [MoveAdaptiveItemEvent] using an [item] instance.
  MoveAdaptiveItemEvent({
    required T item,
    required this.newIndex,
    this.animateWhenIndexDidNotChanged = false,
    this.animationConfigsBuilder,
    this.forceNotify = false,
    this.customScrollViewEventBuilder,
  }) : super(item);

  /// Creates a [MoveAdaptiveItemEvent] using an item's id
  MoveAdaptiveItemEvent.byId({
    required String itemId,
    required this.newIndex,
    this.animateWhenIndexDidNotChanged = false,
    this.animationConfigsBuilder,
    this.forceNotify = false,
    this.customScrollViewEventBuilder,
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

  /// {@macro insert_adaptive_item_event.custonm_scroll_view_event_builder}
  ///
  /// By default, if this parameter is not specified, and the runtimeType is not
  /// one of the listed above, [MoveItemEvent] will be added to
  /// [EventController], therefore its logic will be used.
  @protected
  @visibleForTesting
  final EventBuilder<T>? customScrollViewEventBuilder;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    required Type scrollViewType,
  }) async {
    final _item = item;
    final simple = _item != null
        ? MoveItemEvent<T>(
            item: _item,
            newIndex: newIndex,
            forceNotify: forceNotify,
            animationConfigsBuilder: animationConfigsBuilder,
            animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
          )
        : MoveItemEvent<T>.byId(
            itemId: getItemId(itemsNotifier.idMapper),
            newIndex: newIndex,
            forceNotify: forceNotify,
            animationConfigsBuilder: animationConfigsBuilder,
            animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
          );

    final influenced = _item != null
        ? MoveInfluencedItemEvent<T>(
            item: _item,
            newIndex: newIndex,
            forceNotify: forceNotify,
            animationConfigsBuilder: animationConfigsBuilder,
            animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
          )
        : MoveInfluencedItemEvent<T>.byId(
            itemId: getItemId(itemsNotifier.idMapper),
            newIndex: newIndex,
            forceNotify: forceNotify,
            animationConfigsBuilder: animationConfigsBuilder,
            animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
          );

    eventController.add(
      scrollViewType.when<ModificationEvent<T>, T>(
        grid: () => influenced,
        list: () => simple,
        pageView: () => influenced,
        orElse: (type) => customScrollViewEventBuilder?.call(type) ?? simple,
      ),
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [MoveAdaptiveItemEvent]
extension MoveAdaptiveItemEventExtension<T> on EventController<T> {
  /// Adds a [MoveAdaptiveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(MoveAdaptiveItemEvent(...))
  /// ```
  void moveAdaptive({
    required T item,
    required int newIndex,
    bool forceNotify = false,
    bool animateWhenIndexDidNotChanged = false,
    EventBuilder<T>? customScrollViewEventBuilder,
    AnimationConfigsBuilder? animationConfigsBuilder,
  }) {
    return add(
      MoveAdaptiveItemEvent(
        item: item,
        newIndex: newIndex,
        forceNotify: forceNotify,
        animationConfigsBuilder: animationConfigsBuilder,
        customScrollViewEventBuilder: customScrollViewEventBuilder,
        animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
      ),
    );
  }

  /// Adds a [MoveAdaptiveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(MoveAdaptiveItemEvent.byId(...))
  /// ```
  void moveAdaptiveById({
    required String itemId,
    required int newIndex,
    bool forceNotify = false,
    bool animateWhenIndexDidNotChanged = false,
    EventBuilder<T>? customScrollViewEventBuilder,
    AnimationConfigsBuilder? animationConfigsBuilder,
  }) {
    return add(
      MoveAdaptiveItemEvent.byId(
        itemId: itemId,
        newIndex: newIndex,
        forceNotify: forceNotify,
        animationConfigsBuilder: animationConfigsBuilder,
        customScrollViewEventBuilder: customScrollViewEventBuilder,
        animateWhenIndexDidNotChanged: animateWhenIndexDidNotChanged,
      ),
    );
  }
}

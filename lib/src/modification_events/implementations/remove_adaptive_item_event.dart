import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template remove_adaptiveitem_event}
/// {@macro remove_item_event}
///
/// {@macro insert_adaptive_item_event.adaptive_base_info}
///
/// Namely, if the runtimeType of current ScrollView is one of:
/// - [AnimatedGridView],
/// - [SliverAnimatedGridView]
/// - [AnimatedPageView]
///
/// then an [RemoveInfluencedItemEvent] will be added to [EventController].
///
/// If the runtimeType is [AnimatedListView] or [SliverAnimatedListView], then
/// [RemoveItemEvent] will be added.
///
/// If the runtimeType is of any other type - take a look at
/// [RemoveAdaptiveItemEvent.customScrollViewEventBuilder] docstring.
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [InsertAllItemsEvent]
///  * [InsertInfluencedItemEvent]
///  * [InsertAdaptiveItemEvent]
///  * [RemoveItemEvent]
///  * [RemoveInfluencedItemEvent]
///  * [MoveItemEvent]
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class RemoveAdaptiveItemEvent<T>
    extends ModificationEventWithItemAndItemIdConstructors<T> {
  /// Creates a [RemoveAdaptiveItemEvent] using an [item] instance.
  RemoveAdaptiveItemEvent({
    required T item,
    this.removeAnimationConfig = const AnimationControllerConfig(),
    this.insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    this.forceNotify = false,
    this.customScrollViewEventBuilder,
  }) : super(item);

  /// Creates a [RemoveAdaptiveItemEvent] using an item's id
  RemoveAdaptiveItemEvent.byId({
    required String itemId,
    this.removeAnimationConfig = const AnimationControllerConfig(),
    this.insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    this.forceNotify = false,
    this.customScrollViewEventBuilder,
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
  final AnimationControllerConfig removeAnimationConfig;

  /// The animation settings, affected items should be inserted with
  @protected
  @visibleForTesting
  final AnimationControllerConfig insertInfluencedAnimationConfig;

  /// {@macro insert_adaptive_item_event.custonm_scroll_view_event_builder}
  ///
  /// By default, if this parameter is not specified, and the runtimeType is not
  /// one of the listed above, [RemoveItemEvent] will be added to
  /// [EventController], therefore its logic will be used.
  @protected
  @visibleForTesting
  final EventBuilder<T>? customScrollViewEventBuilder;

  @override
  Future<void> execute({
    required ItemsNotifier<T> itemsNotifier,
    required TickerProvider vsync,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    required Type scrollViewType,
  }) async {
    final _item = item;
    final simple = _item != null
        ? RemoveItemEvent<T>(
            item: _item,
            forceNotify: forceNotify,
            animationConfig: removeAnimationConfig,
          )
        : RemoveItemEvent<T>.byId(
            itemId: getItemId(itemsNotifier.idMapper),
            forceNotify: forceNotify,
            animationConfig: removeAnimationConfig,
          );

    final influenced = _item != null
        ? RemoveInfluencedItemEvent<T>(
            item: _item,
            forceNotify: forceNotify,
            removeAnimationConfig: removeAnimationConfig,
            insertInfluencedAnimationConfig: insertInfluencedAnimationConfig,
          )
        : RemoveInfluencedItemEvent<T>.byId(
            itemId: getItemId(itemsNotifier.idMapper),
            forceNotify: forceNotify,
            removeAnimationConfig: removeAnimationConfig,
            insertInfluencedAnimationConfig: insertInfluencedAnimationConfig,
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
/// way to add to event controller an [RemoveAdaptiveItemEvent]
extension RemoveAdaptiveItemEventExtension<T> on EventController<T> {
  /// Adds a [RemoveAdaptiveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(RemoveAdaptiveItemEvent(...))
  /// ```
  void removeAdaptive({
    required T item,
    AnimationControllerConfig removeAnimationConfig =
        const AnimationControllerConfig(),
    AnimationControllerConfig insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    EventBuilder<T>? customScrollViewEventBuilder,
    bool forceNotify = false,
  }) {
    return add(
      RemoveAdaptiveItemEvent(
        item: item,
        forceNotify: forceNotify,
        removeAnimationConfig: removeAnimationConfig,
        customScrollViewEventBuilder: customScrollViewEventBuilder,
        insertInfluencedAnimationConfig: insertInfluencedAnimationConfig,
      ),
    );
  }

  /// Adds a [RemoveAdaptiveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(RemoveAdaptiveItemEvent.byId(...))
  /// ```
  void removeAdaptiveById({
    required String itemId,
    AnimationControllerConfig removeAnimationConfig =
        const AnimationControllerConfig(),
    AnimationControllerConfig insertInfluencedAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    EventBuilder<T>? customScrollViewEventBuilder,
    bool forceNotify = false,
  }) {
    return add(
      RemoveAdaptiveItemEvent.byId(
        itemId: itemId,
        forceNotify: forceNotify,
        removeAnimationConfig: removeAnimationConfig,
        customScrollViewEventBuilder: customScrollViewEventBuilder,
        insertInfluencedAnimationConfig: insertInfluencedAnimationConfig,
      ),
    );
  }
}

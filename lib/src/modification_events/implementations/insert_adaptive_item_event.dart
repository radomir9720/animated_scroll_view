import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template insert_adaptive_item_event.event_builder}
/// Callback, which provides the current ScrollView runtimeType, and expects
/// as a result a [ModificationEvent]
/// {@endtemplate}
typedef EventBuilder<T> = ModificationEvent<T> Function(Type type);

/// {@template insert_adaptive_item_event}
/// {@macro insert_all_items_event}
///
/// {@template insert_adaptive_item_event.adaptive_base_info}
/// This modification event does not have its own logic. The main and only
/// task of this event is to add to [EventController] the proper event, based on
/// runtimeType of the current ScrollView.
/// {@endtemplate}
///
/// Namely, if the runtimeType of current ScrollView is one of:
/// - [AnimatedGridView],
/// - [SliverAnimatedGridView]
/// - [AnimatedPageView]
///
/// then an [InsertInfluencedItemEvent] will be added to [EventController].
///
/// If the runtimeType is [AnimatedListView] or [SliverAnimatedListView], then
/// [InsertItemEvent] will be added.
///
/// If the runtimeType is of any other type - take a look at
/// [InsertAdaptiveItemEvent.customScrollViewEventBuilder] docstring.
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [InsertAllItemsEvent]
///  * [InsertInfluencedItemEvent]
///  * [RemoveItemEvent]
///  * [RemoveInfluencedItemEvent]
///  * [RemoveAdaptiveItemEvent]
///  * [MoveItemEvent]
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class InsertAdaptiveItemEvent<T> extends ModificationEvent<T> {
  /// Creates an [InsertAdaptiveItemEvent]
  InsertAdaptiveItemEvent({
    this.index,
    required this.item,
    this.forceNotify = false,
    this.removeInfluencedAnimationConfig = const AnimationControllerConfig(),
    this.insertAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    this.customScrollViewEventBuilder,
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

  /// {@template insert_adaptive_item_event.custonm_scroll_view_event_builder}
  /// {@macro insert_adaptive_item_event.event_builder}
  ///
  /// Optional. It is used only if the runtimeType of current ScrollView is not
  /// one of the default implementations provided by this package:
  ///
  /// - [AnimatedListView],
  /// - [SliverAnimatedListView],
  /// - [AnimatedGridView],
  /// - [SliverAnimatedGridView],
  /// - [AnimatedPageView]
  ///
  /// Namely, if you have implemented your own ScrollView by extending
  /// [AnimatedScrollView], for example, then it makes sense to specify
  /// this parameter.
  /// {@endtemplate}
  ///
  /// By default, if this parameter is not specified, and the runtimeType is not
  /// one of the listed above, [InsertItemEvent] will be added to
  /// [EventController], therefore its logic will be used.
  @protected
  @visibleForTesting
  final EventBuilder<T>? customScrollViewEventBuilder;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController<DoubleAnimation> itemsAnimationController,
    required Type scrollViewType,
  }) async {
    final simple = InsertItemEvent(
      item: item,
      animationConfig: insertAnimationConfig,
      forceNotify: forceNotify,
      index: index,
    );
    final influenced = InsertInfluencedItemEvent<T>(
      item: item,
      forceNotify: forceNotify,
      index: index,
      insertAnimationConfig: insertAnimationConfig,
      removeInfluencedAnimationConfig: removeInfluencedAnimationConfig,
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
/// way to add to event controller an [InsertAdaptiveItemEvent]
extension InsertAdaptiveItemEventExtension<T> on EventController<T> {
  /// Adds an [InsertAdaptiveItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(InsertAdaptiveItemEvent(...))
  /// ```
  void insertAdaptive({
    required T item,
    int? index,
    bool forceNotify = false,
    bool forceVisible = false,
    AnimationControllerConfig insertAnimationConfig =
        const AnimationControllerConfig(initialValue: 0),
    AnimationControllerConfig removeInfluencedAnimationConfig =
        const AnimationControllerConfig(),
    EventBuilder<T>? customScrollViewEventBuilder,
  }) {
    return add(
      InsertAdaptiveItemEvent(
        item: item,
        index: index,
        forceNotify: forceNotify,
        insertAnimationConfig: insertAnimationConfig,
        customScrollViewEventBuilder: customScrollViewEventBuilder,
        removeInfluencedAnimationConfig: removeInfluencedAnimationConfig,
      ),
    );
  }
}

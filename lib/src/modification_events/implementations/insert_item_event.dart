import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';

import 'package:animated_scroll_view/src/models/modification.dart';
import 'package:flutter/widgets.dart';

/// {@template insert_item_event}
/// Implements insert logic of the [item]. Manages insert animation.
///
/// Descendant of [ModificationEvent].
/// {@endtemplate}
///
/// See also:
///  * [InsertAllItemsEvent]
///  * [InsertInfluencedItemEvent]
///  * [InsertAdaptiveItemEvent]
///  * [RemoveItemEvent]
///  * [RemoveInfluencedItemEvent]
///  * [RemoveAdaptiveItemEvent]
///  * [MoveItemEvent]
///  * [MoveInfluencedItemEvent]
///  * [MoveAdaptiveItemEvent]
///  * [CustomModificationEventWrapper]
class InsertItemEvent<T> extends ModificationEvent<T>
    with AnimationControllerMixin, CheckInsertIndexIsValidMixin {
  /// Creates an [InsertItemEvent]
  InsertItemEvent({
    this.index,
    required this.item,
    this.forceNotify = false,
    this.animationConfig = const AnimationControllerConfig(initialValue: 0),
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
  final AnimationControllerConfig animationConfig;

  /// {@template insert_item_event.force_notify}
  /// Whether should [ItemsNotifier] notify its listeners immediately
  /// after inserting the item, or delegate this task to the
  /// [ItemsNotifier] itself
  /// {@endtemplate}
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

    final itemId = itemsNotifier.idMapper(item);

    final modificationId = Modification.insert.interpolate(itemId);

    itemsAnimationController.cachedAnimationValue[modificationId] =
        animationConfig.lowerBound;

    final delayedAnimation = DelayedInMemoryAnimation<AnimationController>(
      createAnimationCallback: (vsync) {
        return getAnimation(
          vsync,
          config: animationConfig,
        );
      },
      runCallback: (animation) {
        itemsAnimationController.cachedAnimationValue[modificationId] =
            animationConfig.uppedBound;
        return animation.forward();
      },
      disposeCallback: (animation) {
        animation
          ..stop()
          ..dispose();
      },
    );

    itemsAnimationController.inMemoryAnimationMap[modificationId] =
        delayedAnimation;

    itemsNotifier.insert(
      _index,
      item,
      forceNotify: forceNotify,
      modificationId: modificationId,
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [InsertItemEvent]
extension InsertItemEventExtension<T> on EventController<T> {
  /// Adds an [InsertItemEvent] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(InsertItemEvent(...))
  /// ```
  void insert({
    required T item,
    int? index,
    bool forceNotify = false,
    AnimationControllerConfig animationConfig =
        const AnimationControllerConfig(initialValue: 0),
  }) {
    return add(
      InsertItemEvent(
        item: item,
        index: index,
        forceNotify: forceNotify,
        animationConfig: animationConfig,
      ),
    );
  }
}

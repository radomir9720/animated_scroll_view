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

    final itemsIds = items.map(itemsNotifier.idMapper);
    final modificationIds = itemsIds.map(Modification.insert.interpolate);

    for (final modificationId in modificationIds) {
      itemsAnimationController.cachedAnimationValue[modificationId] =
          animationConfig.lowerBound;
    }

    final delayedAnimation = DelayedInMemoryAnimation<AnimationController>(
      createAnimationCallback: (_) {
        return getAnimation(vsync, config: animationConfig);
      },
      runCallback: (animation) async {
        for (final modificationId in modificationIds) {
          itemsAnimationController.cachedAnimationValue[modificationId] =
              animationConfig.uppedBound;
        }

        return animation.forward().then((value) {
          for (final modificationId in modificationIds) {
            itemsAnimationController.inMemoryAnimationMap
                .remove(modificationId);
          }
          dispose();
        });
      },
      // Reason why we don't dispose the animation in this callback is that
      // we are using one single animation for all the items, and we do not
      // want to dispose the animation when some item was disposed, because
      // that way all the other items will not be animated.
      //
      // The animation is disposed a few lines above, in the [then()] calllback
      // of the [animation.forward()] method, when the animation is completed.
      disposeCallback: (animation) {},
    );

    for (final modificationId in modificationIds) {
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

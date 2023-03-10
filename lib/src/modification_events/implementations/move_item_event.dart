import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

class AnimationConfigs {
  const AnimationConfigs({
    this.remove = const AnimationControllerConfig(),
    this.insert = const AnimationControllerConfig(initialValue: 0),
  });

  final AnimationControllerConfig remove;
  final AnimationControllerConfig insert;
}

class MoveItemEvent<T> extends ModificationEventWithItemAndItemIdConstructors<T>
    with
        AnimationControllerMixin,
        CheckInsertIndexIsValidMixin,
        RemoveItemEventAnimationMixin {
  MoveItemEvent({
    required T item,
    required this.newIndex,
    this.animateWhenIndexDidNotChanged = false,
    this.animationConfigsBuilder,
    this.forceNotify = false,
  }) : super(item);

  MoveItemEvent.byId({
    required String itemId,
    required this.newIndex,
    this.animateWhenIndexDidNotChanged = false,
    this.animationConfigsBuilder,
    this.forceNotify = false,
  }) : super.byId(itemId);

  @protected
  final int newIndex;

  @protected
  final bool animateWhenIndexDidNotChanged;

  @protected
  final bool forceNotify;

  @protected
  final AnimationConfigs Function(int currentIndex)? animationConfigsBuilder;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
  }) async {
    final itemId = getItemId(itemsNotifier.idMapper);

    throwIfIndexIsInvalid(itemsNotifier, newIndex);

    // getIndexById() will throw an Excception if the item with specified id
    // is not found, therefore code execution will stop, as intended.
    final currentIndex = itemsNotifier.getIndexById(itemId);

    if (currentIndex == newIndex && !animateWhenIndexDidNotChanged) {
      final newItem = item;
      if (newItem != null) {
        if (newItem != itemsNotifier.value[currentIndex]) {
          itemsNotifier
            ..removeAt(currentIndex, forceNotify: false)
            ..insert(currentIndex, newItem);
        }
      }
      return;
    }

    final animationConfigs =
        animationConfigsBuilder?.call(currentIndex) ?? const AnimationConfigs();

    return runRemoveAnimation(
      vsync: vsync,
      itemId: itemId,
      itemsAnimationController: itemsAnimationController,
      removeAnimationConfig: animationConfigs.remove,
      onAnimationEnd: () {
        final current = itemsNotifier.removeAt(
          currentIndex,
          forceNotify: false,
        );

        eventController.add(
          InsertItemEvent(
            item: item ?? current,
            index: newIndex,
            forceNotify: forceNotify,
            animationConfig: animationConfigs.insert,
          ),
        );
      },
    );
  }
}

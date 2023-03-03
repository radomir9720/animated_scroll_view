import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';

class RemoveItemEvent<T>
    extends ModificationEventWithItemAndItemIdConstructors<T>
    with AnimationControllerMixin, RemoveItemEventAnimationMixin {
  RemoveItemEvent({
    required T item,
    this.animationConfig = const AnimationControllerConfig(),
  }) : super(item);

  RemoveItemEvent.byId({
    required String itemId,
    this.animationConfig = const AnimationControllerConfig(),
  }) : super.byId(itemId);

  final AnimationControllerConfig animationConfig;

  @override
  Future<void> execute({
    required ItemsNotifier<T> itemsNotifier,
    required TickerProvider vsync,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    AnimationControllerConfig? removeAnimationConfig,
  }) {
    final itemId = getItemId(itemsNotifier.idMapper);

    // getIndexById() will throw an Excception if the item with specified id
    // is not found, therefore code execution will stop, as intended.
    itemsNotifier.getIndexById(itemId);

    return runRemoveAnimation(
      vsync: vsync,
      itemId: itemId,
      removeAnimationConfig: animationConfig,
      itemsAnimationController: itemsAnimationController,
      onAnimationEnd: () => itemsNotifier.removeById(itemId),
    );
  }
}

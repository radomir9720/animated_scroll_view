import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:animated_scroll_view/src/modification_events/mixins/item_and_item_id_constructors.dart';
import 'package:animated_scroll_view/src/modification_events/mixins/remove_item_event_animation_mixin.dart';
import 'package:flutter/animation.dart';

class RemoveItemEvent<T> extends ItemAndItemIdConstructors<T>
    with AnimationControllerMixin, RemoveItemEventAnimationMixin<T>
    implements ModificationEvent<T> {
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

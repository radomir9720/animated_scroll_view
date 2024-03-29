import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/widgets/scrollables/models/my_model.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/controls_wrapper.dart';
import 'package:widgetbook_app/utils/knobs.dart';

@UseCase(name: 'Default', type: AnimatedGridView)
Widget buildAnimatedGridView(BuildContext context) {
  return AnimatedScrollViewControlsWrapper(
    forceNotifyOnMoveAndRemove: true,
    itemCount: context.itemsCountKnob(),
    viewBuilder: (itemsNotifier, eventController, items) {
      return AnimatedGridView<MyModel>(
        scrollDirection: context.axis,
        itemsNotifier: itemsNotifier,
        eventController: eventController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisExtent: 56,
        ),
        idMapper: (object) => object.id.toString(),
        itemBuilder: (item) {
          return ColoredBox(
            color: item.color,
            child: Center(
              child: Text(
                'ItemId: ${item.id}',
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
        items: items,
      );
    },
  );
}

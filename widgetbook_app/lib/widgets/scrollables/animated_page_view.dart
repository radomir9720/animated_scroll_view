import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/controls_wrapper.dart';
import 'package:widgetbook_app/utils/knobs.dart';

@UseCase(name: 'Default', type: AnimatedPageView)
Widget buildAnimatedPageView(BuildContext context) {
  return AnimatedScrollViewControlsWrapper(
    itemCount: context.itemsCountKnob(count: 5),
    forceNotifyOnMoveAndRemove: true,
    viewBuilder: (itemsNotifier, eventController, items) {
      return AnimatedPageView(
        items: items,
        scrollDirection: context.axis,
        itemsNotifier: itemsNotifier,
        eventController: eventController,
        idMapper: (object) => object.id.toString(),
        itemBuilder: (item) {
          return ColoredBox(
            color: item.color,
            child: Center(child: Text('ItemID: ${item.id}')),
          );
        },
      );
    },
  );
}

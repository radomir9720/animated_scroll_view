import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/controls_wrapper.dart';

@WidgetbookUseCase(name: 'Default', type: AnimatedListView)
Widget buildAnimatedListView(BuildContext context) {
  return AnimatedScrollViewControlsWrapper(
    viewBuilder: (itemsNotifier, eventController, items) {
      return AnimatedListView(
        eventController: eventController,
        itemsNotifier: itemsNotifier,
        idMapper: (object) => object.id.toString(),
        items: items,
        itemBuilder: (item) {
          return ListTile(
            leading: SizedBox.square(
              dimension: 20,
              child: ColoredBox(color: item.color),
            ),
            title: Text('ItemId: ${item.id}'),
          );
        },
      );
    },
  );
}

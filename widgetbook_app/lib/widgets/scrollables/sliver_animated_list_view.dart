import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/controls_wrapper.dart';

@WidgetbookUseCase(name: 'Default', type: SliverAnimatedListView)
Widget buildSliverAnimatedListView(BuildContext context) {
  return AnimatedScrollViewControlsWrapper(
    viewBuilder: (itemsNotifier, eventController, items) {
      return SliverAnimatedListView(
        itemsNotifier: itemsNotifier,
        eventController: eventController,
        idMapper: (object) => object.id.toString(),
        itemBuilder: (item) {
          return ListTile(
            leading: SizedBox.square(
              dimension: 20,
              child: ColoredBox(color: item.color),
            ),
            title: Text('ItemId: ${item.id}'),
          );
        },
        items: items,
      );
    },
  );
}

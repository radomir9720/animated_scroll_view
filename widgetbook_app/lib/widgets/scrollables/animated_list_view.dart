import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/utils/knobs.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/controls_wrapper.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/list_view_item.dart';

@UseCase(name: 'Default', type: AnimatedListView)
Widget buildAnimatedListView(BuildContext context) {
  return AnimatedScrollViewControlsWrapper(
    itemCount: context.itemsCountKnob(),
    viewBuilder: (itemsNotifier, eventController, items) {
      final axis = context.axis;

      return AnimatedListView(
        eventController: eventController,
        itemsNotifier: itemsNotifier,
        scrollDirection: axis,
        idMapper: (object) => object.id.toString(),
        items: items,
        itemBuilder: (item) => ListViewItem(axis: axis, item: item),
      );
    },
  );
}

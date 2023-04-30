import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/controls_wrapper.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/list_view_item.dart';
import 'package:widgetbook_app/utils/knobs.dart';

@WidgetbookUseCase(name: 'Default', type: SliverAnimatedListView)
Widget buildSliverAnimatedListView(BuildContext context) {
  return AnimatedScrollViewControlsWrapper(
    viewBuilder: (itemsNotifier, eventController, items) {
      final axis = context.axis;

      return CustomScrollView(
        scrollDirection: axis,
        slivers: [
          SliverAnimatedListView(
            itemsNotifier: itemsNotifier,
            eventController: eventController,
            idMapper: (object) => object.id.toString(),
            itemBuilder: (item) => ListViewItem(axis: axis, item: item),
            items: items,
          ),
        ],
      );
    },
  );
}

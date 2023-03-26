import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/widgets/scrollables/widgets/controls_wrapper.dart';

@WidgetbookUseCase(name: 'Default', type: SliverAnimatedGridView)
Widget buildSliverAnimatedGridView(BuildContext context) {
  return AnimatedScrollViewControlsWrapper(
    forceNotifyOnMoveAndRemove: true,
    viewBuilder: (itemsNotifier, eventController, items) {
      return CustomScrollView(
        slivers: [
          SliverAnimatedGridView(
            eventController: eventController,
            itemsNotifier: itemsNotifier,
            idMapper: (object) => object.id.toString(),
            itemBuilder: (item) {
              return ColoredBox(
                color: item.color,
                child: Center(child: Text('ItemId: ${item.id}')),
              );
            },
            items: items,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 56,
            ),
          ),
        ],
      );
    },
  );
}

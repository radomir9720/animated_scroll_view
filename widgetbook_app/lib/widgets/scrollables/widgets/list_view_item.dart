import 'package:flutter/material.dart';
import 'package:widgetbook_app/widgets/scrollables/models/my_model.dart';

class ListViewItem extends StatelessWidget {
  const ListViewItem({super.key, required this.axis, required this.item});

  @protected
  final Axis axis;

  @protected
  final MyModel item;

  @override
  Widget build(BuildContext context) {
    if (axis == Axis.horizontal) {
      return ColoredBox(
        color: item.color,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Center(
            child: Text(
              'ItemId:\n${item.id}',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return ListTile(
      leading: SizedBox.square(
        dimension: 20,
        child: ColoredBox(color: item.color),
      ),
      title: Text('ItemId: ${item.id}'),
    );
  }
}

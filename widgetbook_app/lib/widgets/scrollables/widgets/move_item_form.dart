import 'package:flutter/material.dart';
import 'package:widgetbook_app/utils/parse_int.dart';

class MoveItemForm extends StatefulWidget {
  const MoveItemForm({Key? key, required this.onPressed}) : super(key: key);

  @protected
  final void Function(int from, int newIndex) onPressed;

  @override
  State<MoveItemForm> createState() => _MoveItemFormState();
}

class _MoveItemFormState extends State<MoveItemForm> {
  final itemIdController = TextEditingController();
  final newIndexController = TextEditingController();

  @override
  void dispose() {
    newIndexController.dispose();
    itemIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: itemIdController,
            autofocus: true,
            decoration: const InputDecoration(
              label: Text('Item id'),
            ),
          ),
        ),
        Expanded(
          child: TextField(
            controller: newIndexController,
            decoration: const InputDecoration(
              label: Text('New index'),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            final itemId = context.tryParseInt(itemIdController.text, (i) => i);
            final to = context.tryParseInt(newIndexController.text, (i) => i);
            if (itemId == null) return;
            if (to == null) return;

            widget.onPressed(itemId, to);
          },
          child: const Text('Move'),
        ),
      ],
    );
  }
}

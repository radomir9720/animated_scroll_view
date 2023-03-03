import 'package:flutter/material.dart';
import 'package:widgetbook_app/utils/parse_int.dart';

class EnterIndexTextField extends StatefulWidget {
  const EnterIndexTextField({
    super.key,
    this.label = 'Enter element index',
    required this.buttonLabel,
    required this.onButtonPressed,
  });

  @protected
  final String label;

  @protected
  final String buttonLabel;

  @protected
  final ValueSetter<int> onButtonPressed;

  @override
  State<EnterIndexTextField> createState() => _EnterIndexTextFieldState();
}

class _EnterIndexTextFieldState extends State<EnterIndexTextField> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: true,
      decoration: InputDecoration(
        label: Text(widget.label),
        suffix: TextButton(
          onPressed: () {
            context.tryParseInt(controller.text, widget.onButtonPressed);
          },
          child: Text(widget.buttonLabel),
        ),
      ),
    );
  }
}

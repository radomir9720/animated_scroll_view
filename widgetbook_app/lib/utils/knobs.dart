import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

extension on KnobsBuilder {
  int integer({
    required String label,
    String? description,
    int initialValue = 10,
  }) {
    return onKnobAdded(
      IntegerInputKnob(
        label: label,
        value: initialValue,
        description: description,
      ),
    )!;
  }
}

extension KnobsExtension on BuildContext {
  double zeroToOneSlider(String label, {String? description}) {
    return knobs.double.slider(
      label: label,
      min: 0,
      max: 1,
      initialValue: 1,
      description: description,
    );
  }

  int itemsCountKnob({int count = 50}) {
    return knobs
        .integer(
          label: 'Items count',
          initialValue: count,
        )
        .toInt();
  }

  Axis get axis {
    return knobs.list<Axis>(
      label: 'Axis',
      options: const [
        Axis.vertical,
        Axis.horizontal,
      ],
      labelBuilder: (value) => value.name,
    );
  }
}

class IntegerInputKnob extends Knob<int> {
  IntegerInputKnob({
    required super.label,
    required super.value,
    super.description,
  });

  @override
  List<Field> get fields {
    return [
      IntegerInputField(
        name: label,
        initialValue: value,
        onChanged: (context, value) {
          if (value == null) return;
          WidgetbookState.of(context).updateKnobValue(label, value);
        },
      ),
    ];
  }

  @override
  int valueFromQueryGroup(Map<String, String> group) {
    return group.containsKey(label) ? int.parse(group[label]!) : value;
  }
}

class IntegerInputField extends Field<int> {
  IntegerInputField({
    required super.name,
    super.initialValue = 0,
    super.onChanged,
  }) : super(
          type: FieldType.doubleSlider,
          codec: FieldCodec(
            toParam: (value) => value.toString(),
            toValue: (param) => int.tryParse(param ?? ''),
          ),
        );

  @override
  Widget toWidget(BuildContext context, String group, int? value) {
    return TextFormField(
      initialValue: codec.toParam(value ?? initialValue ?? 0),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        updateField(
          context,
          group,
          codec.toValue(value) ?? initialValue ?? 0,
        );
      },
    );
  }
}

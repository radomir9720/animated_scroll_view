import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart';

extension KnobsExtension on BuildContext {
  double zeroToOneSlider(String label, {String? description}) {
    return knobs.slider(
      label: label,
      min: 0,
      max: 1,
      initialValue: 1,
      description: description,
    );
  }

  Axis get axis {
    return knobs.options<Axis>(
      label: 'Axis',
      options: const [
        Option(
          label: 'Vertical',
          value: Axis.vertical,
        ),
        Option(
          label: 'Horizontal',
          value: Axis.horizontal,
        ),
      ],
    );
  }
}

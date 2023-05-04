// ignore_for_file: invalid_use_of_protected_member

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' hide WidgetbookUseCase;
import 'package:widgetbook_annotation/widgetbook_annotation.dart';
import 'package:widgetbook_app/utils/knobs.dart';

OperationPointerIgnoreCondition _getOperationPointerIgnoreCondition({
  required double conditionValue,
  required BuildContext context,
}) {
  final options = [
    Option(
      label: 'equalsTo',
      value: conditionValue.equalsTo,
    ),
    Option(
      label: 'notEqualsTo',
      value: conditionValue.notEqualsTo,
    ),
    Option(
      label: 'greaterThan',
      value: conditionValue.greaterThan,
    ),
    Option(
      label: 'greaterOrEqualTo',
      value: conditionValue.greaterOrEqualTo,
    ),
    Option(
      label: 'lessThan',
      value: conditionValue.lessThan,
    ),
    Option(
      label: 'lessOrEqualTo',
      value: conditionValue.lessOrEqualTo,
    ),
  ];

  final condition = context.knobs.options(
    label: 'Condition',
    options: options,
  );

  if (condition.value != conditionValue) {
    return OperationPointerIgnoreCondition(
      value: conditionValue,
      operation: condition.operation,
    );
  }

  return condition;
}

extension on double {
  double asFixed({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}

@WidgetbookUseCase(name: 'Default', type: PointerIgnorer)
Widget defaultPointerIgnorerUseCase(BuildContext context) {
  final conditionValue = context.zeroToOneSlider('Condition value').asFixed();
  final animationValue = context.zeroToOneSlider('Animation value').asFixed();
  final ignoreCondition = _getOperationPointerIgnoreCondition(
    conditionValue: conditionValue,
    context: context,
  );
  final conditionBool = ignoreCondition.check(animationValue);

  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: 'Ignoring?: '),
                TextSpan(
                  text: '$conditionBool',
                  style: TextStyle(
                    backgroundColor: conditionBool ? Colors.green : Colors.red,
                  ),
                ),
              ],
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),

          //
          const SizedBox(height: 24),
          //
          PointerIgnorer(
            key: ValueKey(conditionValue),
            animation: AlwaysStoppedAnimation(animationValue),
            ignoreCondition: ignoreCondition,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('PRESSED'),
                  ),
                );
              },
              child: SizedBox.square(
                dimension: 100,
                child: Ink(
                  color: Colors.blue,
                  child: const Center(
                      child: Text(
                    'Try and press me',
                    textAlign: TextAlign.center,
                  )),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

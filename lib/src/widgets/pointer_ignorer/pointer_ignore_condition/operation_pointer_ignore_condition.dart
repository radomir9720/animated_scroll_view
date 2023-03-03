import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:meta/meta.dart';

@immutable
class OperationPointerIgnoreCondition implements PointerIgnoreCondition {
  const OperationPointerIgnoreCondition({
    required this.value,
    required this.operation,
  });

  @protected
  final double value;

  @protected
  final Operation operation;

  @override
  bool check(double animationValue) {
    return operation.when(
      equalsTo: () => value == animationValue,
      lessThan: () => value < animationValue,
      notEqualsTo: () => value != animationValue,
      geaterThan: () => value > animationValue,
      lessOrEqualTo: () => value <= animationValue,
      greaterOrEqualTo: () => value >= animationValue,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OperationPointerIgnoreCondition &&
        other.value == value &&
        other.operation == operation;
  }

  @override
  int get hashCode => value.hashCode ^ operation.hashCode;

  @override
  String toString() =>
      'OperationPointerIgnoreCondition(value: $value, operation: $operation)';
}

extension OperationPointerIgnoreConditionExtension on num {
  OperationPointerIgnoreCondition _getCondition(Operation operation) {
    return OperationPointerIgnoreCondition(
      value: toDouble(),
      operation: operation,
    );
  }

  OperationPointerIgnoreCondition get equalsTo =>
      _getCondition(Operation.equalsTo);
  OperationPointerIgnoreCondition get lessThan =>
      _getCondition(Operation.lessThan);
  OperationPointerIgnoreCondition get notEqualsTo =>
      _getCondition(Operation.notEqualsTo);
  OperationPointerIgnoreCondition get greaterThan =>
      _getCondition(Operation.greaterThan);
  OperationPointerIgnoreCondition get lessOrEqualTo =>
      _getCondition(Operation.lessOrEqualTo);
  OperationPointerIgnoreCondition get greaterOrEqualTo =>
      _getCondition(Operation.greaterOrEqualTo);
}

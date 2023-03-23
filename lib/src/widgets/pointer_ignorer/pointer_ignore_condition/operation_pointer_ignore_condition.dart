import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:meta/meta.dart';

/// {@template operation_pointer_ignore_condition}
/// {@macro pointer_ignore_condition}.
///
/// Implementation of [PointerIgnoreCondition].
///
/// Besides the animation value, this implementation also takes into account
/// the given [operation] and [value].
///
/// It takes the value of the animation(provided in [check] method),
/// the provided [value], and makes a comparison,
/// using given [operation].
/// {@endtemplate}
@immutable
class OperationPointerIgnoreCondition implements PointerIgnoreCondition {
  /// Creates a [OperationPointerIgnoreCondition]
  const OperationPointerIgnoreCondition({
    required this.value,
    required this.operation,
  });

  /// Value, used as first operand(second is the animation value, provided in
  /// [check] method)
  @protected
  final double value;

  /// Operation, based on which will be made the comparison
  /// between provided [value] and animation value(prvided in [check] method)
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

/// Extension, which will made creation of an [OperationPointerIgnoreCondition]
/// much simplier and declarative.
///
/// Example:
/// ```dart
/// // instead of
/// final condition = OperationPointerIgnoreCondition(
///      value: 1,
///      operation: Operation.equalsTo,
///    );
/// // you can use
/// final condition = 1.equalsTo;
/// ```
extension OperationPointerIgnoreConditionExtension on num {
  OperationPointerIgnoreCondition _getCondition(Operation operation) {
    return OperationPointerIgnoreCondition(
      value: toDouble(),
      operation: operation,
    );
  }

  /// Shortcut for
  /// ```dart
  /// OperationPointerIgnoreCondition(
  ///      value: numValue,
  ///      operation: Operation.equalsTo,
  ///    );
  /// ```
  OperationPointerIgnoreCondition get equalsTo =>
      _getCondition(Operation.equalsTo);

  /// Shortcut for
  /// ```dart
  /// OperationPointerIgnoreCondition(
  ///      value: numValue,
  ///      operation: Operation.lessThan,
  ///    );
  /// ```
  OperationPointerIgnoreCondition get lessThan =>
      _getCondition(Operation.lessThan);

  /// Shortcut for
  /// ```dart
  /// OperationPointerIgnoreCondition(
  ///      value: numValue,
  ///      operation: Operation.notEqualsTo,
  ///    );
  /// ```
  OperationPointerIgnoreCondition get notEqualsTo =>
      _getCondition(Operation.notEqualsTo);

  /// Shortcut for
  /// ```dart
  /// OperationPointerIgnoreCondition(
  ///      value: numValue,
  ///      operation: Operation.greaterThan,
  ///    );
  /// ```
  OperationPointerIgnoreCondition get greaterThan =>
      _getCondition(Operation.greaterThan);

  /// Shortcut for
  /// ```dart
  /// OperationPointerIgnoreCondition(
  ///      value: numValue,
  ///      operation: Operation.lessOrEqualTo,
  ///    );
  /// ```
  OperationPointerIgnoreCondition get lessOrEqualTo =>
      _getCondition(Operation.lessOrEqualTo);

  /// Shortcut for
  /// ```dart
  /// OperationPointerIgnoreCondition(
  ///      value: numValue,
  ///      operation: Operation.greaterOrEqualTo,
  ///    );
  /// ```
  OperationPointerIgnoreCondition get greaterOrEqualTo =>
      _getCondition(Operation.greaterOrEqualTo);
}

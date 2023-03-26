import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// {@template animation_controller_config}
/// Model, which contains animation settings.
///
/// This config is meant to be used with [AnimationController]
/// {@endtemplate}
@immutable
class AnimationControllerConfig {
  /// {@macro animation_controller_config}
  const AnimationControllerConfig({
    this.lowerBound = 0,
    this.uppedBound = 1,
    this.behavior = AnimationBehavior.normal,
    this.initialValue = 1,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
  });

  ///  See [AnimationController.lowerBound]
  final double lowerBound;

  ///  See [AnimationController.upperBound]
  final double uppedBound;

  ///  See [AnimationController.animationBehavior]
  final AnimationBehavior behavior;

  ///  See [AnimationController.value]
  final double initialValue;

  ///  See [AnimationController.duration]
  final Duration duration;

  ///  See [AnimationController.reverseDuration]
  final Duration? reverseDuration;

  /// Returuns a copy of current instance, and replaces its parameters by
  /// provided ones.
  AnimationControllerConfig copyWith({
    double? lowerBound,
    double? uppedBound,
    AnimationBehavior? behavior,
    double? initialValue,
    Duration? duration,
    Duration? reverseDuration,
  }) {
    return AnimationControllerConfig(
      lowerBound: lowerBound ?? this.lowerBound,
      uppedBound: uppedBound ?? this.uppedBound,
      behavior: behavior ?? this.behavior,
      initialValue: initialValue ?? this.initialValue,
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnimationControllerConfig &&
        other.lowerBound == lowerBound &&
        other.uppedBound == uppedBound &&
        other.behavior == behavior &&
        other.initialValue == initialValue &&
        other.duration == duration &&
        other.reverseDuration == reverseDuration;
  }

  @override
  int get hashCode {
    return lowerBound.hashCode ^
        uppedBound.hashCode ^
        behavior.hashCode ^
        initialValue.hashCode ^
        duration.hashCode ^
        reverseDuration.hashCode;
  }

  @override
  String toString() {
    return 'AnimationControllerConfig(lowerBound: $lowerBound,\n'
        'uppedBound: $uppedBound,\n'
        'behavior: $behavior,\n'
        'initialValue: $initialValue,\n'
        'duration: $duration,\n'
        'reverseDuration: $reverseDuration)';
  }
}

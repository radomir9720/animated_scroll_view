import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

@immutable
class AnimationControllerConfig {
  const AnimationControllerConfig({
    this.lowerBound = 0,
    this.uppedBound = 1,
    this.behavior = AnimationBehavior.normal,
    this.initialValue = 1,
    this.duration = const Duration(milliseconds: 200),
    this.reverseDuration,
    this.postframeCallback,
  });

  final double lowerBound;
  final double uppedBound;
  final AnimationBehavior behavior;
  final double initialValue;
  final Duration duration;
  final Duration? reverseDuration;
  final void Function(AnimationController controller)? postframeCallback;

  AnimationControllerConfig copyWith({
    double? lowerBound,
    double? uppedBound,
    AnimationBehavior? behavior,
    double? initialValue,
    Duration? duration,
    Duration? reverseDuration,
    void Function(AnimationController controller)? postframeCallback,
  }) {
    return AnimationControllerConfig(
      lowerBound: lowerBound ?? this.lowerBound,
      uppedBound: uppedBound ?? this.uppedBound,
      behavior: behavior ?? this.behavior,
      initialValue: initialValue ?? this.initialValue,
      duration: duration ?? this.duration,
      reverseDuration: reverseDuration ?? this.reverseDuration,
      postframeCallback: postframeCallback ?? this.postframeCallback,
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
        other.reverseDuration == reverseDuration &&
        other.postframeCallback == postframeCallback;
  }

  @override
  int get hashCode {
    return lowerBound.hashCode ^
        uppedBound.hashCode ^
        behavior.hashCode ^
        initialValue.hashCode ^
        duration.hashCode ^
        reverseDuration.hashCode ^
        postframeCallback.hashCode;
  }

  @override
  String toString() {
    return 'AnimationControllerConfig(lowerBound: $lowerBound,\n'
        'uppedBound: $uppedBound,\n'
        'behavior: $behavior,\n'
        'initialValue: $initialValue,\n'
        'duration: $duration,\n'
        'reverseDuration: $reverseDuration,\n'
        'postframeCallback: $postframeCallback)';
  }
}

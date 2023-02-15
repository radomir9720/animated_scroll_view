import 'package:flutter/widgets.dart';

/// {@template size_and_fade_transition}
///
/// Simple "short cut" widget, which wraps the [child] in [SizeTransition] and
/// [FadeTransition] widgets
///
/// {@endtemplate}
class SizeAndFadeTransition extends StatelessWidget {
  /// {@macro size_and_fade_transition}
  const SizeAndFadeTransition({
    super.key,
    required this.child,
    required this.animation,
    this.sizeTransitionAxis = Axis.vertical,
    this.sizeTransitionAxisAlignment = 0,
  });

  /// The child, which will be provided as a child for both [SizeTransition] and
  /// [FadeTransition]
  @protected
  final Widget child;

  /// Animation, provided to [SizeTransition.sizeFactor]
  /// and [FadeTransition.opacity]
  @protected
  final Animation<double> animation;

  /// [Axis.horizontal] if [SizeTransition.sizeFactor] modifies the width,
  /// otherwise [Axis.vertical].
  @protected
  final Axis sizeTransitionAxis;

  /// Describes how to align the child along the axis that
  /// [SizeTransition.sizeFactor] is modifying.
  ///
  /// See [SizeTransition.axisAlignment] for more info
  @protected
  final double sizeTransitionAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      axis: sizeTransitionAxis,
      axisAlignment: sizeTransitionAxisAlignment,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

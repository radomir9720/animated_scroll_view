import 'package:animated_scroll_view/animated_scroll_view.dart';
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
    this.sizeTransitionAxis,
    this.sizeTransitionAxisAlignment = 0,
  });

  /// The child, which will be provided as a child for both [SizeTransition] and
  /// [FadeTransition]
  @protected
  final Widget child;

  /// Animation, provided to [SizeTransition.sizeFactor]
  /// and [FadeTransition.opacity]
  @protected
  final DoubleAnimation animation;

  /// [Axis.horizontal] if [SizeTransition.sizeFactor] modifies the width,
  /// otherwise [Axis.vertical].
  ///
  /// This parameter is optional because if the axis was not specified
  /// explicitly, it will be determined under the hood
  /// by [Scrollable.of(context).axisDirection].
  ///
  /// If the axis was not passed explicitly, and
  /// [Scrollable.of(context)?.axisDirection], for some reason, returns `null`,
  /// then [kDefaultTransitionAxis] is used.
  @protected
  final Axis? sizeTransitionAxis;

  /// Default size transition axis, which is used when the axis is not specified
  /// explicitly, and [Scrollable.of(context).axisDirection] returns `null`.
  static const kDefaultTransitionAxis = Axis.vertical;

  /// Describes how to align the child along the axis that
  /// [SizeTransition.sizeFactor] is modifying.
  ///
  /// See [SizeTransition.axisAlignment] for more info
  @protected
  final double sizeTransitionAxisAlignment;

  @override
  Widget build(BuildContext context) {
    // Ignoring lint rule because of broken backward compatibility.
    // [Scrollable.of] was migrated without saving backward compatibility in
    // flutter v3.7:
    // https://github.com/flutter/flutter/pull/114120
    // https://github.com/flutter/flutter/issues/119499
    // So the [Scrollable.of] method will work differently on versions below
    // 3.7 and on >=3.7. On versions >= 3.7 it will throw a [FlutterErrpr]
    // if there is no [Scrollable] ancestor found. But in our case it is not
    // a problem, because [SizeAndFadeTrsnsition] widget by default is placed
    // in a Scrollable.
    // ignore: invalid_null_aware_operator
    final axisDirection = Scrollable.of(context)?.axisDirection;

    final axis =
        axisDirection == null ? null : axisDirectionToAxis(axisDirection);

    return SizeTransition(
      sizeFactor: animation,
      axis: sizeTransitionAxis ?? axis ?? kDefaultTransitionAxis,
      axisAlignment: sizeTransitionAxisAlignment,
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }
}

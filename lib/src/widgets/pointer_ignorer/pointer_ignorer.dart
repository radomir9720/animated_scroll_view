import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

/// {@template pointer_ignorer}
/// Widget that decides whether to ignore pointers(user touches), using
/// [animation] data and [ignoreCondition].
/// {@endtemplate}
class PointerIgnorer extends StatelessWidget {
  /// Creates a [PointerIgnorer]
  const PointerIgnorer({
    super.key,
    required this.child,
    required this.animation,
    this.ignoreCondition = kDefaultIgnoreCondition,
  });

  /// Child widget, which contains gesture detectors
  @protected
  final Widget child;

  /// Animation, based on which will be taken the decision whether to
  /// ignore pointers or not
  @protected
  final DoubleAnimation animation;

  /// Condition, based on which will be taken the decision whether to
  /// ignore pointers or not
  ///
  /// Defaults to [PointerIgnorer.kDefaultIgnoreCondition]
  ///
  /// See also:
  ///  * [OperationPointerIgnoreCondition]
  ///  * [StaticPointerIgnoreCondition]
  @protected
  final PointerIgnoreCondition ignoreCondition;

  /// Default pointer ignore condition.
  ///
  /// If the animation value is below `1`, then pointers will be
  /// ignored, otherwise pointers will be passed further, down the tree.
  static const kDefaultIgnoreCondition = OperationPointerIgnoreCondition(
    value: 1,
    operation: Operation.greaterThan,
  );

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return IgnorePointer(
          ignoring: ignoreCondition.check(animation.value),
          child: child,
        );
      },
      child: child,
    );
  }
}

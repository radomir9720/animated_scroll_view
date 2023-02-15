import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

class PointerIgnorer extends StatelessWidget {
  const PointerIgnorer({
    super.key,
    required this.child,
    required this.animation,
    this.ignoreCondition = kDefaultIgnoreCondition,
  });

  @protected
  final Widget child;

  @protected
  final Animation<double> animation;

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

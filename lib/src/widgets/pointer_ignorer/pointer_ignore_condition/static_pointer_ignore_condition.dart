import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:meta/meta.dart';

/// {@template static_pointer_ignore_condition}
/// {@macro pointer_ignore_condition}.
///
/// Implementation of [PointerIgnoreCondition].
///
/// The decision whether to ignore pointers is provided by a boolean parameter
/// [ignore] through constructor.
/// {@endtemplate}
class StaticPointerIgnoreCondition implements PointerIgnoreCondition {
  /// Creates a [StaticPointerIgnoreCondition]
  const StaticPointerIgnoreCondition({this.ignore = false});

  /// Whether to ignore pointers or not
  ///
  /// Defaults to `false`
  @protected
  final bool ignore;

  @override
  bool check(double animationValue) => ignore;
}

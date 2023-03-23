/// {@template pointer_ignore_condition}
/// Class, designated to decide whether to ignore pointers or not.
/// {@endtemplate}
abstract class PointerIgnoreCondition {
  /// Base constructor
  const PointerIgnoreCondition();

  /// Returns `true`, if pointers should be ignored, otherwise - `false`
  bool check(double animationValue);
}

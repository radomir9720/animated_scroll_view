import 'package:animated_scroll_view/animated_scroll_view.dart';

class AlwaysFalsePointerIgnoreCondition implements PointerIgnoreCondition {
  const AlwaysFalsePointerIgnoreCondition();
  @override
  bool check(double animationValue) => false;
}

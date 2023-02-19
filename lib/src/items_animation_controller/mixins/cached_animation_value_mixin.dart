import 'package:animated_scroll_view/animated_scroll_view.dart';

mixin CachedAnimationValueMixin on ItemsAnimationController {
  final _cachedAnimationValueMap = <String, double>{};

  @override
  Map<String, double> get cachedAnimationValue => _cachedAnimationValueMap;
}

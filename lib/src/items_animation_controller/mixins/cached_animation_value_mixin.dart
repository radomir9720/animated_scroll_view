import 'package:animated_scroll_view/animated_scroll_view.dart';

/// Mixin, that implements [ItemsAnimationController.cachedAnimationValue]
/// getter
mixin CachedAnimationValueMixin on ItemsAnimationController {
  final _cachedAnimationValueMap = <String, double>{};

  @override
  Map<String, double> get cachedAnimationValue => _cachedAnimationValueMap;
}

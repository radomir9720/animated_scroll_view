import 'package:animated_scroll_view/src/utils/debouncer.dart';

mixin DebouncerMixin {
  Debouncer? _debouncer;

  int get debounceDurationMillis;

  Debouncer get debouncer =>
      _debouncer ??= Debouncer(milliseconds: debounceDurationMillis);
}

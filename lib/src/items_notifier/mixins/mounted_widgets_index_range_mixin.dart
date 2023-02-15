import 'package:animated_scroll_view/animated_scroll_view.dart';

mixin MountedWidgetsIndexRangeMixin {
  IndexRange _mountedWidgetsIndexRange = const IndexRange.initial();

  bool updateMountedWidgetsIndexRange(IndexRange newIndexRange) {
    if (_mountedWidgetsIndexRange == newIndexRange) return false;
    _mountedWidgetsIndexRange = newIndexRange;
    return true;
  }

  IndexRange get mountedWidgetsIndexRange => _mountedWidgetsIndexRange;
}

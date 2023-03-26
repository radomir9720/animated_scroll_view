import 'package:animated_scroll_view/animated_scroll_view.dart';

/// Mixin, which implements [ItemsNotifier.mountedWidgetsIndexRange] getter
mixin MountedWidgetsIndexRangeMixin<T> on ItemsNotifier<T> {
  IndexRange _mountedWidgetsIndexRange = const IndexRange.zero();

  /// Sets new index range of mounted/laid out/visible widgets.
  ///
  /// Returns `true` if [newIndexRange] is not equal to old index range.
  /// Otherwise - `false`
  bool updateMountedWidgetsIndexRange(IndexRange newIndexRange) {
    if (_mountedWidgetsIndexRange == newIndexRange) return false;
    _mountedWidgetsIndexRange = newIndexRange;
    return true;
  }

  @override
  IndexRange get mountedWidgetsIndexRange => _mountedWidgetsIndexRange;
}

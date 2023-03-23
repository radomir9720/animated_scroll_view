import 'package:animated_scroll_view/animated_scroll_view.dart';

/// Mixin, which helps validating item's index
mixin CheckInsertIndexIsValidMixin<T> on ModificationEvent<T> {
  /// If index is less than zero, or greater than item list length, then
  /// throws [InvalidInsertionIndexException].
  ///
  /// Otherwise does nothing(means that index is valid).
  void throwIfIndexIsInvalid(ItemsNotifier<T> itemsNotifier, int index) {
    final length = itemsNotifier.actualList.length;
    if (index < 0 || index > length) {
      throw InvalidInsertionIndexException(
        itemListLength: length,
        index: index,
      );
    }
  }
}

/// Descendant of [AnimatedScrollViewException].
///
/// Should be thrown when was provided an invalid index.
class InvalidInsertionIndexException extends AnimatedScrollViewException {
  /// Creates a [InvalidInsertionIndexException]
  const InvalidInsertionIndexException({
    required int itemListLength,
    required int index,
  }) : super(
          'Index should be greater than or equal to 0, '
          'and less than or equal to item list length. '
          'Item list length is $itemListLength. '
          'Provided index is: $index',
        );
}

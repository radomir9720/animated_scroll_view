import 'package:animated_scroll_view/animated_scroll_view.dart';

mixin CheckInsertIndexIsValidMixin<T> on ModificationEvent<T> {
  void throwIfIndexIsInvalid(ItemsNotifier<T> itemsNotifier, int index) {
    final length = itemsNotifier.value.length;
    if (index < 0 || index > length) {
      throw InvalidInsertionIndexException(
        itemListLength: length,
        index: index,
      );
    }
  }
}

class InvalidInsertionIndexException extends AnimatedScrollViewException {
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

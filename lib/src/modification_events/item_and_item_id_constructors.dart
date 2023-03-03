import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:meta/meta.dart';

abstract class ModificationEventWithItemAndItemIdConstructors<T>
    implements ModificationEvent<T> {
  const ModificationEventWithItemAndItemIdConstructors(this.item)
      : itemId = null;

  ModificationEventWithItemAndItemIdConstructors.byId(this.itemId)
      : item = null;

  final String? itemId;

  final T? item;

  @protected
  @visibleForTesting
  String getItemId(IDMapper<T> idMapper) {
    return itemId ??
        idMapper(
          ArgumentError.checkNotNull(
            item,
            'Either "item" or "itemId" should be specified',
          ),
        );
  }
}

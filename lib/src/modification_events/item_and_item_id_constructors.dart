import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:meta/meta.dart';

/// {@template modification_event_with_item_and_item_id_constructors}
/// Descendant of [ModificationEvent].
///
/// Implements [getItemId] method, and two constructors:
/// 1. Item constructor(takes an item as parameter)
/// 2. ItemId constructor(takes an itemId as parameter)
/// {@endtemplate}
abstract class ModificationEventWithItemAndItemIdConstructors<T>
    implements ModificationEvent<T> {
  /// Creates a [ModificationEvent] using given instance of [item]
  const ModificationEventWithItemAndItemIdConstructors(this.item)
      : itemId = null;

  /// Creates a [ModificationEvent] using given [itemId]
  ModificationEventWithItemAndItemIdConstructors.byId(this.itemId)
      : item = null;

  /// The id of the item. [itemId] is not null only of the current instance
  /// of [ModificationEvent] is created using the `byId` constructor.
  final String? itemId;

  /// The item. [item] is not null only if the current instance of
  /// [ModificationEvent] is created using the default constructor.
  final T? item;

  /// Returns the id of the item.
  ///
  /// If the current instance of [ModificationEvent] is created using the
  /// `byId` constructor, then it returns [itemId], otherwise, it generates
  /// the id using [idMapper] and [item](as it should not be null).
  ///
  /// In case of it is null, throws an [ArgumentError].
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

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

/// {@template items_notifier}
///
/// A listenable, which notifies its listeners about item list modifications.
///
/// General purpose is to wrap the scrollable widget
/// (see in [AnimatedScrollView]), so the scrollable is rebuilt when it should.
///
/// It is intended to notify listeners NOT on every [value] update, but when
/// it is convinient to notify. For example, if we have scrolled the scrollable
/// widget to its bottom, and there are some items atop that are disposed
/// (because scrollables, provided by this package use under the hood builders,
/// and builders build the children on demand. You can read more in `ListView`'s
/// docstring), then, when we will, for example, add some item atop of
/// the current layout(visible area) and will notify the scrollable widget
/// immediately, scroll offset will make a jump:
///
///  ![](https://raw.githubusercontent.com/radomir9720/animated_scroll_view/master/doc/images/animated_list_offset_jump_demo.gif)
///
/// The [DefaultItemsNotifier] solves this problem.
///
/// If you want to get updated item list as soon as it was
/// modified, consider using [ItemsNotifier.onItemsUpdate] callback
/// instead  of listening the notifier.
///
/// If you want just to get the current item list, please use
/// [ItemsNotifier.actualList] getter instead of [ItemsNotifier.value]
///
/// {@endtemplate}
abstract class ItemsNotifier<T> extends ChangeNotifier
    implements ValueListenable<List<ModificatedItem<T>>> {
  /// {@macro items_notifier}
  ItemsNotifier({this.onItemsUpdate});

  /// {@macro animated_scroll_view.id_mapper}
  IDMapper<T> get idMapper;

  /// Callback, which is called whenever the list of items([value]) is updated
  /// (i.e. after adding/removing some element)
  ///
  /// Consider using this callback instead  of listening the notifier.
  @protected
  void Function(List<T> updatedList)? onItemsUpdate;

  /// Sets the [IDMapper]:
  ///
  /// {@macro animated_scroll_view.id_mapper}
  @internal
  set idMapper(IDMapper<T> idMapper);

  /// Sets new visible area/layout/range of widgets, that has been laid out.
  ///
  /// This can be useful when it is need to know which widget(item) is
  /// visible/laid out/mounted, and which is not(e. g. to decide whether
  /// the [notifyListeners()] method should be called or not)
  ///
  /// See also:
  /// - [ScrollViewSliverChildBuilderDelegate]
  @internal
  void mountedWidgetsIndexRangeChanged(IndexRange newIndexRange);

  /// Returns index range of visible/laid out/mounted items
  ///
  /// See also:
  /// - [ScrollViewSliverChildBuilderDelegate]
  /// - [ItemsNotifier.mountedWidgetsIndexRangeChanged]
  IndexRange get mountedWidgetsIndexRange;

  /// The current value of the object.
  ///
  /// Take into account that this notifier **MAY NOT** send notification to its
  /// listeners every time when the item list is modified.
  /// Consider using [onItemsUpdate] callback instead  of listening
  /// the notifier.
  ///
  /// Also, if you want just to get the current item list, please use
  /// [ItemsNotifier.actualList] getter instead of this getter
  @override
  List<ModificatedItem<T>> get value;

  /// The actual item list
  List<T> get actualList;

  /// Sets new value(updates the item list)
  ///
  /// If [forceNotify] is `true`,
  /// then update notification is sent immediately to listeners
  ///
  /// [forceNotify] defaults to `false`.
  void updateValue(List<T> items, {bool forceNotify = false});

  /// Inserts new item at specified [index].
  ///
  /// {@template items_notifier.force_notify}
  /// If [forceNotify] is `true`,
  /// then update notification is sent immediately to listeners
  ///
  /// [forceNotify] defaults to `false`.
  /// {@endtemplate}
  ///
  /// {@template items_notifier.modification_id}
  /// [modificationId] is optional. It is expected to pass an id, that will
  /// help in the UI part to find and get the correspondent for this item
  /// animation
  /// {@endtemplate}
  void insert(
    int index,
    T item, {
    bool forceNotify = false,
    String? modificationId,
  });

  /// Inserts a list of items at the specified [index].
  ///
  /// {@macro items_notifier.force_notify}
  ///
  /// {@macro items_entity.forceVisible}
  ///
  /// [forceVisible] defaults to `false`.
  ///
  /// [items] is a [MapEntry] list, key of which is the item, value -
  /// modification ID(optional).
  ///
  /// {@macro items_notifier.modification_id}
  void insertAll(
    int index,
    List<MapEntry<T, String?>> items, {
    bool forceNotify = false,
    bool forceVisible = false,
  });

  /// Marks an item as removed. It means that in the future is expected to
  /// remove this item from list. It is not removed immediately, because the
  /// remove animation should be executed before remove.
  ///
  /// After animation execution it's expected to call one of remove
  /// methods([removeAt], [removeById], [remove])
  ///
  /// {@macro items_notifier.force_notify}
  ///
  /// {@macro items_notifier.modification_id}
  T markRemovedById(
    String itemId, {
    bool forceNotify = false,
    String? modificationId,
  });

  /// Removes instantly items at the specified range.
  ///
  /// Returns removed item list.
  ///
  /// {@macro items_notifier.force_notify}
  List<T> removeRangeInstantly(
    int start,
    int end, {
    bool forceNotify = false,
  });

  /// Removes an item at specified index.
  ///
  /// {@macro items_notifier.force_notify}
  T removeAt(int index, {bool forceNotify = false});

  /// Removes an item by its [itemId]
  ///
  /// {@macro items_notifier.force_notify}
  T removeById(String itemId, {bool forceNotify = false});

  /// Removes the item from item list
  ///
  /// {@macro items_notifier.force_notify}
  void remove(T item, {bool forceNotify = false});

  /// Returns item's index by its [itemId]
  int getIndexById(String itemId);
}

/// {@template item_not_found_exception}
/// Exception, which is thrown when an item is not found in item list.
/// {@endtemplate}
class ItemNotFoundException extends AnimatedScrollViewException {
  /// {@macro item_not_found_exception}
  const ItemNotFoundException(String id, {String? fixPresumption})
      : super(
          'Could not find item with id: '
          '$id${fixPresumption == null ? '' : ' $fixPresumption'}',
        );
}

/// {@template marked_as_removed_item_not_found_exception}
/// {@macro item_not_found_exception}
///
/// This exception is thrown when it is attempted to find an item, marked as
/// removed, but it is not found.
/// {@endtemplate}
class MarkedAsRemovedItemNotFoundException extends ItemNotFoundException {
  /// {@macro marked_as_removed_item_not_found_exception}
  const MarkedAsRemovedItemNotFoundException(super.id)
      : super(
          fixPresumption:
              'It is expected to remove items only after marking them '
              'to be removed. Did you do that?',
        );
}

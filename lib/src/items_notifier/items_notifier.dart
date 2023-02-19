import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

/// {@template items_notifier}
///
/// A listenable, which notifies its listeners about items list modifications.
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
/// immediatly, scroll offset will make a jump:
///
///  ![](https://raw.githubusercontent.com/radomir9720/animated_scroll_view/master/doc/images/animated_list_offset_jump_demo.gif)
///
/// The [DefaultItemsNotifier] solves this problem.
///
/// If you want to get new [value](updated items list) as soon as it was
/// modified, consider using [ItemsNotifier.onItemsUpdate] callback
/// instead  of listening the notifier.
///
/// {@endtemplate}
abstract class ItemsNotifier<T> extends ChangeNotifier
    implements ValueListenable<List<T>> {
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
  /// See alos:
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
  /// listeners every time when [value] changed.
  /// Consider using [onItemsUpdate] callback instead  of listening
  /// the notifier.
  @override
  List<T> get value;

  /// Sets new value(updates the item list)
  ///
  /// If [forceNotify] is `true`,
  /// then update notification is sent immediatly to listeners
  /// [forceNotify] defaults to `false`.
  void updateValue(List<T> items, {bool forceNotify = false});

  /// Inserts new item at specified index.
  ///
  /// If [forceNotify] is `true`,
  /// then update notification is sent immediatly to listeners
  /// [forceNotify] defaults to `true`.
  void insert(int index, T item, {bool forceNotify = true});

  /// Removes an item at specified index.
  /// If [forceNotify] is `true`,
  /// then update notification is sent immediatly to listeners
  /// [forceNotify] defaults to `true`.
  T removeAt(int index, {bool forceNotify = true});

  /// Removes an item by its [itemId]
  ///
  /// If [forceNotify] is `true`,
  /// then update notification is sent immediatly to listeners
  /// [forceNotify] defaults to `true`.
  T removeById(String itemId, {bool forceNotify = true});

  /// Removes the item from items list
  ///
  /// If [forceNotify] is `true`,
  /// then update notification is sent immediatly to listeners
  /// [forceNotify] defaults to `true`.
  void remove(T item, {bool forceNotify = true});

  /// Returns item's index by it's [itemId]
  int getIndexById(String itemId);
}

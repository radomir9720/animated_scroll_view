import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class DefaultItemsNotifier<T> extends ItemsNotifier<T>
    with IDMapperMixin, ItemsBuildQueueMixin, MountedWidgetsIndexRangeMixin {
  DefaultItemsNotifier({
    super.onItemsUpdate,
    List<T> items = const [],
  })  : _items = [...items],
        _draftItems = [...items];

  bool _notifying = false;

  List<T> _items;
  List<T> _draftItems;

  @override
  void mountedWidgetsIndexRangeChanged(IndexRange newIndexRange) {
    if (updateMountedWidgetsIndexRange(newIndexRange)) {
      _notifyIfNeedTo();
    }
  }

  @override
  int getIndexById(String itemId) {
    final index = _draftItems.indexWhere(
      (element) => itemId == idMapper(element),
    );

    if (index == -1) throw ItemNotFoundException(itemId);

    return index;
  }

  @override
  T removeAt(int index, {bool forceNotify = true}) {
    final i = _draftItems.removeAt(index);

    _onItemsUpdate(forceNotify);
    return i;
  }

  @override
  T removeById(String itemId, {bool forceNotify = true}) {
    final index = getIndexById(itemId);
    final i = removeAt(index, forceNotify: forceNotify);
    return i;
  }

  @override
  void remove(T item, {bool forceNotify = true}) {
    if (!_draftItems.remove(item)) throw ItemNotFoundException(idMapper(item));
    _onItemsUpdate(forceNotify);
  }

  @override
  void insert(int index, T item, {bool forceNotify = false}) {
    addItemToBuildQueue(index, item);
    _draftItems.insert(index, item);
    onItemsUpdate?.call(_draftItems);
    _notifyIfNeedTo(forceNotify: forceNotify);
  }

  @override
  List<T> get value => _items;

  void _notifyIfNeedTo({bool forceNotify = false}) {
    if (_notifying) return;
    if (itemsBuildQueue.isEmpty) return;
    _notifying = true;
    final entries = [...itemsBuildQueue.entries];
    var notify = forceNotify;
    for (final entry in entries) {
      final index = entry.key;
      if (index >= mountedWidgetsIndexRange.start) {
        itemsBuildQueue.remove(index);
        notify = true;
      }
    }

    if (notify) {
      Future.microtask(() {
        _items = [..._draftItems];
        notifyListeners();
      });
    }
    _notifying = false;
  }

  void _onItemsUpdate(bool notify) {
    onItemsUpdate?.call(_draftItems);
    if (notify) {
      _items = [..._draftItems];
      notifyListeners();
    }
  }

  @override
  void updateValue(List<T> items, {bool forceNotify = false}) {
    if (const DeepCollectionEquality().equals(_draftItems, items)) return;
    _items = [...items];
    _draftItems = [...items];
    _onItemsUpdate(forceNotify);
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class ItemNotFoundException extends AnimatedScrollViewException {
  const ItemNotFoundException(String id)
      : super('Could not find item with id: $id');
}

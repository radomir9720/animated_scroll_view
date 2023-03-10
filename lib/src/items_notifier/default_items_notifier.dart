import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// {@template default_items_notifier}
/// {@macro items_notifier}
///
/// This is the default implementation of [ItemsNotifier]
/// {@endtemplate}
class DefaultItemsNotifier<T> extends ItemsNotifier<T>
    with IDMapperMixin<T>, MountedWidgetsIndexRangeMixin {
  /// {@macro default_items_notifier}
  DefaultItemsNotifier({
    super.onItemsUpdate,
    List<T> items = const [],
  }) : _itemsEntity = ItemsEntity<T>(items);

  bool _notifying = false;

  ItemsEntity<T> _itemsEntity;

  @override
  set idMapper(IDMapper<T> idMapper) {
    _itemsEntity.idMapper = idMapper;
    super.idMapper = idMapper;
  }

  @override
  void mountedWidgetsIndexRangeChanged(IndexRange newIndexRange) {
    if (updateMountedWidgetsIndexRange(newIndexRange)) {
      _notifyIfNeedTo();
    }
  }

  @override
  int getIndexById(String itemId) {
    final index = _itemsEntity.indexWhere(
      (element) => itemId == idMapper(element),
    );

    if (index == -1) throw ItemNotFoundException(itemId);

    return index;
  }

  @override
  T removeAt(int index, {bool forceNotify = true}) {
    final i = _itemsEntity.removeItemAt(
      index: index,
      mountedRange: mountedWidgetsIndexRange,
    );

    _onItemsUpdate(forceNotify);
    return i;
  }

  @override
  T removeById(String itemId, {bool forceNotify = true}) {
    final item = _itemsEntity.removeItemById(
      id: itemId,
      mountedRange: mountedWidgetsIndexRange,
    );
    _onItemsUpdate(forceNotify);
    return item;
  }

  @override
  void remove(T item, {bool forceNotify = true}) {
    _itemsEntity.removeItem(item: item, mountedRange: mountedWidgetsIndexRange);
    _onItemsUpdate(forceNotify);
  }

  @override
  void insert(int index, T item, {bool forceNotify = false}) {
    final displayImmediately = _itemsEntity.insertItem(
      index: index,
      element: item,
      mountedRange: mountedWidgetsIndexRange,
    );
    _updateActual();
    _notifyIfNeedTo(forceNotify: forceNotify || displayImmediately);
  }

  @override
  List<T> get value => _itemsEntity.visibleItems;

  void _updateActual() => onItemsUpdate?.call(_itemsEntity);

  void _notifyIfNeedTo({bool forceNotify = false}) {
    if (_notifying) return;
    _notifying = true;
    final notify =
        _itemsEntity.makeVisible(mountedWidgetsIndexRange) || forceNotify;

    if (notify) Future.microtask(notifyListeners);

    _notifying = false;
  }

  void _onItemsUpdate(bool notify) {
    _updateActual();
    if (notify) notifyListeners();
  }

  @override
  void updateValue(List<T> items, {bool forceNotify = false}) {
    if (const DeepCollectionEquality().equals(_itemsEntity, items)) return;

    _itemsEntity = ItemsEntity(items);
    _onItemsUpdate(forceNotify);
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

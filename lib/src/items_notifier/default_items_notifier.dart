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
  List<T> get actualList => _itemsEntity.actualItems;

  @override
  void mountedWidgetsIndexRangeChanged(IndexRange newIndexRange) {
    if (updateMountedWidgetsIndexRange(newIndexRange)) _notifyIfNeedTo();
  }

  @override
  int getIndexById(String itemId) {
    final index = _itemsEntity.actualItems.indexWhere(
      (element) => itemId == idMapper(element),
    );

    if (index == -1) throw ItemNotFoundException(itemId);

    return index;
  }

  @override
  T removeAt(int index, {bool forceNotify = false}) {
    final result = _itemsEntity.removeItemAt(
      index: index,
      mountedRange: mountedWidgetsIndexRange,
    );

    _onModifyResult(result, forceNotify: forceNotify);
    return result.item;
  }

  @override
  T removeById(String itemId, {bool forceNotify = false}) {
    final result = _itemsEntity.removeItemById(
      id: itemId,
      mountedRange: mountedWidgetsIndexRange,
    );

    _onModifyResult(result, forceNotify: forceNotify);

    return result.item;
  }

  @override
  T markRemovedById(
    String itemId, {
    bool forceNotify = false,
    String? modificationId,
  }) {
    final result = _itemsEntity.markRemovedById(
      itemId,
      mountedWidgetsIndexRange,
      modificationId: modificationId,
    );

    _onModifyResult(result, forceNotify: forceNotify);

    return result.item;
  }

  @override
  void remove(T item, {bool forceNotify = false}) {
    final result = _itemsEntity.removeItem(
      item: item,
      mountedRange: mountedWidgetsIndexRange,
    );

    _onModifyResult(result, forceNotify: forceNotify);
  }

  @override
  void insert(
    int index,
    T item, {
    bool forceNotify = false,
    String? modificationId,
  }) {
    final result = _itemsEntity.insertItem(
      index: index,
      element: item,
      mountedRange: mountedWidgetsIndexRange,
      modificationId: modificationId,
    );

    _onModifyResult(result, forceNotify: forceNotify);
  }

  void _onModifyResult(
    ItemsEntityModificationResult<T> result, {
    bool forceNotify = false,
  }) {
    if (result.actualListChanged) _updateActual();
    if ((result.visibleItemsChanged || forceNotify) && !_notifying) {
      // notifyListeners();
      Future.microtask(notifyListeners);
    }
  }

  @override
  List<ModificatedItem<T>> get value => _itemsEntity.visibleItems;

  void _updateActual() => onItemsUpdate?.call(_itemsEntity.actualItems);

  void _notifyIfNeedTo({bool forceNotify = false}) {
    if (_notifying) return;
    _notifying = true;
    final notify =
        _itemsEntity.makeVisible(mountedWidgetsIndexRange) || forceNotify;
    if (notify) Future.microtask(notifyListeners);

    _notifying = false;
  }

  @override
  void updateValue(List<T> items, {bool forceNotify = false}) {
    if (const DeepCollectionEquality().equals(_itemsEntity, items)) return;

    _itemsEntity = ItemsEntity(items);
    _updateActual();
    if (forceNotify && !_notifying) notifyListeners();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

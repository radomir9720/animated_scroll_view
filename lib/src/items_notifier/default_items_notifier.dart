import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:animated_scroll_view/src/exceptions/animated_scroll_view_exception.dart';
import 'package:animated_scroll_view/src/items_notifier/mixins/id_mapper_mixin.dart';
import 'package:animated_scroll_view/src/items_notifier/mixins/queued_animation_mixin.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DefaultItemsNotifier<T> extends ItemsNotifier<T>
    with
        MountedWidgetsIndexRangeMixin,
        ItemsBuildQueueMixin<T>,
        QueuedAnimationMixin,
        IDMapperMixin<T>,
        DebouncerMixin {
  DefaultItemsNotifier({
    super.onItemsUpdate,
    List<T> items = const [],
    this.notifyDebounceDurationMillis = kNotifyDebounceDurationMillis,
  }) : _items = [...items];

  static const kNotifyDebounceDurationMillis = 50;

  bool _notifying = false;

  @protected
  @visibleForTesting
  final int notifyDebounceDurationMillis;

  @protected
  @visibleForTesting
  @override
  int get debounceDurationMillis => notifyDebounceDurationMillis;

  List<T> _items;

  @override
  void mountedWidgetsIndexRangeChanged(IndexRange newIndexRange) {
    if (updateMountedWidgetsIndexRange(newIndexRange)) {
      _notifyIfNeedTo();
    }
  }

  @override
  int getIndexById(String itemId) {
    final index = value.indexWhere(
      (element) => itemId == idMapper(element),
    );

    if (index == -1) throw ItemNotFoundException(itemId);

    return index;
  }

  @override
  T removeAt(int index, {bool forceNotify = true}) {
    final i = _items.removeAt(index);
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
    if (!_items.remove(item)) throw ItemNotFoundException(idMapper(item));
    _onItemsUpdate(forceNotify);
  }

  @override
  void insert(int index, T item, {bool forceNotify = true}) {
    addItemToBuildQueue(index, item);
    _items.insert(index, item);
    _onItemsUpdate(forceNotify);
    _notifyIfNeedTo();
  }

  @override
  List<T> get value => _items;

  void _notifyIfNeedTo() {
    if (_notifying) return;
    if (itemsBuildQueue.isEmpty) return;
    _notifying = true;
    final entries = [...itemsBuildQueue.entries];
    var notify = false;
    for (final entry in entries) {
      final index = entry.key;
      if (index >= mountedWidgetsIndexRange.start) {
        itemsBuildQueue.remove(index);
        notify = true;
      }
    }

    if (notify) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
    _notifying = false;
  }

  void _onItemsUpdate(bool notify) {
    onItemsUpdate?.call(_items);
    if (notify) debouncer.run(notifyListeners);
  }

  @override
  void updateValue(List<T> items, {bool forceNotify = false}) {
    if (const DeepCollectionEquality().equals(_items, items)) return;
    _items = [...items];
    _onItemsUpdate(forceNotify);
  }

  @override
  void dispose() {
    debouncer.dispose();
    super.dispose();
  }

  @override
  String toString() => '${describeIdentity(this)}($value)';
}

class ItemNotFoundException extends AnimatedScrollViewException {
  const ItemNotFoundException(String id)
      : super('Could not find item with id: $id');
}

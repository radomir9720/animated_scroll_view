import 'dart:collection';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:collection/collection.dart';

/// {@template items_entity}
/// List of items, that manages both the actual item list,
/// and the list of items, that should be displayed.
///
/// [ItemsEntity] is a descendant of [DelegatingList]. It's `source` keeps
/// the actual list of items.
///
/// To get the list of items that should be displayed use the [visibleItems]
/// getter.
/// {@endtemplate}
class ItemsEntity<T> extends DelegatingList<T> with IDMapperMixin<T> {
  /// {@macro items_entity}
  ItemsEntity(super.source);

  /// Keeps items, that should **NOT** be displayed yet,
  /// along with their indexes
  final _delayedInsertMap = SplayTreeMap<int, T>((a, b) => a.compareTo(b));

  /// Keeps the ids of items, that should **NOT** be displayed yet
  final _delayedInsertItemIds = <String>[];

  void _updateIndexesOnRemove(int removedIndex, IndexRange mountedRange) {
    final lastIndex = _delayedInsertMap.lastKey();
    if (lastIndex == null) return;
    if (removedIndex > lastIndex) return;
    final entries = [..._delayedInsertMap.entries].reversed;

    for (final entry in entries) {
      final index = entry.key;
      _delayedInsertMap.remove(index);
      if (index <= removedIndex) {
        if (index == removedIndex) {
          _delayedInsertItemIds.remove(idMapper(entry.value));
        }
        break;
      }

      _delayedInsertMap[index - 1] = entry.value;
    }
  }

  void _modifyIndexIfNeededAndInsert(int key, T value) {
    final decrementBy =
        _delayedInsertMap.keys.where((element) => element <= key).length;
    final newIndex = key - decrementBy;
    this[newIndex] = value;
  }

  /// Inserts an item to the item list.
  /// This method manages itself whether the item should be displayed
  /// immediately, or later.
  ///
  /// If the index of the item is not atop of the visible area, then the item
  /// will be displayed immediately, otherwise it will be added to
  /// [_delayedInsertItemIds] and [_delayedInsertMap], therefore, it won't be
  /// present in [visibleItems] list.
  ///
  /// Returns `true` if the item should be displayed immediately
  /// (is not atop of the visible area). Otherwise - `false`.
  bool insertItem({
    required int index,
    required T element,
    required IndexRange mountedRange,
  }) {
    super.insert(index, element);

    final shouldBeDisplayed = index >= mountedRange.start;
    if (!shouldBeDisplayed) {
      _delayedInsertItemIds.add(idMapper(element));
      _modifyIndexIfNeededAndInsert(index, element);
    }
    return shouldBeDisplayed;
  }

  /// Removes an item by its index.
  ///
  /// Updates indexes of hidden(not displayed) items.
  ///
  /// Returns removed item.
  T removeItemAt({
    required int index,
    required IndexRange mountedRange,
  }) {
    final e = super.removeAt(index);
    _updateIndexesOnRemove(index, mountedRange);
    return e;
  }

  /// Removes an item by its [id].
  ///
  /// Updates indexes of hidden(not displayed) items.
  ///
  /// Returns removed item.
  ///
  /// Throws [ItemNotFoundException] if the item with specified [id] is not
  /// found.
  T removeItemById({
    required String id,
    required IndexRange mountedRange,
  }) {
    final index = visibleItems.indexWhere((element) => idMapper(element) == id);
    if (index == -1) throw ItemNotFoundException(id);

    final item = visibleItems[index];
    final removed = remove(item);
    if (!removed) throw ItemNotFoundException(id);
    _updateIndexesOnRemove(index, mountedRange);
    return item;
  }

  /// Removes an item
  ///
  /// Updates indexes of hidden(not displayed) items.
  ///
  /// Throws [ItemNotFoundException] if the item is not found.
  void removeItem({
    required T item,
    required IndexRange mountedRange,
  }) {
    final index = visibleItems.indexWhere((element) => element == item);
    final id = idMapper(item);
    if (index == -1) throw ItemNotFoundException(id);

    final removed = remove(item);
    if (!removed) throw ItemNotFoundException(id);
    _updateIndexesOnRemove(index, mountedRange);
  }

  /// Ensures that all the items in the [indexRange] are visible.
  ///
  /// If some are not, makes them visible(removes them from
  /// [_delayedInsertItemIds] and [_delayedInsertMap]).
  ///
  /// Returns `true` if there was at least one item removed from
  /// [_delayedInsertItemIds] and [_delayedInsertMap](made visible).
  /// Otherwise - `false`.
  bool makeVisible(IndexRange indexRange) {
    final lastIndex = _delayedInsertMap.lastKey();
    if (lastIndex == null) return false;
    final start = indexRange.start;
    if (lastIndex < start) return false;

    _delayedInsertMap.removeWhere((key, value) {
      final remove = key >= start;
      if (remove) _delayedInsertItemIds.remove(idMapper(value));

      return remove;
    });

    return true;
  }

  /// Returns the list of items, that should be displayed
  List<T> get visibleItems => [
        for (final e in this)
          if (!_delayedInsertItemIds.contains(idMapper(e))) e
      ];

  @override
  bool remove(Object? value) => throw UnimplementedError();

  @override
  T removeAt(int index) => throw UnimplementedError();

  @override
  T removeLast() => throw UnimplementedError();

  @override
  void removeRange(int start, int end) => throw UnimplementedError();

  @override
  void removeWhere(bool Function(T p1) test) => throw UnimplementedError();

  @override
  void insert(int index, T element) => throw UnimplementedError();

  @override
  void insertAll(int index, Iterable<T> iterable) => throw UnimplementedError();

  @override
  void operator []=(int index, T value) => throw UnimplementedError();
}

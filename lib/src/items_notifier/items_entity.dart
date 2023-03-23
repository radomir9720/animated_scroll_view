import 'dart:collection';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:collection/collection.dart';
import 'package:meta/meta.dart';

/// {@template items_entity}
/// List of items, that manages both the actual item list,
/// and the list of items, that should be displayed.
///
/// [ItemsEntity] is a descendant of [DelegatingList]. It's `source` keeps
/// the actual list of [DelayedModificationWrapper].
///
/// To get the list of items that should be displayed use the [visibleItems]
/// getter.
///
/// To get the list of actual items use the [actualItems]
/// getter.
/// {@endtemplate}
class ItemsEntity<T> extends DelegatingList<DelayedModificationWrapper<T>>
    with IDMapperMixin<T> {
  /// {@macro items_entity}
  ItemsEntity(List<T> source)
      : _visibleItems = UnmodifiableListView(source.map(ModificatedItem.new)),
        _actualItems = UnmodifiableListView(source),
        _delayedModificationItemsIndexes = SortedIntSplayTreeSet.instance,
        super(source.map(DelayedModificationWrapper.none).toList());

  UnmodifiableListView<ModificatedItem<T>> _visibleItems;
  UnmodifiableListView<T> _actualItems;

  /// This set caches all the indexes's of items, that are NOT currently
  /// displayed(visible), but should be. And instead of iterating through
  /// [ItemsEntity], it is "cheaper" to just look into this `SplayTreeSet` of
  /// `int`'s, and see wheter should we update the state.
  SplayTreeSet<int> _delayedModificationItemsIndexes;

  /// Inserts an item to the item list.
  /// This method manages itself whether the item should be displayed
  /// immediately, or later.
  ///
  /// Returns [ItemsEntityModificationResult], which contains info about the
  /// modification
  ItemsEntityModificationResult<T> insertItem({
    required int index,
    required T element,
    required IndexRange mountedRange,
    String? modificationId,
  }) {
    final shouldBeDisplayed = index >= mountedRange.start;
    final wrapper = shouldBeDisplayed
        ? DelayedModificationWrapper.none(
            element,
            modificationId: modificationId,
          )
        : DelayedModificationWrapper.insert(
            element,
            modificationId: modificationId,
          );
    super.insert(
      index,
      wrapper,
    );

    _updateCachedLists();

    return ItemsEntityModificationResult(
      actualListChanged: true,
      visibleItemsChanged: shouldBeDisplayed,
      item: wrapper.value,
    );
  }

  ItemsEntityModificationResult<T> _removeById(
    String id,
    IndexRange mountedRange,
  ) {
    final actualIndex = indexWhere(
      (e) => idMapper(e.value) == id && e is _MarkedAsRemovedWrapper<T>,
    );
    final visibleIndex =
        _visibleItems.indexWhere((e) => idMapper(e.value) == id);

    if (actualIndex == -1) throw MarkedAsRemovedItemNotFoundException(id);

    final wrapper = super.removeAt(actualIndex);

    _updateCachedLists();

    return ItemsEntityModificationResult(
      actualListChanged: false,
      visibleItemsChanged: visibleIndex >= mountedRange.start,
      item: wrapper.value,
    );
  }

  /// Marks the item with specified [id] as removed(in some cases the item
  /// could be removed immediately).
  ///
  /// The general purpose of this method is to say that the item will be removed
  /// in the future. This delayed remove is neccessary because before the item
  /// will be removed, it should animate, and if we will remove the item
  /// instantly, of course, it will be removed without animation.
  ItemsEntityModificationResult<T> markRemovedById(
    String id,
    IndexRange mountedRange, {
    String? modificationId,
  }) {
    final actualIndex = indexWhere((e) => idMapper(e.value) == id);
    final visibleIndex =
        _visibleItems.indexWhere((e) => idMapper(e.value) == id);

    if (actualIndex == -1) throw ItemNotFoundException(id);

    final wrapper = this[actualIndex];

    final item = wrapper.value;

    if (wrapper is _InsertWrapper) {
      super.removeAt(actualIndex);

      _updateCachedLists();

      return ItemsEntityModificationResult(
        actualListChanged: true,
        visibleItemsChanged: false,
        item: item,
      );
    }

    super[actualIndex] = DelayedModificationWrapper.markedAsRemoved(
      item,
      modificationId: modificationId,
    );

    _updateCachedLists();

    return ItemsEntityModificationResult(
      actualListChanged: true,
      visibleItemsChanged: visibleIndex >= mountedRange.start,
      item: item,
    );
  }

  /// Removes an item by its index.
  ///
  /// Returns [ItemsEntityModificationResult], which contains info about the
  /// modification
  ItemsEntityModificationResult<T> removeItemAt({
    required int index,
    required IndexRange mountedRange,
  }) {
    final item = visibleItems[index];
    final id = idMapper(item.value);

    return _removeById(id, mountedRange);
  }

  /// Removes an item by its [id].
  ///
  /// Returns [ItemsEntityModificationResult], which contains info about the
  /// modification
  ItemsEntityModificationResult<T> removeItemById({
    required String id,
    required IndexRange mountedRange,
  }) {
    return _removeById(id, mountedRange);
  }

  /// Removes an item
  ///
  /// Returns [ItemsEntityModificationResult], which contains info about the
  /// modification
  ItemsEntityModificationResult<T> removeItem({
    required T item,
    required IndexRange mountedRange,
  }) {
    return _removeById(idMapper(item), mountedRange);
  }

  /// Ensures that all the items in the [indexRange] are visible.
  ///
  /// If some are not, makes them visible.
  ///
  /// Returns `true` if there was at least one item with delayed modification in
  /// the specified [indexRange]. Otherwise - `false`.
  bool makeVisible(IndexRange indexRange) {
    final lastIndex = _delayedModificationItemsIndexes.lastOrNull;
    // If there are no items for provided [indexRange], that should be turned
    // from invisible to visible, then there is no reason to execute this method
    // further
    if (lastIndex == null) return false;

    // If the last item index, that should be turned from invisible to
    // visible, is less than first mounted index, then there is not reason
    // to execute this method further(because there will be no changes in
    // current item's list)
    if (lastIndex < indexRange.start) return false;

    var modified = false;
    final newList = <DelayedModificationWrapper<T>>[];

    _updateCachedLists(
      (item, i) {
        if (i < indexRange.start) {
          newList.add(item);
          return item;
        }

        return item.when(
          none: () {
            newList.add(item);
            return item;
          },
          insert: () {
            modified = true;
            final newItem = DelayedModificationWrapper.none(
              item.value,
              modificationId: item.modificationId,
            );
            newList.add(newItem);
            return newItem;
          },
          markedAsRemoved: () {
            modified = true;
            newList.add(item);
            return item;
          },
        );
      },
    );

    this
      ..clear()
      ..addAll(newList);

    return modified;
  }

  void _updateCachedLists([
    DelayedModificationWrapper<T> Function(
      DelayedModificationWrapper<T> item,
      int index,
    )?
        mapper,
  ]) {
    final visibleItems = <ModificatedItem<T>>[];
    final actualItems = <T>[];
    final delayedModificationItemsIndexes = SortedIntSplayTreeSet.instance;
    for (var i = 0; i < length; i++) {
      final item = mapper?.call(this[i], i) ?? this[i];
      if (item.visible) {
        visibleItems.add(
          ModificatedItem(
            item.value,
            modificationId: item.modificationId,
          ),
        );
      } else {
        delayedModificationItemsIndexes.add(i);
      }

      if (item.presentInActualList) {
        actualItems.add(item.value);
      } else {
        delayedModificationItemsIndexes.add(i);
      }
    }

    _visibleItems = UnmodifiableListView(visibleItems);
    _actualItems = UnmodifiableListView(actualItems);
    _delayedModificationItemsIndexes = delayedModificationItemsIndexes;
  }

  /// Returns the list of items, that should be displayed
  List<ModificatedItem<T>> get visibleItems => _visibleItems;

  /// Returns the actual list of items
  List<T> get actualItems => _actualItems;

  @override
  bool remove(Object? value) => throw UnimplementedError();

  @override
  DelayedModificationWrapper<T> removeAt(int index) =>
      throw UnimplementedError();

  @override
  DelayedModificationWrapper<T> removeLast() => throw UnimplementedError();

  @override
  void removeRange(int start, int end) => throw UnimplementedError();

  @override
  void removeWhere(bool Function(DelayedModificationWrapper<T> p1) test) =>
      throw UnimplementedError();

  @override
  void insert(int index, DelayedModificationWrapper<T> element) =>
      throw UnimplementedError();

  @override
  void insertAll(int index, Iterable<DelayedModificationWrapper<T>> iterable) =>
      throw UnimplementedError();

  @override
  void operator []=(int index, DelayedModificationWrapper<T> value) =>
      throw UnimplementedError();
}

/// Extension that makes easy to create an sorder [SplayTreeSet] of `int`'s
extension SortedIntSplayTreeSet on SplayTreeSet<int> {
  /// Returns a new instance of [SplayTreeSet] of type `int`, sorted ascending
  static SplayTreeSet<int> get instance =>
      SplayTreeSet<int>((a, b) => a.compareTo(b));
}

/// {@template items_entity_modification_result}
/// Model, that contains info about an item modification:
///
/// 1. The [item] itself
/// 2. Wheter [ItemsEntity().actualList] changed
/// 3. Wheter [ItemsEntity().visibleItems] changed
/// {@endtemplate}
@sealed
@immutable
class ItemsEntityModificationResult<T> {
  /// Creates an [ItemsEntityModificationResult]
  const ItemsEntityModificationResult({
    required this.actualListChanged,
    required this.visibleItemsChanged,
    required this.item,
  });

  /// Wheter [ItemsEntity().actualList] changed
  final bool actualListChanged;

  /// Wheter [ItemsEntity().visibleItems] changed
  final bool visibleItemsChanged;

  /// The item, which was modified
  final T item;
}

/// {@template delayed_modification_wrapper}
/// Wrapper of an item of type [T].
///
/// Contains info about the modification type, and [modificationId].
/// {@endtemplate}
@immutable
abstract class DelayedModificationWrapper<T> {
  /// Creates a [DelayedModificationWrapper]
  const DelayedModificationWrapper(this.value, {this.modificationId});

  /// Creates a wrapper, that tells that the [value] should NOT be modified
  const factory DelayedModificationWrapper.none(
    T value, {
    String? modificationId,
  }) = _NoneDelayedModificationWrapper;

  /// Creates a wrapper, that tells that the [value] should be removed in the
  /// future
  const factory DelayedModificationWrapper.markedAsRemoved(
    T value, {
    String? modificationId,
  }) = _MarkedAsRemovedWrapper;

  /// Creates a wrapper, that tells that the [value] should be inserted in the
  /// future
  const factory DelayedModificationWrapper.insert(
    T value, {
    String? modificationId,
  }) = _InsertWrapper;

  /// The item
  final T value;

  /// ID of the modification
  final String? modificationId;

  /// Pattern matching function by type. Executes the corresponding to
  /// the type callback, and returns the result of it.
  R when<R>({
    required R Function() none,
    required R Function() insert,
    required R Function() markedAsRemoved,
  });

  /// Wheter the [value] should be visible
  bool get visible;

  /// Wheter the [value] should be present in actual item list
  bool get presentInActualList;
}

class _NoneDelayedModificationWrapper<T> extends DelayedModificationWrapper<T> {
  const _NoneDelayedModificationWrapper(super.value, {super.modificationId});

  @override
  R when<R>({
    required R Function() none,
    required R Function() insert,
    required R Function() markedAsRemoved,
  }) {
    return none();
  }

  @override
  bool get visible => true;

  @override
  bool get presentInActualList => true;
}

class _MarkedAsRemovedWrapper<T> extends DelayedModificationWrapper<T> {
  const _MarkedAsRemovedWrapper(super.value, {super.modificationId});

  @override
  R when<R>({
    required R Function() none,
    required R Function() insert,
    required R Function() markedAsRemoved,
  }) {
    return markedAsRemoved();
  }

  @override
  bool get visible => true;

  @override
  bool get presentInActualList => false;
}

class _InsertWrapper<T> extends DelayedModificationWrapper<T> {
  const _InsertWrapper(super.value, {super.modificationId});

  @override
  R when<R>({
    required R Function() none,
    required R Function() insert,
    required R Function() markedAsRemoved,
  }) {
    return insert();
  }

  @override
  bool get visible => false;

  @override
  bool get presentInActualList => true;
}

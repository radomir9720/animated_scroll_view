mixin ItemsBuildQueueMixin<T> {
  final Map<int, List<T>> itemsBuildQueue = {};

  void addItemToBuildQueue(int index, T item) {
    final curr = itemsBuildQueue[index];
    itemsBuildQueue[index] = [...?curr, item];
  }
}

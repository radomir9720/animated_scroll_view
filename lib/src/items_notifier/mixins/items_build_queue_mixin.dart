import 'package:animated_scroll_view/animated_scroll_view.dart';

mixin ItemsBuildQueueMixin<T> on ItemsNotifier<T> {
  final Map<int, List<T>> itemsBuildQueue = {};

  void addItemToBuildQueue(int index, T item) {
    final curr = itemsBuildQueue[index];
    itemsBuildQueue[index] = [...?curr, item];
  }
}

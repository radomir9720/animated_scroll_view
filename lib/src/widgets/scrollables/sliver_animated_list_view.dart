import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

/// {@template sliver_animated_list_view}
/// Descendant of [AnimatedScrollView].
///
/// Implements animated [SliverList].
/// {@endtemplate}
class SliverAnimatedListView<T> extends AnimatedScrollView<T> {
  /// {@macro sliver_animated_list_view}
  SliverAnimatedListView({
    super.key,
    super.itemsNotifier,
    super.itemWrapper,
    super.itemsAnimationController,
    required super.items,
    required super.idMapper,
    required super.itemBuilder,
    required super.eventController,
    bool addSemanticIndexes = true,
    bool addRepaintBoundaries = true,
    bool addAutomaticKeepAlives = true,
    ChildIndexGetter? findChildIndexCallback,
  }) : super(
          scrollableBuilder: (
            itemCount,
            itemBuilder,
            onDidFinishLayoutCallback,
          ) {
            return SliverList(
              delegate: ScrollViewSliverChildBuilderDelegate(
                itemBuilder,
                childCount: itemCount,
                onDidFinishLayout: onDidFinishLayoutCallback,
                findChildIndexCallback: findChildIndexCallback,
                addAutomaticKeepAlives: addAutomaticKeepAlives,
                addRepaintBoundaries: addRepaintBoundaries,
                addSemanticIndexes: addSemanticIndexes,
              ),
            );
          },
        );
}

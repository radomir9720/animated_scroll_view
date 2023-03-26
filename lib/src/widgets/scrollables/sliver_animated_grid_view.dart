import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

/// {@template sliver_animated_list_view}
/// Descendant of [AnimatedScrollView].
///
/// Implements animated [SliverGrid].
/// {@endtemplate}
class SliverAnimatedGridView<T> extends AnimatedScrollView<T> {
  /// {@macro sliver_animated_list_view}
  SliverAnimatedGridView({
    super.key,
    super.itemsNotifier,
    required super.items,
    required super.idMapper,
    required super.itemBuilder,
    required super.eventController,
    required SliverGridDelegate gridDelegate,
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
            return SliverGrid(
              gridDelegate: gridDelegate,
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

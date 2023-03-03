import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// {@template animated_grid_view}
/// Descendant of [AnimatedScrollView].
///
/// Implements animated [GridView].
/// {@endtemplate}
class AnimatedGridView<T> extends AnimatedScrollView<T> {
  /// {@macro animated_grid_view}
  AnimatedGridView({
    super.key,
    super.itemsNotifier,
    required super.items,
    required super.idMapper,
    required super.itemBuilder,
    required super.eventController,
    required SliverGridDelegate gridDelegate,
    bool? primary,
    double? cacheExtent,
    bool reverse = false,
    String? restorationId,
    ScrollPhysics? physics,
    int? semanticChildCount,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    ScrollController? controller,
    Clip clipBehavior = Clip.hardEdge,
    Axis scrollDirection = Axis.vertical,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    //
    bool addSemanticIndexes = true,
    bool addRepaintBoundaries = true,
    bool addAutomaticKeepAlives = true,
    int? Function(Key)? findChildIndexCallback,
  }) : super(
          scrollableBuilder: (
            itemCount,
            itemBuilder,
            onDidFinishLayoutCallback,
          ) {
            return GridView.custom(
              gridDelegate: gridDelegate,
              childrenDelegate: ScrollViewSliverChildBuilderDelegate(
                itemBuilder,
                childCount: itemCount,
                onDidFinishLayout: onDidFinishLayoutCallback,
                findChildIndexCallback: findChildIndexCallback,
                addAutomaticKeepAlives: addAutomaticKeepAlives,
                addRepaintBoundaries: addRepaintBoundaries,
                addSemanticIndexes: addSemanticIndexes,
              ),
              reverse: reverse,
              padding: padding,
              primary: primary,
              physics: physics,
              shrinkWrap: shrinkWrap,
              controller: controller,
              cacheExtent: cacheExtent,
              clipBehavior: clipBehavior,
              restorationId: restorationId,
              scrollDirection: scrollDirection,
              dragStartBehavior: dragStartBehavior,
              semanticChildCount: semanticChildCount,
              keyboardDismissBehavior: keyboardDismissBehavior,
            );
          },
        );
}

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// {@template animated_list_view}
/// Descendant of [AnimatedScrollView].
///
/// Implements animated [ListView].
/// {@endtemplate}
class AnimatedListView<T> extends AnimatedScrollView<T> {
  /// {@macro animated_list_view}
  AnimatedListView({
    super.key,
    super.itemsNotifier,
    super.itemWrapper,
    super.itemsAnimationController,
    required super.items,
    required super.idMapper,
    required super.itemBuilder,
    required super.eventController,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    Widget? prototypeItem,
    double? cacheExtent,
    int? semanticChildCount,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    //
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
            return ListView.custom(
              scrollDirection: scrollDirection,
              reverse: reverse,
              controller: controller,
              primary: primary,
              physics: physics,
              shrinkWrap: shrinkWrap,
              padding: padding,
              itemExtent: itemExtent,
              prototypeItem: prototypeItem,
              cacheExtent: cacheExtent,
              semanticChildCount: semanticChildCount,
              dragStartBehavior: dragStartBehavior,
              keyboardDismissBehavior: keyboardDismissBehavior,
              restorationId: restorationId,
              clipBehavior: clipBehavior,
              childrenDelegate: ScrollViewSliverChildBuilderDelegate(
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

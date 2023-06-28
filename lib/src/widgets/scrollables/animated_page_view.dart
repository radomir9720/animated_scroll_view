import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

/// {@template animated_list_view}
/// Descendant of [AnimatedScrollView].
///
/// Implements animated [PageView].
/// {@endtemplate}
class AnimatedPageView<T> extends AnimatedScrollView<T> {
  /// {@macro animated_list_view}
  AnimatedPageView({
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
    PageController? controller,
    ScrollPhysics? physics,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
    bool allowImplicitScrolling = false,
    ValueChanged<int>? onPageChanged,
    bool padEnds = true,
    bool pageSnapping = true,
    ScrollBehavior? scrollBehavior,
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
            return PageView.custom(
              reverse: reverse,
              padEnds: padEnds,
              physics: physics,
              controller: controller,
              clipBehavior: clipBehavior,
              pageSnapping: pageSnapping,
              onPageChanged: onPageChanged,
              restorationId: restorationId,
              scrollBehavior: scrollBehavior,
              scrollDirection: scrollDirection,
              dragStartBehavior: dragStartBehavior,
              allowImplicitScrolling: allowImplicitScrolling,
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

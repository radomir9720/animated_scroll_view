import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

/// {@template scroll_view_sliver_child_builder_delegate}
/// Simple descendant of [SliverChildBuilderDelegate].
///
/// The only difference is that it takes [onDidFinishLayout] parameter,
/// and provides this callback to [didFinishLayout] method,
/// so that we can find out which children has been laid out.
/// {@endtemplate}
class ScrollViewSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  /// {@macro scroll_view_sliver_child_builder_delegate}
  ScrollViewSliverChildBuilderDelegate(
    super.builder, {
    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
    super.childCount,
    super.findChildIndexCallback,
    super.semanticIndexCallback,
    super.semanticIndexOffset,
    this.onDidFinishLayout,
  });

  /// Called at the end of layout to indicate that layout is now complete.
  ///
  /// The `firstIndex` argument is the index of the first child that was
  /// included in the current layout. The `lastIndex` argument is the index of
  /// the last child that was included in the current layout.
  final OnDidFinishLayoutCallback? onDidFinishLayout;

  @override
  void didFinishLayout(int firstIndex, int lastIndex) {
    onDidFinishLayout?.call(firstIndex, lastIndex);
    super.didFinishLayout(firstIndex, lastIndex);
  }
}

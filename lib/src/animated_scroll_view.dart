// ignore_for_file: comment_references

import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:animated_scroll_view/src/animated_item_widget.dart';
import 'package:flutter/widgets.dart';

typedef DoubleAnimation = Animation<double>;

/// Intended to be passed to [SliverChildDelegate.didFinishLayout]
typedef OnDidFinishLayoutCallback = void Function(
  int firstIndex,
  int lastIndex,
);

/// {@template animated_scroll_view.scrollable_builder}
/// Callback which must return as result a Scrollable widget
/// {@endtemplate}
typedef ScrollableBuilder = Widget Function(
  int itemCount,
  IndexedWidgetBuilder itemBuilder,
  OnDidFinishLayoutCallback onDidFinishLayout,
);

/// {@template animated_scroll_view.id_mapper}
/// Callback, which generates an id of type [String] from [T] object.
/// {@endtemplate}
typedef IDMapper<T> = String Function(T object);

/// {@template animated_scroll_view.item_builder}
///
/// Widget builder.
///
/// Provides you an item of type [T], and expects a Widget as the result of this
/// function.
///
/// For example, it can be a `ListTile`, `Card`, or a custom widget.
///
/// For transition animation, and other wrappers, that should depend on
/// animation, see [AnimatedScrollView.itemWrapper] parameter.
///
/// {@endtemplate}
typedef ItemBuilder<T> = Widget Function(T item);

/// {@template animated_scroll_view.item_wrapper}
///
/// Builder for wrapping an item
/// (which comes from [AnimatedScrollView.itemBuilder]) in some widget.
/// E. g.: [SizeTransition], [FadeTransition], [SizeAndFadeTransition],
/// [PointerIgnorer] etc.
///
/// Optional parameter. If `null`, item will be wrapped in
/// [SizeAndFadeTransition] and [PointerIgnorer] by default. So you do not need
/// to carry about the animation transition and unwanted gestures
/// during animation.
///
/// If you want a different behavior(i.e. a different animation transition,
/// or/and a different gesture ignore logic), just pass to this parameter
/// corresponding wrapper
///
/// {@endtemplate}
typedef ItemWrapper = Widget Function(
  DoubleAnimation animation,
  Widget item,
);

/// {@template animated_scroll_view}
/// Scrollable widget,
/// which lets you easily animate its [items] list modifications.
///
/// Mainly, developed as a replacement for out-of-the-box animated scrollables:
///
/// - [AnimatedList]
/// - [SliverAnimatedList]
/// - [AnimatedGrid] (available from flutter version 3.7.0)
/// - [SliverAnimatedGrid] (available from flutter version 3.7.0)
///
/// because of their numerous disadvantages:
///
/// - Scroll offset jumps when an item is built atop(outside) of the current
/// layout. See [SliverChildDelegate.didFinishLayout].
/// - Out-of-the-box animated scrollables have inconvinient API, developer
/// is required to write a lot of code to make it work
/// - There is a lot of cases when developer may forget/miss something to setup,
/// and, as a result, lose a lot of time figuring out what's wrong
/// - [AnimatedGrid] and [SliverAnimatedGrid] are not available if you are using
/// flutter version below 3.7.0
///
/// There are already implementations-replacements for each of the
/// out-of-the-box animated scrollables mentioned above:
///
/// - [AnimatedListView] (replacement for [AnimatedList])
/// - [SliverAnimatedListView] (replacement for [SliverAnimatedList])
/// - [AnimatedGridView] (replacement for [AnimatedGrid])
/// - [SliverAnimatedGridView] (replacement for [SliverAnimatedGrid])
///
/// But, of course, you can extend [AnimatedScrollView], and create your own
/// implementation, using the handy API of this package.
/// {@endtemplate}
class AnimatedScrollView<T> extends StatefulWidget {
  /// {@macro animated_scroll_view}
  const AnimatedScrollView({
    super.key,
    required this.items,
    required this.scrollableBuilder,
    required this.eventController,
    required this.idMapper,
    required this.itemBuilder,
    this.itemsNotifier,
    this.itemWrapper,
    this.itemsAnimationController,
  });

  /// List of items of arbitrary type [T]
  @protected
  final List<T> items;

  /// {@macro animated_scroll_view.scrollable_builder}
  @protected
  final ScrollableBuilder scrollableBuilder;

  /// Instance of [EventController].
  /// Used to control when and which item should be added/deleted/etc. from/to
  /// [items] list.
  @protected
  final EventController<T> eventController;

  /// {@macro animated_scroll_view.id_mapper}
  ///
  /// Item id is used for two reasons:
  /// 1. To have a reference to [T] object
  /// 2. To use it as a key for [AnimatedItemWidget] widget
  @protected
  final IDMapper<T> idMapper;

  /// {@macro animated_scroll_view.item_builder}
  ///
  /// {@tool snippet}
  ///
  /// Example:
  /// ```dart
  ///   ...
  ///   itemBuilder: (item) {
  ///     return MyWidget(item: item);
  ///   },
  ///   ...
  /// ```
  /// {@end-tool}
  @protected
  final ItemBuilder<T> itemBuilder;

  /// {@macro animated_scroll_view.item_wrapper}
  @protected
  final ItemWrapper? itemWrapper;

  /// {@macro items_notifier}
  @protected
  final ItemsNotifier<T>? itemsNotifier;

  @protected
  final ItemsAnimationController<DoubleAnimation>? itemsAnimationController;

  @override
  State<AnimatedScrollView<T>> createState() => _AnimatedScrollViewState();
}

class _AnimatedScrollViewState<T> extends State<AnimatedScrollView<T>>
    with TickerProviderStateMixin {
  late final ItemsNotifier<T> itemsNotifier;
  late final StreamSubscription<void> itemsEventSubscription;
  late final ItemsAnimationController itemsAnimationController;

  @override
  void initState() {
    itemsAnimationController =
        widget.itemsAnimationController ?? DefaultItemsAnimationController();
    itemsNotifier = widget.itemsNotifier ?? DefaultItemsNotifier();
    itemsNotifier
      ..updateValue(widget.items)
      ..idMapper = widget.idMapper;

    itemsEventSubscription = widget.eventController.listen(onNewItemsEvent);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant AnimatedScrollView<T> oldWidget) {
    itemsNotifier.updateValue(widget.items, forceNotify: true);
    super.didUpdateWidget(oldWidget);
  }

  void onNewItemsEvent(ModificationEvent<T> event) {
    event.execute(
      vsync: this,
      itemsNotifier: itemsNotifier,
      eventController: widget.eventController,
      itemsAnimationController: itemsAnimationController,
    );
  }

  @override
  void dispose() {
    if (widget.itemsNotifier == null) {
      itemsNotifier.dispose();
    }
    if (widget.itemsAnimationController == null) {
      itemsAnimationController.close();
    }

    itemsEventSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<T>>(
      valueListenable: itemsNotifier,
      builder: (context, items, child) {
        return widget.scrollableBuilder(
          items.length,
          (context, index) {
            final item = items[index];
            final id = widget.idMapper(item);
            final child = widget.itemBuilder(item);

            return AnimatedItemWidget(
              key: ValueKey(id),
              id: id,
              index: index,
              builder: (animation) {
                return widget.itemWrapper?.call(animation, child) ??
                    SizeAndFadeTransition(
                      animation: animation,
                      child: PointerIgnorer(
                        animation: animation,
                        child: child,
                      ),
                    );
              },
              itemsNotifier: itemsNotifier,
              itemsAnimationController: itemsAnimationController,
            );
          },
          (firstIndex, lastIndex) {
            itemsNotifier.mountedWidgetsIndexRangeChanged(
              IndexRange(
                start: firstIndex,
                end: lastIndex,
              ),
            );
          },
        );
      },
    );
  }
}

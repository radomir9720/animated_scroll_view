import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';

/// {@template modification_event}
/// Base class of modification event.
/// Its descendants should contain modification information.
/// (i.e. move/add/remove some item of type [T] in/to/from items list)
/// {@endtemplate}
abstract class ModificationEvent<T> {
  /// {@macro modification_event}
  ModificationEvent();

  /// Method, that should contain all the logic of item list
  /// modifications(inserting, deleting, moving, etc.), and animations, that
  /// should be executed when an item is deleted/inserted.
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
    required Type scrollViewType,
  });
}

/// Extension on [Type].
///
/// Provides a pattern-matching function [when()]
extension ScrollViewTypeExtension on Type {
  /// Pattern-matching function. Executes function which corresponds to
  /// [AnimatedScrollView] type/subtype and returns the execution result.
  ///
  /// If type is not one of the default implementations:
  ///
  /// - [AnimatedListView],
  /// - [SliverAnimatedListView],
  /// - [AnimatedGridView],
  /// - [SliverAnimatedGridView],
  /// - [AnimatedPageView]
  ///
  /// then [orElse] callback is executed, which provides the runtimeType of
  /// the current ScrollView.
  R when<R, T>({
    required R Function() grid,
    required R Function() list,
    required R Function() pageView,
    required R Function(Type type) orElse,
  }) {
    if ((this == AnimatedListView<T>) || (this == SliverAnimatedListView<T>)) {
      return list();
    }

    if ((this == AnimatedGridView<T>) || (this == SliverAnimatedGridView<T>)) {
      return grid();
    }

    if (this == AnimatedPageView<T>) return pageView();

    return orElse(this);
  }
}

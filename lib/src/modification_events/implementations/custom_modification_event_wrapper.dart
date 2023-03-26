import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/animation.dart';
import 'package:meta/meta.dart';

/// Callback, which provides [TickerProvider], [ItemsNotifier],
/// [EventController], and [ItemsAnimationController].
typedef OnExecuteCustomEventCallback<T> = Future<void> Function(
  TickerProvider vsync,
  ItemsNotifier<T> itemsNotifier,
  EventController<T> eventController,
  ItemsAnimationController itemsAnimationController,
);

/// {@template custom_modification_event}
/// Descendant of [ModificationEvent].
///
/// Provides a wrapper, and delegates all the logic using [onExecute] callback.
/// {@endtemplate}
///
/// See also:
///  * [InsertItemEvent]
///  * [RemoveItemEvent]
///  * [MoveItemEvent]
class CustomModificationEventWrapper<T> extends ModificationEvent<T> {
  /// Creates a [CustomModificationEventWrapper] using given [onExecute]
  /// callback
  CustomModificationEventWrapper({required this.onExecute});

  /// It is expected that in the body of this callback, using provided
  /// parameters, will be managed item list  modification(-s) logic,
  /// and animation(-s) of this/these modification(-s)
  ///
  /// See also:
  ///  * [InsertItemEvent]
  ///  * [RemoveItemEvent]
  ///  * [MoveItemEvent]
  @protected
  @visibleForTesting
  final OnExecuteCustomEventCallback<T> onExecute;

  @override
  Future<void> execute({
    required TickerProvider vsync,
    required ItemsNotifier<T> itemsNotifier,
    required EventController<T> eventController,
    required ItemsAnimationController itemsAnimationController,
  }) {
    return onExecute(
      vsync,
      itemsNotifier,
      eventController,
      itemsAnimationController,
    );
  }
}

/// Extension on [EventController], that provides simplier and more declarative
/// way to add to event controller an [CustomModificationEventWrapper]
extension CustomEventExtension<T> on EventController<T> {
  /// Adds a [CustomModificationEventWrapper] to [EventController]
  ///
  /// Completely equivalent to
  /// ```dart
  /// eventController.add(CustomModificationEventWrapper(...))
  /// ```
  void customEvent({
    required OnExecuteCustomEventCallback<T> onExecute,
  }) {
    return add(CustomModificationEventWrapper(onExecute: onExecute));
  }
}

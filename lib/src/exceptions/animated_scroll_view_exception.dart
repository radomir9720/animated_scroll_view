import 'package:flutter/foundation.dart';

/// {@template animated_scroll_view_exception}
/// Base exception class, descendants of which are thrown from
/// `animated_scroll_view` package
/// {@endtemplate}
abstract class AnimatedScrollViewException implements Exception {
  /// {@macro animated_scroll_view_exception}
  const AnimatedScrollViewException(this.message);

  /// Exception message
  final String message;

  @override
  String toString() {
    return '$describeIdentity(this): $message';
  }
}

import 'package:flutter/foundation.dart';

abstract class AnimatedScrollViewException implements Exception {
  const AnimatedScrollViewException(this.message);

  final String message;

  @override
  String toString() {
    return '$describeIdentity(this): $message';
  }
}

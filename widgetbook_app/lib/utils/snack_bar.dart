import 'package:flutter/material.dart';

extension ShowSnackBarExtension on BuildContext {
  void showSnackBar(String content) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(content)));
  }
}

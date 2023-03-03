import 'package:flutter/widgets.dart';

@immutable
class MyModel {
  const MyModel({
    required this.id,
    required this.color,
    // required this.index,
  });

  final Color color;
  final int id;
  // final int index;

  @override
  String toString() => 'MyModel(color: $color, id: $id)';
}

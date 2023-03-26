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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is MyModel && other.color == color && other.id == id;
  }

  @override
  int get hashCode => color.hashCode ^ id.hashCode;
}

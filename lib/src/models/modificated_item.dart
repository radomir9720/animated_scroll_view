import 'package:meta/meta.dart';

/// {@template modificated_item}
/// Wrapper of an [value] of type [T], that contains an optional
/// [modificationId]
/// {@endtemplate}
@sealed
@immutable
class ModificatedItem<T> {
  /// Creates a [ModificatedItem]
  const ModificatedItem(this.value, {this.modificationId});

  /// The item
  final T value;

  /// The id of the modification.
  final String? modificationId;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ModificatedItem<T> &&
        other.value == value &&
        other.modificationId == modificationId;
  }

  @override
  int get hashCode => value.hashCode ^ modificationId.hashCode;
}

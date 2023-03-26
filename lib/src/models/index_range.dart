import 'package:meta/meta.dart';

/// {@template index_range}
/// Model that contains [start] and [end] indexes of an range;
/// {@endtemplate}
@immutable
class IndexRange {
  /// Creates an [IndexRange] wirh given [start] and [end] indexes
  const IndexRange({required this.start, required this.end});

  /// Creates an [IndexRange] with [start] and [end] indexes both equal to `0`
  const IndexRange.zero()
      : start = 0,
        end = 0;

  /// The start index od the range
  final int start;

  /// The end index of the range
  final int end;

  /// Check wheter the given [index] is in the range.
  ///
  /// Returns `true` if so, otherwise - `false`.
  bool includes(int index) {
    return index >= start && index <= end;
  }

  /// Returns a copy of current range, and replaces current [start] and [end]
  /// parameters with the passed ones.
  IndexRange copyWith({
    int? start,
    int? end,
  }) {
    return IndexRange(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IndexRange && other.start == start && other.end == end;
  }

  @override
  int get hashCode => start.hashCode ^ end.hashCode;

  @override
  String toString() => 'IndexRange(start: $start, end: $end)';
}

import 'package:meta/meta.dart';

@immutable
class IndexRange {
  const IndexRange({required this.start, required this.end});

  const IndexRange.initial()
      : start = 0,
        end = 0;

  final int start;
  final int end;

  bool includes(int index) {
    return index >= start && index <= end;
  }

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

/// Enum, that lists comparison operations
enum Operation {
  /// Equality comparison(==)
  equalsTo,

  /// Less than comparison(<)
  lessThan,

  /// Grater than comparison(>)
  greaterThan,

  /// Less than or equal to comparison(<=)
  lessOrEqualTo,

  /// Greater than or equal to comparison(>=)
  greaterOrEqualTo,

  /// Not equal comparison(!=)
  notEqualsTo;

  /// Pattern matching function by enum value. Executes the corresponding to
  /// the value callback, and returns the result of it.
  T when<T>({
    required T Function() equalsTo,
    required T Function() lessThan,
    required T Function() geaterThan,
    required T Function() lessOrEqualTo,
    required T Function() greaterOrEqualTo,
    required T Function() notEqualsTo,
  }) {
    switch (this) {
      case Operation.equalsTo:
        return equalsTo();
      case Operation.lessThan:
        return lessThan();
      case Operation.greaterThan:
        return geaterThan();
      case Operation.lessOrEqualTo:
        return lessOrEqualTo();
      case Operation.greaterOrEqualTo:
        return greaterOrEqualTo();
      case Operation.notEqualsTo:
        return notEqualsTo();
    }
  }
}

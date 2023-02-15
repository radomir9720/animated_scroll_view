enum Operation {
  equalsTo,
  lessThan,
  greaterThan,
  lessOrEqualTo,
  greaterOrEqualTo,
  notEqualsTo;

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

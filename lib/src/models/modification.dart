/// {@template modificaton}
/// Enum, which contains the possible modifications of an item
/// {@endtemplate}
enum Modification {
  /// The insert modification
  insert('insert_'),

  /// The remove modification
  remove('remove_'),

  /// No modification
  none('');

  /// Creates a [Modification]
  const Modification(this.prefix);

  /// An prefix, used to identify the modification type in d `String` format
  final String prefix;

  /// Returns a string with interpolated [prefix] and [id]
  String interpolate(String id) => '$prefix$id';

  /// Cuts of the prefix of an stringified modification with id
  ///
  /// In short, does the opposite of [interpolate] method.
  static String removePrefixes(String id) {
    var _id = id;
    for (final mod in Modification.values) {
      if (mod.prefix.isEmpty) continue;
      _id = _id.replaceFirst(mod.prefix, '');
    }
    return _id;
  }

  /// Pattern matching function by enum value. Executes the corresponding to
  /// the value callback, and returns the result of it.
  T when<T>({
    required T Function() insert,
    required T Function() remove,
    required T Function() none,
  }) {
    switch (this) {
      case Modification.insert:
        return insert();
      case Modification.remove:
        return remove();
      case Modification.none:
        return none();
    }
  }
}

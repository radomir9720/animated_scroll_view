import 'package:animated_scroll_view/animated_scroll_view.dart';

/// Mixin, which defines [idMapper] setters ang getters
mixin IDMapperMixin<T> {
  IDMapper<T>? _idMapper;

  /// Returns an [IDMapper] callback if it was previously set.
  ///
  /// Otherwise throws [IDMapperNotSetException]
  IDMapper<T> get idMapper {
    final mapper = _idMapper;
    if (mapper == null) throw const IDMapperNotSetException();
    return mapper;
  }

  /// Sets the [IDMapper] callback
  set idMapper(IDMapper<T> idMapper) {
    _idMapper = idMapper;
  }
}

/// {@template id_mapper_not_set}
/// Exception, which is thrown when [IDMapperMixin.idMapper] getter is called
/// before [IDMapper] was set.
/// {@endtemplate}
class IDMapperNotSetException extends AnimatedScrollViewException {
  /// {@macro id_mapper_not_set}
  const IDMapperNotSetException()
      : super(
          '"idMapper" is null. '
          'It should be assigned using the setter before calling the getter',
        );
}

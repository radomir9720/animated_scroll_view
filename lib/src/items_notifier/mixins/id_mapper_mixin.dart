import 'package:animated_scroll_view/animated_scroll_view.dart';

class IDMapperNotSet extends AnimatedScrollViewException {
  const IDMapperNotSet()
      : super(
          '"idMapper" is null. '
          'It should be assigned using the setter before calling the getter',
        );
}

mixin IDMapperMixin<T> on ItemsNotifier<T> {
  IDMapper<T>? _idMapper;

  @override
  IDMapper<T> get idMapper {
    final mapper = _idMapper;
    if (mapper == null) throw const IDMapperNotSet();
    return mapper;
  }

  @override
  set idMapper(IDMapper<T> idMapper) {
    _idMapper = idMapper;
  }
}

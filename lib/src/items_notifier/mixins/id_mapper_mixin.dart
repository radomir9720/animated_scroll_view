import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:animated_scroll_view/src/exceptions/animated_scroll_view_exception.dart';

class IDMapperNotSet extends AnimatedScrollViewException {
  const IDMapperNotSet()
      : super(
          '"idMapper" is null. '
          'It should be assigned using the setter before calling the getter',
        );
}

class IDMapperMixin<T> {
  IDMapper<T>? _idMapper;

  IDMapper<T> get idMapper {
    final mapper = _idMapper;
    if (mapper == null) throw const IDMapperNotSet();
    return mapper;
  }

  set idMapper(IDMapper<T> idMapper) {
    _idMapper = idMapper;
  }
}

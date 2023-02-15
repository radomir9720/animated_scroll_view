import 'dart:async';

import 'package:animated_scroll_view/src/modification_events/modification_event.dart';

abstract class EventController<T> extends Stream<ModificationEvent<T>>
    implements Sink<ModificationEvent<T>> {}

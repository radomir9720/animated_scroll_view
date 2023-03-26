import 'dart:async';

import 'package:animated_scroll_view/src/modification_events/modification_event.dart';

/// {@template event_controller}
/// Controller, which manages item list modifications(insert, delete, move etc.)
/// {@endtemplate}
abstract class EventController<T> extends Stream<ModificationEvent<T>>
    implements Sink<ModificationEvent<T>> {}

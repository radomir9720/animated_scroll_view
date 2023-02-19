/// A Very Good Project created by Very Good CLI.
// ignore_for_file: directives_ordering

library animated_scroll_view;

// TODO(radomir9720): write docstrings
// and enable public_member_api_docs rule back

export 'src/animated_scroll_view.dart';

// Event controller
export 'src/event_controller/event_controller.dart';
export 'src/event_controller/default_event_controller.dart';

// models
export 'src/models/index_range.dart';
export 'src/models/animation_entity.dart';
export 'src/models/animation_controller_config.dart';

// exceptions
export 'src/exceptions/animated_scroll_view_exception.dart';

// In memory animations
export 'src/in_memory_animation/in_memory_animation.dart';
export 'src/in_memory_animation/delayed_in_memory_animation.dart';
export 'src/in_memory_animation/static_in_memory_animation.dart';

// transitions
export 'src/widgets/transitions/size_and_fade_transition.dart';
//
export 'src/widgets/pointer_ignorer/pointer_ignorer.dart';

// Scrollables
export 'src/scrollables/animated_grid_view.dart';
export 'src/scrollables/animated_list_view.dart';
export 'src/scrollables/sliver_animated_list_view.dart';
export 'src/scrollables/sliver_animated_grid_view.dart';
export 'src/scrollables/sliver_child_builder_delegate.dart';

// items notifier
export 'src/items_notifier/items_notifier.dart';
export 'src/items_notifier/default_items_notifier.dart';
export 'src/items_notifier/mixins/items_build_queue_mixin.dart';
export 'src/items_notifier/mixins/mounted_widgets_index_range_mixin.dart';

//
export 'src/items_animation_controller/items_animation_controller.dart';
export 'src/items_animation_controller/default_items_animation_controller.dart';

// Events
export 'src/modification_events/mixins/animation_controller_mixin.dart';
//
export 'src/modification_events/modification_event.dart';
export 'src/modification_events/implementations/insert_item_event.dart';
export 'src/modification_events/implementations/move_item_event.dart';
export 'src/modification_events/implementations/remove_item_event.dart';
export 'src/modification_events/implementations/custom_modification_event_wrapper.dart';

// Widgets

// PointerIgnorer
export 'src/widgets/pointer_ignorer/pointer_ignorer.dart';
export 'src/widgets/pointer_ignorer/operation.dart';
export 'src/widgets/pointer_ignorer/pointer_ignore_condition/pointer_ignore_condition.dart';
export 'src/widgets/pointer_ignorer/pointer_ignore_condition/operation_pointer_ignore_condition.dart';
export 'src/widgets/pointer_ignorer/pointer_ignore_condition/always_false_pointer_ignore_condition.dart';

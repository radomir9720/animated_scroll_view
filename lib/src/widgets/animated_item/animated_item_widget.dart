import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

/// {@template animated_item_widget.build_with_animation_callback}
/// Builds a widget using given [animation] and returns it
/// {@endtemplate}
typedef BuildWithAnimationCallback = Widget Function(DoubleAnimation animation);

/// {@template animated_item_widget}
/// Widget, that keeps the state of an item.
///
/// Manages animations logic.
/// {@endtemplate}
class AnimatedItemWidget<T> extends StatefulWidget {
  /// Creates an [AnimatedItemWidget]
  const AnimatedItemWidget({
    super.key,
    required this.id,
    required this.itemsNotifier,
    required this.itemsAnimationController,
    required this.buildWithAnimationCallback,
    this.modificationId,
  });

  /// Item's id
  @protected
  final String id;

  /// {@macro items_notifier.modification_id}
  @protected
  final String? modificationId;

  /// {@macro items_notifier}
  @protected
  final ItemsNotifier<T> itemsNotifier;

  /// {@macro items_animation_controller}
  @protected
  final ItemsAnimationController itemsAnimationController;

  /// {@macro animated_item_widget.build_with_animation_callback}
  @protected
  final BuildWithAnimationCallback buildWithAnimationCallback;

  @override
  State<AnimatedItemWidget<T>> createState() => _AnimatedItemWidgetState<T>();
}

class _AnimatedItemWidgetState<T> extends State<AnimatedItemWidget<T>>
    with TickerProviderStateMixin {
  InMemoryAnimation? inMemoryAnimation;
  AlwaysStoppedAnimation<double>? cachedAnimationValue;

  @override
  void initState() {
    super.initState();
    _runAnimation();
  }

  @override
  void didUpdateWidget(covariant AnimatedItemWidget<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runAnimation();
  }

  Future<void> _runAnimation() async {
    final cached = widget
        .itemsAnimationController.cachedAnimationValue[widget.modificationId];
    if (cached != null) cachedAnimationValue = AlwaysStoppedAnimation(cached);

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (!mounted) return;

        final animation = widget.itemsAnimationController
            .inMemoryAnimationMap[widget.modificationId];

        if (animation == null) return;

        widget.itemsAnimationController.inMemoryAnimationMap
            .remove(widget.modificationId);

        animation.init(this);

        setState(() => inMemoryAnimation = animation);

        animation.run().then((value) {
          animation.dispose();
        });
      },
    );
  }

  @override
  void dispose() {
    inMemoryAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AnimationEntity>(
      stream: widget.itemsAnimationController
          .where((event) => widget.id == event.itemId),
      builder: (context, snapshot) {
        final animation = snapshot.data?.animation ??
            inMemoryAnimation?.animation ??
            cachedAnimationValue ??
            kAlwaysCompleteAnimation;

        return widget.buildWithAnimationCallback(animation);
      },
    );
  }
}

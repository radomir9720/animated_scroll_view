import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

class AnimatedItemWidget<T> extends StatefulWidget {
  const AnimatedItemWidget({
    super.key,
    required this.id,
    required this.index,
    required this.builder,
    required this.itemsNotifier,
    required this.itemsAnimationController,
  });

  @protected
  final String id;

  @protected
  final int index;

  @protected
  final ItemsNotifier<T> itemsNotifier;

  @protected
  final ItemsAnimationController itemsAnimationController;

  @protected
  final Widget Function(DoubleAnimation animation) builder;

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
    final cached =
        widget.itemsAnimationController.cachedAnimationValue[widget.id];
    if (cached != null) cachedAnimationValue = AlwaysStoppedAnimation(cached);

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (!mounted) return;
        final animation =
            widget.itemsAnimationController.inMemoryAnimationMap[widget.id];

        if (animation == null) return;

        final itemIndex = widget.itemsNotifier.getIndexById(widget.id);

        if (itemIndex != widget.index) return;

        widget.itemsAnimationController.inMemoryAnimationMap.remove(widget.id);

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
        return widget.builder(
          snapshot.data?.animation ??
              inMemoryAnimation?.animation ??
              cachedAnimationValue ??
              kAlwaysCompleteAnimation,
        );
      },
    );
  }
}

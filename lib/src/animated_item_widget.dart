import 'dart:async';

import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/widgets.dart';

class AnimatedItemWidget<T> extends StatefulWidget {
  const AnimatedItemWidget({
    super.key,
    required this.id,
    required this.builder,
    required this.itemsNotifier,
    required this.animationEntityStream,
  });

  @protected
  final String id;

  @protected
  final ItemsNotifier<T> itemsNotifier;

  @protected
  final Stream<AnimationEntity> animationEntityStream;

  @protected
  final Widget Function(Animation<double> animation) builder;

  @override
  State<AnimatedItemWidget<T>> createState() => _AnimatedItemWidgetState<T>();
}

class _AnimatedItemWidgetState<T> extends State<AnimatedItemWidget<T>>
    with TickerProviderStateMixin {
  QueuedAnimation? queuedAnimation;

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
    queuedAnimation ??= widget.itemsNotifier.popQueuedAnimation(widget.id);

    final qa = queuedAnimation;
    if (qa == null) return;
    qa.initAnimation(this);

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        if (!mounted) return;

        qa.runAnimation().then((value) {
          qa.dispose();
          queuedAnimation = null;
        });
      },
    );
  }

  @override
  void dispose() {
    queuedAnimation?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AnimationEntity>(
      stream: widget.animationEntityStream
          .where((event) => widget.id == event.itemId),
      builder: (context, snapshot) {
        final animation =
            queuedAnimation?.animation ?? snapshot.data?.animation;

        return widget.builder(
          animation ?? kAlwaysCompleteAnimation,
        );
      },
    );
  }
}

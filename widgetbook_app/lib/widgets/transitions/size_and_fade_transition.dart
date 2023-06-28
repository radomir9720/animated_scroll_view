import 'package:animated_scroll_view/animated_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart';

@UseCase(name: 'Default', type: SizeAndFadeTransition)
Widget defaultSizeAndFadeTransitionUseCase(BuildContext context) {
  return Builder(
    builder: (context) {
      final duration = context.animationDurationKnob;
      final lowerBound = context.lowerBoundAnimationKnob;
      final upperBound = context.upperBoundAnimationKnob;
      final initialValue = context.initialValueAnimationKnob;

      return _SizeAndFadeTransitionUseCase(
        duration: duration,
        lowerBound: lowerBound,
        upperBound: upperBound,
        initialValue: initialValue,
      );
    },
  );
}

extension on BuildContext {
  double get lowerBoundAnimationKnob {
    return knobs.double.input(
      label: 'Lower animation bound',
      initialValue: 0,
    );
  }

  double get upperBoundAnimationKnob {
    return knobs.double.input(
      label: 'Upper animation bound',
      initialValue: 1,
    );
  }

  double get initialValueAnimationKnob {
    return knobs.double.input(
        label: 'Initial animation value', initialValue: 1);
  }

  Axis get sizeTransitionAxis {
    return knobs.list<Axis>(
      label: 'Size transition axis',
      labelBuilder: (value) => value.name,
      options: const <Axis>[
        Axis.vertical,
        Axis.horizontal,
      ],
    );
  }

  Duration get animationDurationKnob {
    return Duration(
      milliseconds: knobs.double.input(
        label: 'Duration(milliseconds)',
        initialValue: 200,
      ).toInt(),
    );
  }
}

class _SizeAndFadeTransitionUseCase extends StatefulWidget {
  const _SizeAndFadeTransitionUseCase({
    Key? key,
    required this.duration,
    required this.lowerBound,
    required this.upperBound,
    required this.initialValue,
  }) : super(key: key);

  final Duration duration;
  final double lowerBound;
  final double upperBound;
  final double initialValue;

  @override
  State<_SizeAndFadeTransitionUseCase> createState() =>
      _SizeAndFadeTransitionUseCaseState();
}

class _SizeAndFadeTransitionUseCaseState
    extends State<_SizeAndFadeTransitionUseCase> with TickerProviderStateMixin {
  late AnimationController animationController;
  // double lowerBound = 0;
  // double upperBound = 1;
  // double initialValue = 1;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      lowerBound: widget.lowerBound,
      upperBound: widget.upperBound,
      duration: widget.duration,
      value: widget.initialValue,
    );
  }

  @override
  void didChangeDependencies() {
    if (widget.initialValue != animationController.value ||
        widget.upperBound != animationController.upperBound ||
        widget.lowerBound != animationController.lowerBound ||
        widget.duration != animationController.duration) {
      animationController
        ..stop()
        ..dispose();
      animationController = AnimationController(
        vsync: this,
        lowerBound: widget.lowerBound,
        upperBound: widget.upperBound,
        value: widget.initialValue,
        duration: widget.duration,
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeTransitionAxis = context.sizeTransitionAxis;

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SizeAndFadeTransition(
            animation: animationController,
            sizeTransitionAxis: sizeTransitionAxis,
            child: const ListTile(
              title: Text('This is a ListTile title'),
              subtitle: Text('This is a ListTile subtitle'),
              trailing: Icon(Icons.settings),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => animationController.forward(),
                icon: const Icon(Icons.play_arrow),
                label: const Text('Play'),
              ),
              ElevatedButton.icon(
                onPressed: animationController.stop,
                icon: const Icon(Icons.stop),
                label: const Text('Stop'),
              ),
              ElevatedButton.icon(
                onPressed: animationController.reverse,
                icon: const Icon(Icons.keyboard_backspace_sharp),
                label: const Text('Reverse'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

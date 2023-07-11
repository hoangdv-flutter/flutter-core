import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_core/base_stateful.dart';

class HSlider extends StatefulWidget {
  const HSlider(
      {super.key,
      this.customThumb,
      this.max = 100,
      this.min = 0,
      this.value = 0,
      this.trackColor = Colors.grey,
      this.progressColor = Colors.blue,
      this.progressHeight = 5,
      this.onProgressChange,
      this.onStartTrackingTouch,
      this.onStopTrackingTouch});

  final Function(int progress)? onProgressChange;

  final Function()? onStartTrackingTouch;

  final Function(int progress)? onStopTrackingTouch;

  final Color trackColor;

  final Color progressColor;

  final Widget Function(double animProgress)? customThumb;

  final int max;

  final int min;

  final int value;

  final double progressHeight;

  @override
  State<HSlider> createState() => _HSliderState();
}

class _HSliderState extends BaseState<HSlider>
    with SingleTickerProviderStateMixin {
  var _progress = 0;

  late final _controller = AnimationController(vsync: this)
    ..duration = const Duration(milliseconds: 200)
    ..addListener(() {
      setState(() {});
    });

  late final _animation =
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  var _touchEnd = true;

  @override
  void initState() {
    super.initState();
    _progress = widget.value;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      final thumbSize = widget.progressHeight * 4 * (1 + .3 * _animation.value);

      final totalSize = widget.progressHeight * 4 * 1.3;

      final progressPosition = constraint.maxWidth *
          (_progress - widget.min) /
          (widget.max - widget.min);
      return Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: totalSize,
          ),
          Positioned.fill(
            child: Center(
              child: Container(
                width: double.infinity,
                height: widget.progressHeight,
                decoration: BoxDecoration(
                    color: widget.trackColor,
                    borderRadius:
                        BorderRadius.circular(widget.progressHeight / 2)),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                width: progressPosition,
                height: widget.progressHeight,
                decoration: BoxDecoration(
                    color: widget.progressColor,
                    borderRadius:
                        BorderRadius.circular(widget.progressHeight / 2)),
              ),
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: Container(
                margin:
                    EdgeInsets.only(left: max(progressPosition - thumbSize, 0)),
                child: SizedBox(
                  width: thumbSize,
                  height: thumbSize,
                  child: widget.customThumb?.call(_animation.value) ??
                      Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.progressColor),
                      ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: GestureDetector(
              onTapUp: (details) => _stopTouch(),
              onTapDown: (details) => _startTouch(),
              onHorizontalDragUpdate: (details) {
                _startTouch();
                _updateProgressTouch(
                    details.localPosition.dx, constraint.maxWidth);
              },
              onHorizontalDragEnd: (details) => _stopTouch(),
              behavior: HitTestBehavior.opaque,
            ),
          )
        ],
      );
    });
  }

  void _updateProgressTouch(double dx, double width) {
    final progress =
        min(max((dx / width * widget.max).round(), widget.min), widget.max);
    if (progress != _progress) {
      setState(() => _progress = progress);
      widget.onProgressChange?.call(progress);
    }
  }

  void _startTouch() {
    if (_touchEnd) {
      _controller.forward(from: _animation.value);
    }
    _touchEnd = false;
    widget.onStartTrackingTouch?.call();
  }

  void _stopTouch() {
    _controller.reverse(from: _animation.value);
    _touchEnd = true;
    widget.onStopTrackingTouch?.call(_progress);
  }
}

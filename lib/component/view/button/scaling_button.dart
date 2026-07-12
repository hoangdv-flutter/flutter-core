part of '../view.dart';

class ScalingButton extends StatefulWidget {
  const ScalingButton(
      {super.key,
      required this.child,
      this.scale = 0.9,
      this.duration = const Duration(milliseconds: 200),
      this.enable = true,
      this.onTap});

  final Widget child;

  final bool enable;

  final Duration duration;

  final double scale;

  final GestureTapCallback? onTap;

  @override
  State<ScalingButton> createState() => _ScalingButtonState();
}

class _ScalingButtonState extends State<ScalingButton>
    with SingleTickerProviderStateMixin {
  late final _controller = AnimationController(
      vsync: this, duration: widget.duration, reverseDuration: widget.duration);

  late final _animation =
      CurvedAnimation(parent: _controller, curve: Curves.easeIn);

  @override
  void initState() {
    _controller.addListener(
      () {
        setState(() {});
      },
    );

    _animation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          widget.onTap?.call();
        }
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.enable && !_animation.isAnimating
          ? () => _controller.forward(from: 0)
          : null,
      child: Transform.scale(
          // Rest = 1.0; nhấn nhún xuống `scale` (mid) rồi trở lại 1.0.
          // (Công thức cũ cho rest = 1.1 → phóng to child 10% khi đứng yên.)
          scale: 1 - (1 - widget.scale) * (1 - (2 * _animation.value - 1).abs()),
          child: widget.child),
    );
  }
}

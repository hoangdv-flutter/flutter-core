part of '../view.dart';

class GradientButton extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final Function()? onPress;

  const GradientButton(
      {super.key, required this.child, this.gradient, this.onPress});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.w),
      child: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPress,
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Center(
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

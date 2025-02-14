import 'package:flutter/material.dart';

class ScaleFadeAnimation extends StatefulWidget {
  const ScaleFadeAnimation(
      {Key? key, required this.child, required this.delay});

  final Widget child;
  final double delay;

  @override
  State<ScaleFadeAnimation> createState() => ScaleFadeAnimationState();
}

class ScaleFadeAnimationState extends State<ScaleFadeAnimation>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> animation;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        duration: Duration(milliseconds: (500 * widget.delay).round()),
        vsync: this);
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    )..addListener(() {});
    scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(parent: controller, curve: Curves.easeInOut),
    )..addListener(() {});
    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleAnimation.value,
      child: Opacity(
        opacity: animation.value,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

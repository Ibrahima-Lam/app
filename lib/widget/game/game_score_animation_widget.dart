import 'package:flutter/material.dart';

class GameScoreAnimationWidget extends StatefulWidget {
  final Widget child;
  final bool animate;
  const GameScoreAnimationWidget(
      {super.key, required this.child, this.animate = true});

  @override
  State<GameScoreAnimationWidget> createState() =>
      _GameScoreAnimationWidgetState();
}

class _GameScoreAnimationWidgetState extends State<GameScoreAnimationWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<double> _tween;
  late final CurvedAnimation _curvedAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _curvedAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutBack,
    );
    _tween = Tween(begin: 0.0, end: 1.0).animate(_curvedAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.animate) {
      _controller
        ..forward()
        ..repeat();
    }
    return AnimatedBuilder(
      animation: _tween,
      builder: (context, snapshot) {
        return FadeTransition(
          opacity: _tween,
          child: widget.child,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class LayoutBuilderWidget extends StatelessWidget {
  final Widget child;

  const LayoutBuilderWidget({
    super.key,
    required this.child,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Padding(
        padding: constraint.maxWidth > 800
            ? EdgeInsets.symmetric(horizontal: constraint.maxWidth * .14)
            : EdgeInsets.zero,
        child: child,
      );
    });
  }
}

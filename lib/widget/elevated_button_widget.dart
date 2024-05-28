import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String? label;
  final Function()? onPressed;
  const ElevatedButtonWidget({super.key, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue, foregroundColor: Colors.white),
        onPressed: onPressed,
        child: Text(label ?? 'Envoyer'));
  }
}

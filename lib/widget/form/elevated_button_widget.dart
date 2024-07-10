import 'package:flutter/material.dart';

class ElevatedButtonWidget extends StatelessWidget {
  final String? label;
  final Function()? onPressed;
  const ElevatedButtonWidget({super.key, this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: MediaQuery.sizeOf(context).width * .95,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0))),
          onPressed: onPressed,
          child: Text(
            label ?? 'Envoyer',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
  }
}

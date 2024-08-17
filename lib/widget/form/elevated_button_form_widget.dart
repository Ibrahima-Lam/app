import 'package:flutter/material.dart';

class ElevatedButtonFormWidget extends StatelessWidget {
  final String? label;
  final bool isSending;
  final Function()? onPressed;
  const ElevatedButtonFormWidget(
      {super.key, this.label, this.onPressed, this.isSending = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          height: 60,
          width: MediaQuery.of(context).size.width,
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4.0))),
              onPressed: isSending ? null : onPressed,
              child: Text(
                label ?? 'Envoyer',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              )),
        ),
        if (isSending)
          const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
      ],
    );
  }
}

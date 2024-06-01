import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String title;
  final String? content;
  const ConfirmDialogWidget({super.key, required this.title, this.content});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content ?? ''),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Non')),
        TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Oui')),
      ],
    );
  }
}

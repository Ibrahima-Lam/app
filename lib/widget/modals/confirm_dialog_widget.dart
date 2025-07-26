import 'package:fscore/core/enums/enums.dart';
import 'package:flutter/material.dart';

class ConfirmDialogWidget extends StatelessWidget {
  final String title;
  final String? content;
  final ConfirmDialogDefault? defaut;
  const ConfirmDialogWidget(
      {super.key, required this.title, this.content, this.defaut});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      title: Text(title, textAlign: TextAlign.center),
      contentPadding: EdgeInsets.all(10),
      icon: Icon(Icons.help_center_outlined),
      content: Text(
        content ?? '',
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
            style: ButtonStyle(
                backgroundColor: defaut == ConfirmDialogDefault.non
                    ? WidgetStatePropertyAll(Colors.blue)
                    : null,
                foregroundColor: defaut == ConfirmDialogDefault.non
                    ? WidgetStatePropertyAll(Colors.white)
                    : WidgetStatePropertyAll(Colors.blue)),
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: Text('Non')),
        TextButton(
            style: ButtonStyle(
                backgroundColor: defaut == ConfirmDialogDefault.oui
                    ? WidgetStatePropertyAll(Colors.blue)
                    : null,
                foregroundColor: defaut == ConfirmDialogDefault.oui
                    ? WidgetStatePropertyAll(Colors.white)
                    : WidgetStatePropertyAll(Colors.blue)),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: Text('Oui')),
      ],
    );
  }
}

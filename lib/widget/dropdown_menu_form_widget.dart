import 'package:flutter/material.dart';

class DropdownMenuFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Map<String, String> entries;
  const DropdownMenuFormWidget(
      {super.key, this.controller, required this.entries});

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
        menuStyle:
            MenuStyle(backgroundColor: MaterialStatePropertyAll(Colors.white)),
        width: MediaQuery.sizeOf(context).width * .95,
        label: Text('Selectionner la cause'),
        enableSearch: true,
        controller: controller,
        initialSelection: controller?.text,
        dropdownMenuEntries: [
          for (String key in entries.keys)
            DropdownMenuEntry(value: key, label: entries[key] ?? key)
        ]);
  }
}

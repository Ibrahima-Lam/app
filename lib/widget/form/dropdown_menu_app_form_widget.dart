import 'package:app/core/extension/string_extension.dart';
import 'package:flutter/material.dart';

class DropdownMenuAppFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Map<String, dynamic> entries;
  final String title;
  const DropdownMenuAppFormWidget(
      {super.key, this.controller, required this.entries, required this.title});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        child: DropdownMenu(
            menuStyle: MenuStyle(
                shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(side: BorderSide.none)),
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            width: MediaQuery.sizeOf(context).width * .98,
            label: Text(title),
            enableSearch: true,
            controller: controller,
            initialSelection: controller?.text,
            dropdownMenuEntries: [
              for (String key in entries.keys)
                DropdownMenuEntry(
                    value: entries[key] ?? key, label: key.capitalize())
            ]),
      ),
    );
  }
}

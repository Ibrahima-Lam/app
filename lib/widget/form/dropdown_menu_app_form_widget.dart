import 'package:fscore/core/extension/string_extension.dart';
import 'package:flutter/material.dart';

class DropDownMenuAppFormWidget extends StatelessWidget {
  final TextEditingController? controller;
  final Map<String, dynamic> entries;
  final String title;
  final Function(dynamic)? onSelected;
  const DropDownMenuAppFormWidget(
      {super.key,
      this.controller,
      required this.entries,
      required this.title,
      this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: DropdownMenu(
            onSelected: (value) {
              if (value != null && controller != null)
                controller!.text = value.toString();
              if (onSelected != null) onSelected!(value);
            },
            menuStyle: MenuStyle(
                shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(side: BorderSide.none)),
                backgroundColor: WidgetStatePropertyAll(Colors.white)),
            width: MediaQuery.of(context).size.width * .98,
            label: Text(title),
            menuHeight: 300,
            enableSearch: true,
            initialSelection: controller?.text,
            dropdownMenuEntries: entries.entries.map((e) {
              return DropdownMenuEntry(
                value: e.value,
                label: e.key.capitalize(),
              );
            }).toList()),
      ),
    );
  }
}

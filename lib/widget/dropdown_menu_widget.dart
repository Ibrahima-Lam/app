import 'package:app/core/extension/string_extension.dart';
import 'package:flutter/material.dart';

class DropDownMenuWidget<T> extends StatelessWidget {
  final void Function(T?)? onChanged;
  final List<T> tab;
  final T value;
  final String? hint;
  const DropDownMenuWidget({
    super.key,
    required this.onChanged,
    required this.tab,
    required this.value,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
      child: DropdownButton(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        dropdownColor: Colors.white,
        focusColor: Colors.white,
        elevation: 0,
        hint: Text(hint ?? ''),
        value: value,
        items: tab
            .map((e) => DropdownMenuItem(
                value: e, child: Text(e.toString().capitalize())))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}

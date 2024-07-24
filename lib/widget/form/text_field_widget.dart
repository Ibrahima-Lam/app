import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;

  const TextFieldWidget({
    super.key,
    required this.textEditingController,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextFormField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        focusNode: focusNode,
        controller: textEditingController,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding: EdgeInsets.only(bottom: 10.0),
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 17),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

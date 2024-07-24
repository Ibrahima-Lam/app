import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? suffixIcon;
  final bool obscureText;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  const TextFormFieldWidget(
      {super.key,
      this.controller,
      this.hintText,
      this.suffixIcon,
      this.prefixIcon,
      this.focusNode,
      this.obscureText = false,
      this.keyboardType,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      child: Container(
        height: 50,
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: TextFormField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          focusNode: focusNode,
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
            contentPadding: EdgeInsets.all(9.0),
            hintText: hintText,
            hintStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}

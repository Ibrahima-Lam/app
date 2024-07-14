import 'package:flutter/material.dart';

class CardAndNumberWidget extends StatelessWidget {
  final int nombre;
  final bool yellow;
  final bool showOneNumber;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final FontWeight? fontWeight;
  const CardAndNumberWidget(
      {super.key,
      this.nombre = 0,
      this.yellow = true,
      this.width,
      this.height,
      this.fontSize,
      this.fontWeight,
      this.showOneNumber = true,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 18,
      width: width ?? 12,
      color: yellow
          ? const Color.fromARGB(255, 255, 230, 6)
          : const Color.fromARGB(255, 213, 20, 6),
      child: nombre > 1 || nombre == 1 && showOneNumber
          ? Center(
              child: Text(
                nombre.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize ?? 14,
                  fontWeight: fontWeight,
                  color: textColor,
                ),
              ),
            )
          : null,
    );
  }
}

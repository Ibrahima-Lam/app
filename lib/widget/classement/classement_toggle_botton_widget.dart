import 'package:flutter/material.dart';

class ClassementToggleBottonWidget extends StatefulWidget {
  final Function(int index) onSelected;
  final int selected;
  const ClassementToggleBottonWidget(
      {super.key, required this.onSelected, required this.selected});

  @override
  State<ClassementToggleBottonWidget> createState() =>
      _ClassementToggleBottonWidgetState();
}

class _ClassementToggleBottonWidgetState
    extends State<ClassementToggleBottonWidget> {
  @override
  Widget build(BuildContext context) {
    final List<bool> isSelected = [false, false];
    isSelected[widget.selected] = true;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
            color: Colors.white,
            gradient: LinearGradient(colors: [
              Colors.white,
              Color.fromARGB(255, 215, 238, 215),
              Colors.white,
            ])),
        child: ToggleButtons(
          borderWidth: 0,
          fillColor: Theme.of(context).primaryColor,
          color: Theme.of(context).primaryColor,
          selectedColor: Colors.white,
          onPressed: widget.onSelected,
          children: [
            Text('Tous'),
            Text('Moins'),
          ],
          isSelected: isSelected,
        ),
      ),
    );
  }
}

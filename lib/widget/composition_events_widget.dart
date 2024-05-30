import 'package:flutter/material.dart';

class GoalWidget extends StatelessWidget {
  const GoalWidget({super.key, required this.but});
  final int but;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircleAvatar(
          radius: 8,
          child: Icon(
            Icons.sports_soccer,
            color: Colors.black,
            size: 15,
          ),
        ),
        if (but > 1)
          Text(
            but.toString(),
            style: TextStyle(
                fontSize: 12,
                color: Colors.white,
                backgroundColor: Colors.black),
          ),
      ],
    );
  }
}

class CapitaineWidget extends StatelessWidget {
  const CapitaineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 2),
      color: Colors.blue,
      child: const Text(
        'C',
        style: TextStyle(
            fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, this.isRed = false});
  final bool isRed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 15,
      color: isRed ? Colors.red : Colors.yellow,
    );
  }
}

class PersonWidget extends StatelessWidget {
  final double? radius;
  const PersonWidget({super.key, this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 20,
      backgroundColor: const Color(0xFFDCDCDC),
      foregroundColor: Colors.white,
      child: Icon(Icons.person),
    );
  }
}

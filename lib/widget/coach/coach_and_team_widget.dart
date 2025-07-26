import 'package:fscore/models/composition.dart';
import 'package:fscore/widget/events/composition_events_widget.dart';
import 'package:flutter/material.dart';

class CoachAndTeamWidget extends StatelessWidget {
  final String equipe;
  final CoachComposition composition;
  final Function()? onDoubleTap;
  const CoachAndTeamWidget(
      {super.key,
      required this.equipe,
      required this.composition,
      this.onDoubleTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(2.0),
      child: Column(
        children: [
          Text(
            equipe,
            style: TextStyle(
                color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 5,
          ),
          GestureDetector(
            onDoubleTap: onDoubleTap == null ? null : onDoubleTap,
            child: Row(
              children: [
                Text(
                  composition.nom,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      fontSize: 13),
                ),
                const SizedBox(
                  width: 5,
                ),
                if (composition.jaune > 0) CardWidget(),
                if (composition.jaune > 0 && composition.rouge > 0)
                  const SizedBox(
                    width: 5,
                  ),
                if (composition.rouge > 0)
                  CardWidget(
                    isRed: true,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:app/models/composition.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:app/widget/joueur_logo_widget.dart';
import 'package:flutter/material.dart';

class CompositionElementWidget extends StatelessWidget {
  const CompositionElementWidget(
      {super.key, required this.composition, required this.isHome});
  final JoueurComposition composition;
  final bool isHome;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Badge(
            offset: Offset(0, 5),
            backgroundColor: Colors.white,
            textColor: isHome ? Colors.blue : Colors.black,
            alignment: Alignment.bottomCenter,
            label: Text(
              (composition.numero).toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Stack(
              children: [
                SizedBox(
                    height: 40,
                    width: 50,
                    child: JoueurImageLogoWidget(
                      url: composition.imageUrl,
                      noColor: true,
                      radius: 15,
                      size: 25,
                    )),
                if (composition.but > 0)
                  Positioned(
                      left: 0,
                      top: 0,
                      child: GoalWidget(
                        but: composition.but,
                      )),
                if (composition.entrant != null)
                  Positioned(
                      left: 0,
                      top: 22,
                      child: Icon(
                        Icons.subdirectory_arrow_left,
                        color: Colors.red,
                        size: 20,
                      )),
                if (composition.jaune > 0)
                  Positioned(right: 0, top: 5, child: CardWidget()),
                if (composition.rouge > 0)
                  Positioned(
                      right: 3,
                      top: 0,
                      child: CardWidget(
                        isRed: true,
                      )),
                if (composition.isCapitaine)
                  Positioned(right: 0, top: 25, child: CapitaineWidget()),
              ],
            )),
        const SizedBox(
          height: 5,
        ),
        Container(
          constraints: BoxConstraints(maxWidth: 80, minWidth: 40),
          padding: EdgeInsets.all(1),
          color: Colors.white,
          child: Text(
            composition.nom,
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 0,
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: isHome ? Colors.blue : Colors.black),
          ),
        ),
      ],
    );
  }
}

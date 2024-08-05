import 'package:app/models/composition.dart';
import 'package:app/widget/events/composition_events_widget.dart';
import 'package:app/widget/logos/joueur_logo_widget.dart';
import 'package:flutter/material.dart';

class SubstitutLogoWidget extends StatelessWidget {
  const SubstitutLogoWidget({super.key, required this.composition});
  final JoueurComposition composition;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 40,
          width: 40,
        ),
        Badge(
          backgroundColor: Colors.black,
          textColor: Colors.white,
          offset: Offset(0, 5),
          label: Text(composition.numero.toString()),
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 40,
            width: 40,
            child: JoueurImageLogoWidget(
              url: composition.imageUrl,
            ),
          ),
        ),
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
    );
  }
}

import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/pages/arbitre/arbitre_details.dart';
import 'package:app/pages/coach/coach_details.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/widget/logos/arbitre_logo_widget.dart';
import 'package:app/widget/logos/coach_logo_widget.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:app/widget/logos/joueur_logo_widget.dart';
import 'package:flutter/material.dart';

class CircularLogoWidget extends StatelessWidget {
  final String path;
  final Categorie categorie;
  final double? size;
  final bool tap;
  final String? id;

  CircularLogoWidget(
      {super.key,
      required this.path,
      required this.categorie,
      this.size,
      this.tap = false,
      this.id});

  @override
  Widget build(BuildContext context) {
    assert(tap && id != null || !tap);
    final s = size != null ? Size(size!, size!) : Size(70, 70);
    return Container(
      height: s.height,
      width: s.width,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
      child: PhysicalModel(
        elevation: 5,
        shape: BoxShape.circle,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.all(3.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: categorie == Categorie.joueur
              ? GestureDetector(
                  child: JoueurImageLogoWidget(url: path),
                  onTap: id != null && tap
                      ? () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => JoueurDetails(idJoueur: id!)))
                      : null,
                )
              : categorie == Categorie.equipe
                  ? GestureDetector(
                      child: EquipeImageLogoWidget(url: path),
                      onTap: id != null && tap
                          ? () => Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EquipeDetails(id: id!)))
                          : null,
                    )
                  : categorie == Categorie.competition
                      ? GestureDetector(
                          child: CompetitionImageLogoWidget(url: path),
                          onTap: id != null && tap
                              ? () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CompetitionDetails(id: id!)))
                              : null,
                        )
                      : categorie == Categorie.coach
                          ? GestureDetector(
                              child: CoachImageLogoWidget(url: path),
                              onTap: id != null && tap
                                  ? () => Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CoachDetails(id: id!)))
                                  : null,
                            )
                          : categorie == Categorie.arbitre
                              ? GestureDetector(
                                  child: ArbitreImageLogoWidget(url: path),
                                  onTap: id != null && tap
                                      ? () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ArbitreDetails(id: id!)))
                                      : null,
                                )
                              : CircleAvatar(),
        ),
      ),
    );
  }
}

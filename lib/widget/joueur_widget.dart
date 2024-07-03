import 'package:app/models/joueur.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/widget/joueur_logo_widget.dart';
import 'package:flutter/material.dart';

class JoueurListTileWidget extends StatelessWidget {
  final Joueur joueur;
  final Function? onTap;
  final bool showEquipe;
  const JoueurListTileWidget(
      {super.key, required this.joueur, this.onTap, this.showEquipe = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.white,
      onTap: () {
        if (onTap != null) {
          onTap!();
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => JoueurDetails(idJoueur: joueur.idJoueur)));
      },
      leading: Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          height: 60,
          width: 60,
          child: JoueurImageLogoWidget(url: joueur.imageUrl)),
      title: Text(joueur.nomJoueur),
      subtitle: showEquipe ? Text(joueur.nomEquipe) : null,
    );
  }
}

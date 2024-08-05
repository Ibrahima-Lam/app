import 'package:app/models/joueur.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/widget/logos/joueur_logo_widget.dart';
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
      leading: CircleAvatar(
        backgroundColor: Color(0xFFF5F5F5),
        child: Container(
          height: 50,
          width: 50,
          child: JoueurImageLogoWidget(url: joueur.imageUrl),
        ),
      ),
      title: Text(joueur.nomJoueur),
      subtitle: showEquipe ? Text(joueur.participant.nomEquipe) : null,
    );
  }
}

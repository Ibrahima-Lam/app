import 'package:app/core/enums/categorie_enum.dart';
import 'package:app/widget/equipe_logo_widget.dart';
import 'package:app/widget/joueur_logo_widget.dart';
import 'package:flutter/material.dart';

class CircularLogoWidget extends StatelessWidget {
  final String path;
  final Categorie categorie;
  final double? size;
  const CircularLogoWidget(
      {super.key, required this.path, required this.categorie, this.size});

  @override
  Widget build(BuildContext context) {
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
                ? JoueurImageLogoWidget(url: path)
                : EquipeImageLogoWidget(url: path)),
      ),
    );
  }
}

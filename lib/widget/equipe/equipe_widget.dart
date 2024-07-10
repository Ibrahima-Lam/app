import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';

class EquipeListTileWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String id;
  const EquipeListTileWidget(
      {super.key, required this.id, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        shape: RoundedRectangleBorder(
            side: BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.8))),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EquipeDetails(id: id),
            ),
          );
        },
        leading: Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 0),
          height: 60,
          width: 60,
          child: EquipeImageLogoWidget(),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}

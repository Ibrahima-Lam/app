import 'package:app/pages/equipe/equipe_details.dart';
import 'package:flutter/material.dart';

class EquipeListTileWidet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String id;
  const EquipeListTileWidet(
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
        leading: CircleAvatar(
          backgroundColor: Color(0xFFDCDCDC),
          radius: 20,
          child: Icon(
            Icons.people,
            color: Colors.white,
          ),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}

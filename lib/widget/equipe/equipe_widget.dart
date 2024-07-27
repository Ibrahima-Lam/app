import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';

class EquipeListTileWidget extends StatelessWidget {
  final String title;
  final String? url;
  final String? subtitle;
  final String id;
  final bool border;
  const EquipeListTileWidget(
      {super.key,
      required this.id,
      required this.title,
      this.subtitle,
      this.border = true,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        shape: border
            ? RoundedRectangleBorder(
                side:
                    BorderSide(width: 0.5, color: Colors.grey.withOpacity(0.8)))
            : null,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EquipeDetails(id: id),
            ),
          );
        },
        leading: Container(
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          height: 50,
          width: 50,
          child: EquipeImageLogoWidget(url: url),
        ),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
      ),
    );
  }
}

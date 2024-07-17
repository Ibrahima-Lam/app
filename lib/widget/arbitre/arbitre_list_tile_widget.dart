import 'package:app/models/arbitres/arbitre.dart';
import 'package:app/pages/arbitre/arbitre_details.dart';
import 'package:app/widget/logos/arbitre_logo_widget.dart';
import 'package:flutter/material.dart';

class ArbitreListTileWidget extends StatelessWidget {
  final Arbitre arbitre;

  const ArbitreListTileWidget({super.key, required this.arbitre});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ArbitreDetails(id: arbitre.idArbitre)));
      },
      leading: Container(
        height: 50,
        width: 50,
        child: ArbitreImageLogoWidget(url: arbitre.imageUrl),
      ),
      title: Text(arbitre.nomArbitre),
      subtitle: Text(arbitre.role),
      trailing: Icon(
        arbitre.role == 'assistant'
            ? Icons.flag
            : arbitre.role == 'principale'
                ? Icons.sports
                : arbitre.role == 'var'
                    ? Icons.tv
                    : Icons.settings_backup_restore_outlined,
        color: Colors.green,
      ),
    );
  }
}

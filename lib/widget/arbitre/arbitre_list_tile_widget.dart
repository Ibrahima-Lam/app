import 'package:fscore/models/arbitres/arbitre.dart';
import 'package:fscore/pages/arbitre/arbitre_details.dart';
import 'package:fscore/widget/logos/arbitre_logo_widget.dart';
import 'package:flutter/material.dart';

class ArbitreListTileWidget extends StatelessWidget {
  final Arbitre arbitre;
  final Function(Arbitre arbitre)? onTap;

  const ArbitreListTileWidget({super.key, required this.arbitre, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) {
          onTap!(arbitre);
          return;
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ArbitreDetails(id: arbitre.idArbitre)));
      },
      leading: CircleAvatar(
        backgroundColor: Color(0xFFF5F5F5),
        child: Container(
          height: 50,
          width: 50,
          child: ArbitreImageLogoWidget(url: arbitre.imageUrl),
        ),
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

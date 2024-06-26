import 'package:app/models/user.dart';
import 'package:app/pages/equipe/equipe_page.dart';
import 'package:app/pages/competition/competition_page.dart';
import 'package:app/pages/game/game_search.dart';
import 'package:app/pages/joueur/joueur_page.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Color color = const Color(0xFF263238);
final double size = 25;

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (context, val, child) {
      User? user = val.user;
      return Drawer(
        elevation: 20,
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              duration: Duration(milliseconds: 200),
              child: Column(
                children: [
                  PersonWidget(radius: 30),
                  const SizedBox(height: 10),
                  Text(
                    user?.name ?? 'Utilisateur',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
            listTileWidget(
                icon: Icon(
                  color: color,
                  Icons.house,
                  size: size,
                ),
                title: 'Competitions',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CompetitionPage()));
                }),
            listTileWidget(
                icon: Icon(
                  color: color,
                  Icons.safety_check,
                  size: size,
                ),
                title: 'Equipes',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => EquipePage()));
                }),
            listTileWidget(
                icon: Icon(
                  color: color,
                  Icons.person,
                  size: size,
                ),
                title: 'Joueurs',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => JoueurPage()));
                }),
            listTileWidget(
                icon: Icon(
                  color: color,
                  Icons.gamepad,
                  size: size,
                ),
                title: 'Matchs',
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => GameSearchPage()));
                }),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.person_3_rounded,
                size: size,
              ),
              title: 'Coachs',
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.person_pin,
                size: size,
              ),
              title: 'Arbitres',
            ),
            const Divider(),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.account_box,
                size: size,
              ),
              title: user == null ? 'Se connecter' : 'Se Deconnecter',
              onTap: () {
                context.read<UserProvider>().changeUser();
              },
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.info,
                size: size,
              ),
              title: 'Plus d\'infos',
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.help,
                size: size,
              ),
              title: 'Aide',
            ),
            const Divider(),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.contact_phone,
                size: size,
              ),
              title: 'Nous contacter',
            ),
          ],
        ),
      );
    });
  }

  Widget listTileWidget(
      {required String title, Icon? icon, Function()? onTap}) {
    return ListTile(
      minVerticalPadding: 0,
      horizontalTitleGap: 10,
      onTap: onTap,
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

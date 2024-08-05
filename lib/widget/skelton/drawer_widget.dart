import 'package:app/models/user.dart';
import 'package:app/pages/arbitre/arbitre_page.dart';
import 'package:app/pages/coach/coach_page.dart';
import 'package:app/pages/equipe/equipe_page.dart';
import 'package:app/pages/competition/competition_page.dart';
import 'package:app/pages/game/game_search.dart';
import 'package:app/pages/joueur/joueur_page.dart';
import 'package:app/pages/skelton/aide_page.dart';
import 'package:app/pages/skelton/contact_page.dart';
import 'package:app/pages/skelton/login_page.dart';
import 'package:app/pages/skelton/paramettre_page.dart';
import 'package:app/pages/skelton/plus_infos_page.dart';
import 'package:app/pages/skelton/signaler_page.dart';
import 'package:app/providers/app_paramettre_provider.dart';
import 'package:app/providers/user_provider.dart';
import 'package:app/widget/events/composition_events_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final Color color = const Color(0xFF1C2834);
final double size = 28;

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, AppParamettreProvider>(
        builder: (context, val, paramettre, child) {
      User? user = val.user;
      return Drawer(
        elevation: 20,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
        child: ListView(
          children: [
            DrawerHeader(
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(0),
              duration: Duration(milliseconds: 200),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  PersonWidget(radius: 30),
                  const SizedBox(height: 10),
                  if (paramettre.appParamettre.showUserName)
                    Text(
                      user?.name ?? 'Pas d\'utilisateur',
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
                title: 'Compétitions',
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
              title: 'Entraineurs',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => CoachPage()));
              },
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.person_pin,
                size: size,
              ),
              title: 'Arbitres',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ArbitrePage()));
              },
            ),
            const Divider(),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.account_box,
                size: size,
              ),
              title: user == null ? 'Se connecter' : 'Se Deconnecter',
              onTap: () async {
                if (user == null) {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()));
                } else {
                  final bool? logout = await showDialog(
                      context: context,
                      builder: (context) => ConfirmDialogWidget(
                            title: 'Confirmation de deconnexion',
                            content: 'Voulez vous deconnecter ?',
                          ));
                  if (logout == true)
                    context.read<UserProvider>().deconnectUser();
                }
              },
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.settings,
                size: size,
              ),
              title: 'Paramettre',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ParamettrePage()));
              },
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.info,
                size: size,
              ),
              title: 'Plus d\'infos',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => PlusInfosPage()));
              },
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.help,
                size: size,
              ),
              title: 'Aide',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const AidePage()));
              },
            ),
            const Divider(),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.contact_phone,
                size: size,
              ),
              title: 'Nous contacter',
              onTap: () {
                Navigator.pop(context);

                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ContactPage()));
              },
            ),
            listTileWidget(
              icon: Icon(
                color: color,
                Icons.dangerous_outlined,
                size: size,
              ),
              title: 'Signaler',
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignalerPage()));
              },
            ),
          ],
        ),
      );
    });
  }

  Widget listTileWidget(
      {required String title, Icon? icon, Function()? onTap}) {
    return ListTile(
      minTileHeight: 48,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
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

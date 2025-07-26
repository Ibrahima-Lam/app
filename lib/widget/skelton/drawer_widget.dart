import 'package:fscore/core/constants/app/styles.dart';
import 'package:fscore/models/user.dart';
import 'package:fscore/pages/arbitre/arbitre_page.dart';
import 'package:fscore/pages/coach/coach_page.dart';
import 'package:fscore/pages/equipe/equipe_page.dart';
import 'package:fscore/pages/competition/competition_page.dart';
import 'package:fscore/pages/game/game_search.dart';
import 'package:fscore/pages/joueur/joueur_page.dart';
import 'package:fscore/pages/skelton/aide_page.dart';
import 'package:fscore/pages/skelton/contact_page.dart';
import 'package:fscore/pages/skelton/login_page.dart';
import 'package:fscore/pages/skelton/paramettre_page.dart';
import 'package:fscore/pages/skelton/plus_infos_page.dart';
import 'package:fscore/pages/skelton/signaler_page.dart';
import 'package:fscore/providers/app_paramettre_provider.dart';
import 'package:fscore/providers/user_provider.dart';
import 'package:fscore/widget/events/composition_events_widget.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final double size = 28;

class DrawerWidget extends StatelessWidget {
  final bool showUser;
  final bool isSideBar;
  final bool checkPlatform;

  const DrawerWidget(
      {super.key,
      this.showUser = true,
      this.isSideBar = false,
      required this.checkPlatform});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraint) {
      return Consumer2<UserProvider, AppParamettreProvider>(
          builder: (context, val, paramettre, child) {
        User? user = val.user;
        return Drawer(
          elevation: 20,
          backgroundColor: Color(0xFFF5F5F5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(0.0)),
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
                          color: kColor,
                        ),
                      ),
                  ],
                ),
              ),
              listTileWidget(
                  icon: Icon(
                    color: kColor,
                    Icons.house,
                    size: size,
                  ),
                  title: 'Compétitions',
                  onTap: () {
                    if (!checkPlatform) Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CompetitionPage()));
                  }),
              listTileWidget(
                  icon: Icon(
                    color: kColor,
                    Icons.safety_check,
                    size: size,
                  ),
                  title: 'Equipes',
                  onTap: () {
                    if (!checkPlatform) Navigator.pop(context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => EquipePage()));
                  }),
              listTileWidget(
                  icon: Icon(
                    color: kColor,
                    Icons.person,
                    size: size,
                  ),
                  title: 'Joueurs',
                  onTap: () {
                    if (!checkPlatform) Navigator.pop(context);
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => JoueurPage()));
                  }),
              listTileWidget(
                  icon: Icon(
                    color: kColor,
                    Icons.gamepad,
                    size: size,
                  ),
                  title: 'Matchs',
                  onTap: () {
                    if (!checkPlatform) Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => GameSearchPage()));
                  }),
              listTileWidget(
                icon: Icon(
                  color: kColor,
                  Icons.person_3_rounded,
                  size: size,
                ),
                title: 'Entraineurs',
                onTap: () {
                  if (!checkPlatform) Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CoachPage()));
                },
              ),
              listTileWidget(
                icon: Icon(
                  color: kColor,
                  Icons.person_pin,
                  size: size,
                ),
                title: 'Arbitres',
                onTap: () {
                  if (!checkPlatform) Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ArbitrePage()));
                },
              ),
              const Divider(),
              listTileWidget(
                icon: Icon(
                  color: kColor,
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
                  color: kColor,
                  Icons.settings,
                  size: size,
                ),
                title: 'Paramettre',
                onTap: () {
                  if (!checkPlatform) Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ParamettrePage()));
                },
              ),
              listTileWidget(
                icon: Icon(
                  color: kColor,
                  Icons.info,
                  size: size,
                ),
                title: 'Plus d\'infos',
                onTap: () {
                  if (!checkPlatform) Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PlusInfosPage()));
                },
              ),
              listTileWidget(
                icon: Icon(
                  color: kColor,
                  Icons.help,
                  size: size,
                ),
                title: 'Aide',
                onTap: () {
                  if (!checkPlatform) Navigator.pop(context);
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AidePage()));
                },
              ),
              const Divider(),
              listTileWidget(
                icon: Icon(
                  color: kColor,
                  Icons.contact_phone,
                  size: size,
                ),
                title: 'Nous contacter',
                onTap: () {
                  if (!checkPlatform) Navigator.pop(context);

                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ContactPage()));
                },
              ),
              listTileWidget(
                icon: Icon(
                  color: kColor,
                  Icons.dangerous_outlined,
                  size: size,
                ),
                title: 'Signaler',
                onTap: () {
                  if (!checkPlatform) Navigator.pop(context);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignalerPage()));
                },
              ),
            ],
          ),
        );
      });
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
          color: kColor,
          fontSize: 15,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

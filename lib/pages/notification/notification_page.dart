import 'package:fscore/core/constants/app/styles.dart';
import 'package:fscore/models/competition.dart';
import 'package:fscore/models/notification.dart';
import 'package:fscore/providers/competition_provider.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/providers/notification_provider.dart';
import 'package:fscore/service/notif_sqlite_service.dart';
import 'package:fscore/widget/logos/competition_logo_image.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:fscore/widget/skelton/tab_bar_widget.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final Function()? openDrawer;
  final bool checkPlatform;
  const NotificationPage(
      {super.key, this.openDrawer, required this.checkPlatform});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<List<Notif>> getData() async {
    try {
      return await NotifSqliteService().getNotifs();
    } catch (e) {
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unreadCountNotifier.value = 0;
    });
  }

  _onDelete(String id) async {
    await NotifSqliteService().deleteNotif(id);
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmDialogWidget(
          title: "Supprimer la notification",
          content: 'Voulez-vous supprimer la notification ?'),
    );
    if (confirm ?? false) {
      await NotifSqliteService().deleteNotif(id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: widget.checkPlatform
              ? null
              : IconButton(
                  onPressed: widget.openDrawer,
                  icon: Icon(Icons.menu),
                ),
          title: const Text('Notification'),
          titleSpacing: 20,
          bottom: TabBarWidget.of(context).build(
            tabs: [
              Tab(text: 'Historique'),
              Tab(text: 'Abonnement'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final List<Notif> notif = snapshot.data!;
                  return notif.isEmpty
                      ? const Center(
                          child: Text('Aucune notification'),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: notif
                                .take(100)
                                .map((e) => NotificationWidget(
                                    notif: e,
                                    onDelete: () => _onDelete(e.idNotif)))
                                .toList(),
                          ),
                        );
                }),
            AbonnementWidget(),
          ],
        ),
        /*  floatingActionButton: FloatingActionButton(
          onPressed: () {
            LocalNotificationService().showNotification(
                title: 'Titre de la notification',
                description: 'Description de la notification',
                data: {});
          },
          child: Icon(Icons.add),
        ), */
      ),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final Notif notif;

  final Function() onDelete;

  const NotificationWidget({required this.notif, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: ListTile(
        onTap: () async {
          showModalBottomSheet(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              context: context,
              builder: (context) {
                return Container(
                  width: double.infinity,
                  height: 400,
                  child: Column(
                    spacing: 10,
                    children: [
                      SizedBox(height: 10),
                      Text(notif.title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                      Text(notif.content,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[800],
                          )),
                      Text(notif.date,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          )),
                      SizedBox(height: 10),
                      if (notif.idGame?.isNotEmpty ?? false)
                        ElevatedButton(
                          onPressed: () async {
                            final result = await context
                                .read<GameProvider>()
                                .checkGame(notif.idGame!);

                            if (result)
                              Navigator.pushNamed(
                                context,
                                '/game_details',
                                arguments: {
                                  'id': notif.idGame,
                                },
                              );
                          },
                          child: Text('Voir le jeu'),
                        ),
                    ],
                  ),
                );
              });
        },
        title: Text(notif.title),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notif.content,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[800],
                )),
            Text(
              notif.date.substring(0, 16),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton(
            itemBuilder: (context) => [
                  PopupMenuItem(
                    child: const Text('Supprimer'),
                    onTap: onDelete,
                  ),
                ]),
      ),
    );
  }
}

class AbonnementWidget extends StatefulWidget {
  const AbonnementWidget({super.key});

  @override
  State<AbonnementWidget> createState() => _AbonnementWidgetState();
}

class _AbonnementWidgetState extends State<AbonnementWidget> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationProvider>().loadAbonnements();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<NotificationProvider, CompetitionProvider>(
      builder: (context, notificationProvider, competitionProvider, _) {
        final abonnements = notificationProvider.abonnements;
        final competitions = competitionProvider.collection.competitions;

        final competitionsAbonnees = competitions
            .where((c) =>
                abonnements.contains(c.codeCompetition) ||
                abonnements.contains(c.codeEdition))
            .toList();
        final competitionsNonAbonnees = competitions
            .where((c) =>
                !abonnements.contains(c.codeCompetition) &&
                !abonnements.contains(c.codeEdition))
            .toList();

        return SingleChildScrollView(
          child: Column(
            children: [
              if (competitions.isEmpty)
                const Center(
                  child: Text('Aucune compétition disponible'),
                ),
              ...competitionsAbonnees.map((competition) {
                return _CompetitionTileWidget(
                    competition: competition,
                    onPressed: () async {
                      await context
                          .read<NotificationProvider>()
                          .removeAbonnement(competition.codeCompetition);
                    },
                    isSubscribed: true);
              }).toList(),
              ...competitionsNonAbonnees.map((competition) {
                return _CompetitionTileWidget(
                  competition: competition,
                  onPressed: () async {
                    await context
                        .read<NotificationProvider>()
                        .addAbonnement(competition.codeCompetition);
                  },
                  isSubscribed: false,
                );
              }).toList(),
            ],
          ),
        );
      },
    );
  }
}

class _CompetitionTileWidget extends StatelessWidget {
  final Competition competition;
  final Function()? onPressed;
  final bool isSubscribed;

  const _CompetitionTileWidget(
      {required this.competition, this.onPressed, required this.isSubscribed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: ListTile(
        leading: CompetitionImageLogoWidget(url: competition.imageUrl),
        title: Text(competition.nomCompetition),
        trailing: IconButton(
          icon: Icon(
              !isSubscribed ? Icons.notifications_off : Icons.notifications,
              color: isSubscribed ? Colors.green : kColor),
          onPressed: onPressed,
        ),
        onTap: () {
          Navigator.pushNamed(
            context,
            '/competition_details',
            arguments: {
              'id': competition.codeEdition,
            },
          );
        },
      ),
    );
  }
}

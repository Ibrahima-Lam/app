import 'package:fscore/models/notification.dart';
import 'package:fscore/pages/game/game_details.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/service/notif_sqlite_service.dart';
import 'package:fscore/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
    return Scaffold(
      appBar: AppBar(
        leading: widget.checkPlatform
            ? null
            : IconButton(
                onPressed: widget.openDrawer,
                icon: Icon(Icons.menu),
              ),
        title: const Text('Notification'),
        titleSpacing: 20,
      ),
      body: FutureBuilder(
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
                          .map((e) => NotificationWidget(
                              notif: e, onDelete: () => _onDelete(e.idNotif)))
                          .toList(),
                    ),
                  );
          }),
    );
  }
}

class NotificationWidget extends StatelessWidget {
  final Notif notif;

  final Function() onDelete;

  const NotificationWidget({required this.notif, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.getToken().then((value) {
      print(value);
    });

    return Card(
      margin: EdgeInsets.symmetric(vertical: 1, horizontal: 4),
      child: ListTile(
        onTap: () async {
          bool check =
              await context.read<GameProvider>().checkGame(notif.idGame ?? '');
          if (check) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameDetails(id: notif.idGame ?? '')));
          }
        },
        title: Text(notif.title),
        subtitle: Text(notif.content),
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

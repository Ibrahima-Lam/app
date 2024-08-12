import 'package:app/models/notification.dart';
import 'package:app/pages/game/game_details.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/service/notif_sqlite_service.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/skelton/drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationPage extends StatefulWidget {
  final Function()? openDrawer;
  const NotificationPage({super.key, this.openDrawer});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<List<Notif>> getData() async {
    return await NotifSqliteService().getNotifs();
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
        leading: IconButton(
          onPressed: widget.openDrawer,
          icon: Icon(Icons.menu),
        ),
        title: const Text('Notification'),
        titleSpacing: 20,
        actions: [Icon(Icons.notifications)],
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
      drawer: const DrawerWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await NotifSqliteService().insertNotif(Notif(
              idNotif: '3',
              title: 'titre3',
              content: 'contenu3',
              date: DateTime.now().toString(),
              type: 'type'));
          setState(() {});
        },
        child: const Icon(Icons.notifications),
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

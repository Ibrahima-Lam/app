import 'package:app/widget/skelton/drawer_widget.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final Function()? openDrawer;
  const NotificationPage({super.key, this.openDrawer});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Future<bool> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  void initState() {
    super.initState();
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
      body: FutureBuilder<bool>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur!'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return Center(
              child: Text('Page de notification disponible !'),
            );
          }),
      drawer: const DrawerWidget(),
    );
  }
}

import 'package:app/widget/drawer_widget.dart';
import 'package:flutter/material.dart';

class ExplorationPage extends StatefulWidget {
  final Function()? openDrawer;
  const ExplorationPage({super.key, this.openDrawer});

  @override
  State<ExplorationPage> createState() => _ExplorationPageState();
}

class _ExplorationPageState extends State<ExplorationPage> {
  Future<bool> getData() async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.openDrawer,
          icon: Icon(Icons.menu),
        ),
        title: const Text('Exploration'),
        titleSpacing: 20,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur!'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.green,
              ),
            );
          }
          return const Center(
            child: Text('Listes d\'exploration'),
          );
        },
      ),
      drawer: const DrawerWidget(),
    );
  }
}

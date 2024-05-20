import 'package:app/models/infos.dart';
import 'package:app/providers/infos_provider.dart';
import 'package:app/service/infos_service.dart';
import 'package:app/widget/drawer_widget.dart';
import 'package:app/widget/infos_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosPage extends StatefulWidget {
  final Function()? openDrawer;
  const InfosPage({super.key, this.openDrawer});

  @override
  State<InfosPage> createState() => _InfosPageState();
}

class _InfosPageState extends State<InfosPage> {
  Future<List<Infos>> getData() async {
    return await InfosService.getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.openDrawer,
          icon: Icon(Icons.menu),
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Infos'),
        titleSpacing: 20,
      ),
      body: FutureBuilder<List<Infos>>(
          future: context.read<InfosProvider>().getInformations(),
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

            return Consumer<InfosProvider>(builder: (context, value, child) {
              final List<Infos> dataInfos = value.infos;
              return ListView.builder(
                itemCount: dataInfos.length,
                itemBuilder: (context, index) {
                  return InfosFullWidget(infos: dataInfos[index]);
                },
              );
            });
          }),
      drawer: const DrawerWidget(),
    );
  }
}

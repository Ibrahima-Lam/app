// ignore_for_file: must_be_immutable

import 'package:app/models/app_paramettre.dart';
import 'package:app/providers/app_paramettre_provider.dart';
import 'package:app/service/app_paramettre_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParamettrePage extends StatelessWidget {
  ParamettrePage({super.key});

  late AppParamettre paramettre;

  Future<void> _sendData() async {
    await AppParamettreService().setData(paramettre);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paramettre'),
      ),
      body: FutureBuilder(
          future: AppParamettreService().getData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return Consumer<AppParamettreProvider>(
                builder: (context, appParamettreProvider, _) {
              paramettre = appParamettreProvider.appParamettre;
              return SingleChildScrollView(
                child: StatefulBuilder(builder: (context, setState) {
                  return Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Afficher le nom d\'utilisateur'),
                              Switch(
                                  splashRadius: 3,
                                  value: paramettre.showUserName,
                                  onChanged: (value) {
                                    setState(() {
                                      paramettre.showUserName = value;
                                      _sendData();
                                    });
                                  }),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              );
            });
          }),
    );
  }
}
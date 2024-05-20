import 'package:app/models/joueur.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurDetails extends StatefulWidget {
  final String idJoueur;
  const JoueurDetails({super.key, required this.idJoueur});

  @override
  State<JoueurDetails> createState() => _JoueurDetailsState();
}

class _JoueurDetailsState extends State<JoueurDetails> {
  List<String> tabs = ['tab1', 'tab2', 'tab3', 'tab4', 'tab5'];
  late final Joueur joueur;

  Future<bool> _getJoueur(BuildContext context) async {
    joueur =
        await context.read<JoueurProvider>().getJoueursByid(widget.idJoueur);
    return true;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _getJoueur(context),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('erreur!'),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              );
            }

            return DefaultTabController(
              length: tabs.length,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      title: Text(joueur.nomJoueur),
                      forceElevated: innerBoxIsScrolled,
                      expandedHeight: 250.0,
                      pinned: true,
                      flexibleSpace: const FlexibleSpaceBar(
                          background: Center(
                        child: CircleAvatar(
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 50,
                          ),
                        ),
                      )),
                      bottom: TabBarWidget.build(
                          tabs: tabs
                              .map((e) => Tab(
                                    text: e,
                                  ))
                              .toList()),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    for (String _ in tabs) Count(),
                  ],
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Counter().increment();
      }),
    );
  }
}

class Count extends StatelessWidget {
  Count({super.key});
  final Counter counter = Counter();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: counter,
      builder: (context, child) {
        return Column(
          children: [
            Container(
              child: Text(counter.count.toString()),
            ),
            ElevatedButton(
                onPressed: () {
                  counter.increment();
                },
                child: Text('increment'))
          ],
        );
      },
    );
  }
}

class Counter extends ChangeNotifier {
  int count = 0;
  void increment() {
    count++;
    notifyListeners();
  }

  void decrement() {
    count--;
    notifyListeners();
  }
}

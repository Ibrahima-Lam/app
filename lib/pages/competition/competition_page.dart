import 'package:app/models/competition.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:app/widget/form/text_search_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CompetitionPage extends StatefulWidget {
  CompetitionPage({super.key});

  @override
  State<CompetitionPage> createState() => _CompetitionPageState();
}

class _CompetitionPageState extends State<CompetitionPage> {
  ValueNotifier<String> competitionNotifier = ValueNotifier('');

  late final TextEditingController textEditingController;

  @override
  void initState() {
    textEditingController = TextEditingController()
      ..addListener(() {
        competitionNotifier.value = textEditingController.text;
      });
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compétitions'),
      ),
      body: Container(
        child: FutureBuilder(
          future: context.read<CompetitionProvider>().getCompetitions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('Erreur!'),
              );
            }

            return Consumer<CompetitionProvider>(
              builder: (context, value, child) {
                List<Competition> competitions = value.collection.competitions;

                return competitions.length == 0
                    ? const Center(
                        child: Text('Pas de donnees'),
                      )
                    : Column(
                        children: [
                          TextSearchFieldWidget(
                            textEditingController: textEditingController,
                            hintText: 'Recherche de Competition...',
                          ),
                          Expanded(
                            child: Card(
                              child: ValueListenableBuilder(
                                  valueListenable: competitionNotifier,
                                  builder: (context, val, child) {
                                    competitions = competitionNotifier
                                            .value.isNotEmpty
                                        ? value.collection.competitions
                                            .where((element) => element
                                                .nomCompetition
                                                .toUpperCase()
                                                .startsWith(competitionNotifier
                                                    .value
                                                    .toUpperCase()))
                                            .toList()
                                        : value.collection.competitions;
                                    return ListView.separated(
                                        itemCount: competitions.length,
                                        separatorBuilder: (context, index) =>
                                            Divider(),
                                        itemBuilder: (context, index) =>
                                            CompetitionListTileWidget(
                                              competition: competitions[index],
                                            ));
                                  }),
                            ),
                          )
                        ],
                      );
              },
            );
          },
        ),
      ),
    );
  }
}

class CompetitionListTileWidget extends StatelessWidget {
  final Competition competition;
  const CompetitionListTileWidget({super.key, required this.competition});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CompetitionDetails(id: competition.codeEdition)));
      },
      leading: Container(
        height: 60,
        width: 60,
        padding: EdgeInsets.symmetric(vertical: 2.0),
        child: CompetitionImageLogoWidget(url: competition.imageUrl),
      ),
      title: Text(competition.nomCompetition),
      subtitle: Text(competition.localiteCompetition ?? ''),
    );
  }
}

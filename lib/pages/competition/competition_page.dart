import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/competition.dart';
import 'package:app/pages/competition/competition_details.dart';
import 'package:app/pages/forms/competition_form.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/providers/paramettre_provider.dart';
import 'package:app/widget/logos/competition_logo_image.dart';
import 'package:app/widget/form/text_search_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  _onDelete(Competition competition) async {
    await context
        .read<CompetitionProvider>()
        .removeCompetition(competition.codeEdition);
  }

  _onEdit(Competition competition) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CompetitionForm(
              competition: competition,
            )));
  }

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

            return Consumer2<CompetitionProvider, ParamettreProvider>(
              builder: (context, value, paramettreProvider, child) {
                final bool enabled = paramettreProvider.checkRootUser();

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
                                              onEdit: _onEdit,
                                              onDelete: _onDelete,
                                              enabled: enabled,
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
  final Function(Competition competition) onDelete;
  final Function(Competition competition) onEdit;
  final bool enabled;
  const CompetitionListTileWidget(
      {super.key,
      required this.competition,
      this.enabled = false,
      required this.onDelete,
      required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enabled,
      startActionPane: ActionPane(
        motion: DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) => onDelete(competition),
            icon: Icons.delete,
            foregroundColor: Colors.red,
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
            onPressed: (context) => onEdit(competition),
            icon: Icons.edit,
            foregroundColor: Colors.grey,
          ),
        ],
      ),
      child: ListTile(
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
        title: Text(
          competition.nomCompetition.capitalize(),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(fontSize: 15),
        ),
        subtitle: Text((competition.localiteCompetition ?? '').capitalize(),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}

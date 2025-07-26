import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/controllers/game/game_controller.dart';
import 'package:fscore/core/extension/int_extension.dart';
import 'package:fscore/core/extension/list_extension.dart';
import 'package:fscore/models/game.dart';
import 'package:fscore/models/groupe.dart';
import 'package:fscore/models/niveau.dart';
import 'package:fscore/models/participation.dart';
import 'package:fscore/providers/game_provider.dart';
import 'package:fscore/providers/groupe_provider.dart';
import 'package:fscore/providers/participation_provider.dart';
import 'package:fscore/service/niveau_service.dart';
import 'package:fscore/widget/form/dropdown_menu_app_form_widget.dart';
import 'package:fscore/widget/form/elevated_button_form_widget.dart';
import 'package:fscore/widget/form/text_form_field_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameForm extends StatelessWidget {
  final String codeEdition;
  final Game? game;
  const GameForm({super.key, required this.codeEdition, this.game});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(title: Text('Formulaire de match')),
        body: FutureBuilder(
            future: Future.wait([
              NiveauService.getNiveaux(),
              context.read<ParticipationProvider>().getParticipations(),
              context.read<GroupeProvider>().getGroupes(),
            ]),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('erreur!'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              List<Niveau> niveaux = [];
              niveaux = (snapshot.data ?? []).elementAt(0) as List<Niveau>;

              List<Participation> participations = [];
              participations = ((snapshot.data ?? []).elementAt(1)
                      as List<Participation>)
                  .where((element) => element.groupe.codeEdition == codeEdition)
                  .toList();

              List<Groupe> groupes = [];
              groupes = ((snapshot.data ?? []).elementAt(2) as List<Groupe>)
                  .where((element) => element.codeEdition == codeEdition)
                  .toList();

              return GameFormListWidget(
                game: game,
                groupes: groupes,
                niveaux: niveaux,
                participations: participations,
                codeEdition: codeEdition,
              );
            }),
      ),
    );
  }
}

class GameFormListWidget extends StatefulWidget {
  final List<Niveau> niveaux;
  final List<Participation> participations;
  final List<Groupe> groupes;
  final Game? game;
  final String codeEdition;

  const GameFormListWidget(
      {super.key,
      required this.groupes,
      required this.niveaux,
      required this.participations,
      this.game,
      required this.codeEdition});

  @override
  State<GameFormListWidget> createState() => _GameFormListWidgetState();
}

class _GameFormListWidgetState extends State<GameFormListWidget> {
  late final TextEditingController groupeController;
  late final TextEditingController homeController;
  late final TextEditingController awayController;
  late final TextEditingController niveauController;
  late final TextEditingController stadeController;
  late final TextEditingController dateController;
  late final TextEditingController heureController;
  @override
  void initState() {
    groupeController = TextEditingController(text: widget.game?.idGroupe);
    homeController = TextEditingController(text: widget.game?.idHome);
    awayController = TextEditingController(text: widget.game?.idAway);
    niveauController = TextEditingController(text: widget.game?.codeNiveau);
    stadeController = TextEditingController(text: widget.game?.stadeGame);
    dateController = TextEditingController(text: widget.game?.dateGame);
    heureController = TextEditingController(text: widget.game?.heureGame);
    super.initState();
  }

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  _onSubmit() async {
    if ([homeController.text, awayController.text, groupeController.text]
        .hasOneEmpty) return;
    if (homeController.text == awayController.text) return;

    Game? game = GameController.toGame(
        idGame: widget.game != null
            ? widget.game!.idGame
            : 'G' + DateController.dateCollapsed,
        idHome: homeController.text,
        idAway: awayController.text,
        idGroupe: groupeController.text,
        codeNiveau: niveauController.text,
        dateGame: dateController.text,
        heureGame: heureController.text,
        stadeGame: stadeController.text,
        participants: widget.participations.map((e) => e.participant).toList(),
        niveaux: widget.niveaux,
        groupes: widget.groupes);

    if (game == null) return;

    setIsloading(true);
    final bool res = widget.game != null
        ? await context.read<GameProvider>().editGame(widget.game!.idGame, game)
        : await context.read<GameProvider>().addGame(game);

    setIsloading(false);
    if (res) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> niveauMap = widget.niveaux
        .asMap()
        .map((key, value) => MapEntry(value.nomNiveau, value.codeNiveau));
    final Map<String, dynamic> groupeMap = widget.groupes.asMap().map(
        (key, value) => MapEntry(
            value.codePhase == 'grp' ? value.nomGroupe : value.phase.nomPhase,
            value.idGroupe));
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 5.0),
          DropDownMenuAppFormWidget(
            entries: groupeMap,
            title: 'Groupe',
            controller: groupeController,
          ),
          ListenableBuilder(
            listenable: groupeController,
            builder: (context, child) {
              final Map<String, dynamic> participationMap = widget
                  .participations
                  .where(
                    (element) => element.idGroupe == groupeController.text,
                  )
                  .toList()
                  .asMap()
                  .map((key, value) => MapEntry(
                      value.participant.nomEquipe, value.idParticipant));
              return Column(
                children: [
                  DropDownMenuAppFormWidget(
                    entries: participationMap,
                    title: 'Receveur',
                    controller: homeController,
                  ),
                  DropDownMenuAppFormWidget(
                    entries: participationMap,
                    title: 'Reçu',
                    controller: awayController,
                  ),
                ],
              );
            },
          ),
          DropDownMenuAppFormWidget(
            entries: niveauMap,
            title: 'Niveau',
            controller: niveauController,
          ),
          TextFormFieldWidget(
              controller: stadeController, hintText: 'Entrer le nom du stade'),
          DateOuHeureFormWidget(
            controller: dateController,
            label: 'Date',
            isDate: true,
          ),
          DateOuHeureFormWidget(
            controller: heureController,
            label: 'Heure',
            isDate: false,
          ),
          ElevatedButtonFormWidget(
            onPressed: _onSubmit,
            isSending: isLoading,
          ),
        ],
      ),
    );
  }
}

class DateOuHeureFormWidget extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final bool isDate;
  const DateOuHeureFormWidget(
      {super.key,
      required this.controller,
      required this.isDate,
      required this.label});

  @override
  State<DateOuHeureFormWidget> createState() => _DateOuHeureFormWidgetState();
}

class _DateOuHeureFormWidgetState extends State<DateOuHeureFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: ListTile(
          title: Text(widget.label),
          subtitle: Text(widget.controller.text),
          trailing: IconButton(
              onPressed: () async {
                if (widget.isDate) {
                  DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030));
                  if (date != null) {
                    setState(() {
                      widget.controller.text = date.toString().substring(0, 10);
                    });
                  }
                  return;
                } else {
                  int? h = int.tryParse(widget.controller.text.split(':')[0]);
                  int? m = int.tryParse(widget.controller.text.split(':')[1]);

                  TimeOfDay? heure = await showTimePicker(
                      context: context,
                      initialTime: h != null && m != null
                          ? TimeOfDay(hour: h, minute: m)
                          : TimeOfDay.now());
                  if (heure != null) {
                    setState(() {
                      widget.controller.text =
                          '${heure.hour.toStringMinLengh(2)}:${heure.minute.toStringMinLengh(2)}';
                    });
                  }
                }
              },
              icon: Icon(widget.isDate ? Icons.calendar_month : Icons.timer)),
        ),
      ),
    );
  }
}

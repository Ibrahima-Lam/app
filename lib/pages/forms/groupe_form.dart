import 'package:app/models/groupe.dart';
import 'package:app/models/phase.dart';
import 'package:app/providers/groupe_provider.dart';
import 'package:app/service/phase_service.dart';
import 'package:app/widget/form/dropdown_menu_app_form_widget.dart';
import 'package:app/widget/form/elevated_button_form_widget.dart';
import 'package:app/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupeForm extends StatefulWidget {
  final String codeEdition;
  final Groupe? groupe;
  const GroupeForm({super.key, required this.codeEdition, this.groupe});

  @override
  State<GroupeForm> createState() => _GroupeFormState();
}

class _GroupeFormState extends State<GroupeForm> {
  late final TextEditingController nomController;
  late final TextEditingController phaseController;
  List<Phase> phases = [];
  @override
  void initState() {
    nomController = TextEditingController(text: widget.groupe?.nomGroupe);
    phaseController = TextEditingController(text: widget.groupe?.codePhase);
    super.initState();
  }

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void _onSubmit() async {
    if (nomController.text.isEmpty ||
        phaseController.text.isEmpty ||
        phases.isEmpty) return;
    final Groupe groupe = Groupe(
        idGroupe: widget.codeEdition + nomController.text,
        nomGroupe: nomController.text,
        codeEdition: widget.codeEdition,
        codePhase: phaseController.text,
        phase: phases.firstWhere(
            (element) => element.codePhase == phaseController.text));
    setIsloading(true);
    final bool res = widget.groupe != null
        ? await context
            .read<GroupeProvider>()
            .editGroupe(widget.groupe!.idGroupe, groupe)
        : await context.read<GroupeProvider>().addGroupe(groupe);
    setIsloading(false);
    if (res) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Formulaire de  Groupes'),
        ),
        body: FutureBuilder(
            future: Future.wait([
              PhaseService.getData(),
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

              phases = (snapshot.data ?? []).elementAt(0) as List<Phase>;

              return Consumer<GroupeProvider>(
                  builder: (context, groupeProvider, _) {
                List<Groupe> groupes =
                    groupeProvider.getGroupesBy(edition: widget.codeEdition);
                final Map<String, dynamic> phaseMap = phases.asMap().map(
                    (key, value) => MapEntry(value.nomPhase, value.codePhase));

                final Map<String, String> noms = names
                    .where((element) {
                      if (widget.groupe != null) return true;
                      return groupes.every((e) =>
                          element.toUpperCase() != e.nomGroupe.toUpperCase());
                    })
                    .toList()
                    .asMap()
                    .map((key, value) => MapEntry(value, value));
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      DropDownMenuAppFormWidget(
                        controller: nomController,
                        entries: noms,
                        title: "Nom de Groupe",
                      ),
                      DropDownMenuAppFormWidget(
                        controller: phaseController,
                        entries: phaseMap,
                        title: "Nom de Phase",
                      ),
                      ElevatedButtonFormWidget(
                        onPressed: _onSubmit,
                        isSending: isLoading,
                      ),
                    ],
                  ),
                );
              });
            }),
      ),
    );
  }
}

List<String> names = 'abcdefghijklmnopqrstuvwxyz'.toUpperCase().split('');

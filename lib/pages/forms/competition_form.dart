import 'package:app/core/enums/competition_type.dart';
import 'package:app/models/competition.dart';
import 'package:app/providers/competition_provider.dart';
import 'package:app/widget/form/dropdown_menu_app_form_widget.dart';
import 'package:app/widget/form/elevated_button_form_widget.dart';
import 'package:app/widget/form/slider_rating_form_widget.dart';
import 'package:app/widget/form/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetitionForm extends StatefulWidget {
  final Competition? competition;
  CompetitionForm({super.key, this.competition});

  @override
  State<CompetitionForm> createState() => _CompetitionFormState();
}

class _CompetitionFormState extends State<CompetitionForm> {
  final GlobalKey _key = GlobalKey<FormState>();
  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  late final TextEditingController nomController;
  late final TextEditingController codeController;
  late final TextEditingController localiteController;
  late final TextEditingController anneeController;
  late final TextEditingController typeController;
  late final TextEditingController ratingController;
  late final TextEditingController nomEditionController;
  late final TextEditingController urlController;

  void _onSubmit() async {
    final Competition competition = Competition(
      codeCompetition: codeController.text,
      nomCompetition: nomController.text,
      codeEdition: codeController.text + anneeController.text,
      nomEdition: nomEditionController.text,
      localiteCompetition: localiteController.text,
      anneeEdition: anneeController.text,
      imageUrl: urlController.text,
      rating: double.parse(ratingController.text),
      type: CompetitionTypeClass(typeController.text),
    );
    setIsloading(true);
    bool res = widget.competition != null
        ? await context.read<CompetitionProvider>().editCompetition(
            widget.competition?.codeEdition ?? competition.codeEdition,
            competition)
        : await context.read<CompetitionProvider>().addCompetition(competition);
    if (res) Navigator.pop(context);
    setIsloading(false);
  }

  @override
  void initState() {
    nomController =
        TextEditingController(text: widget.competition?.nomCompetition);
    codeController =
        TextEditingController(text: widget.competition?.codeCompetition);
    localiteController =
        TextEditingController(text: widget.competition?.localiteCompetition);
    anneeController = TextEditingController(
        text: widget.competition?.anneeEdition ?? '${DateTime.now().year}');
    typeController = TextEditingController(text: widget.competition?.type.text);
    ratingController =
        TextEditingController(text: '${widget.competition?.rating ?? 0}');
    nomEditionController =
        TextEditingController(text: widget.competition?.nomEdition);
    urlController = TextEditingController(text: widget.competition?.imageUrl);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Formulaire de compétition')),
      body: SingleChildScrollView(
        child: Form(
            key: _key,
            child: Column(
              children: [
                const SizedBox(height: 10.0),
                TextFormFieldWidget(
                    controller: codeController,
                    hintText: 'Entrer le code de la compétition'),
                const SizedBox(height: 5.0),
                TextFormFieldWidget(
                    controller: nomController,
                    hintText: 'Entrer le nom de la compétition'),
                const SizedBox(height: 5.0),
                TextFormFieldWidget(
                    controller: nomEditionController,
                    hintText: 'Entrer le nom de l\'édition'),
                const SizedBox(height: 5.0),
                TextFormFieldWidget(
                    controller: localiteController,
                    hintText: 'Entrer la localité de la compétition'),
                const SizedBox(height: 5.0),
                TextFormFieldWidget(
                    controller: urlController,
                    hintText: 'Entrer l\'url du logo'),
                const SizedBox(height: 5.0),
                TextFormFieldWidget(
                    keyboardType: TextInputType.number,
                    controller: anneeController,
                    hintText: 'Entrer l\'année de l\'édition'),
                const SizedBox(height: 5.0),
                SliderRatingFormWidget(controller: ratingController),
                const SizedBox(height: 5.0),
                DropdownMenuAppFormWidget(
                  controller: typeController,
                  entries: {
                    'coupe': 'coupe',
                    'championnat': 'championnat',
                    'amicale': 'amicale',
                    'elimination direct': 'finale',
                  },
                  title: 'Type de compétition',
                ),
                const SizedBox(height: 5.0),
                ElevatedButtonFormWidget(
                  onPressed: _onSubmit,
                  isSending: isLoading,
                ),
              ],
            )),
      ),
    );
  }
}

import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/sponsor.dart';
import 'package:fscore/providers/sponsor_provider.dart';
import 'package:fscore/widget/form/elevated_button_form_widget.dart';
import 'package:fscore/widget/form/file_form_field_widget.dart';
import 'package:fscore/widget/form/text_form_field_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SponsorForm extends StatefulWidget {
  final Sponsor? sponsor;
  final CategorieParams? categorieParams;
  const SponsorForm({super.key, this.sponsor, this.categorieParams});

  @override
  State<SponsorForm> createState() => _SponsorFormState();
}

class _SponsorFormState extends State<SponsorForm> {
  late TextEditingController _descriptionController;
  late TextEditingController _nomController;
  late TextEditingController _imageController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.sponsor?.description);
    _imageController = TextEditingController(text: widget.sponsor?.imageUrl);
    _dateController = TextEditingController(text: widget.sponsor?.date);
    _nomController = TextEditingController(text: widget.sponsor?.nom);
  }

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  _onSubmit() async {
    if (_nomController.text.isEmpty ||
        _imageController.text.isEmpty ||
        _dateController.text.isEmpty) {
      return;
    }
    final Sponsor sponsor = Sponsor(
      idSponsor:
          widget.sponsor?.idSponsor ?? 'S' + DateController.dateCollapsed,
      description: _descriptionController.text,
      nom: _nomController.text,
      imageUrl: _imageController.text,
      date: _dateController.text,
      idArbitre: widget.sponsor?.idArbitre ?? widget.categorieParams?.idArbitre,
      idCoach: widget.sponsor?.idCoach ?? widget.categorieParams?.idCoach,
      idEdition: widget.sponsor?.idEdition ?? widget.categorieParams?.idEdition,
      idParticipant: widget.sponsor?.idParticipant ??
          widget.categorieParams?.idParticipant,
      idJoueur: widget.sponsor?.idJoueur ?? widget.categorieParams?.idJoueur,
      idGame: widget.sponsor?.idGame ?? widget.categorieParams?.idGame,
    );
    setIsloading(true);
    final bool result = widget.sponsor == null
        ? await context.read<SponsorProvider>().addSponsor(sponsor)
        : await context
            .read<SponsorProvider>()
            .editSponsor(widget.sponsor!.idSponsor, sponsor);
    setIsloading(false);
    if (result) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sponsor'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFormFieldWidget(controller: _nomController, hintText: 'Nom'),
              TextFormFieldWidget(
                  controller: _descriptionController,
                  hintText: 'Description',
                  minLines: 5),
              FileFormFieldWidget(
                  controller: _imageController,
                  hintText: 'Image',
                  directory: 'sponsor'),
              Card(
                child: ListTile(
                  title: const Text('Date'),
                  subtitle: Text(_dateController.text),
                  trailing: IconButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime.now().add(const Duration(days: -7)),
                              initialEntryMode: DatePickerEntryMode.calendar,
                              lastDate: DateTime.now())
                          .then(
                        (date) {
                          if (date != null) {
                            setState(() {
                              _dateController.text = date.toString();
                            });
                          }
                        },
                      );
                    },
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
              ),
              ElevatedButtonFormWidget(
                  onPressed: _onSubmit,
                  label: 'Enregistrer',
                  isSending: isLoading)
            ],
          ),
        ),
      ),
    );
  }
}

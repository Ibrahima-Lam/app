import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/core/params/categorie/categorie_params.dart';
import 'package:fscore/models/infos/infos.dart';
import 'package:fscore/providers/infos_provider.dart';
import 'package:fscore/widget/form/elevated_button_form_widget.dart';
import 'package:fscore/widget/form/file_form_field_widget.dart';
import 'package:fscore/widget/form/text_form_field_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfosForm extends StatefulWidget {
  final Infos? infos;
  final CategorieParams categorieParams;
  const InfosForm({super.key, this.infos, required this.categorieParams});

  @override
  State<InfosForm> createState() => _InfosFormState();
}

class _InfosFormState extends State<InfosForm> {
  late TextEditingController _titleController;
  late TextEditingController _textController;
  late TextEditingController _imageController;
  late TextEditingController _sourceController;
  late TextEditingController _datetimeController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.infos?.title);
    _textController = TextEditingController(text: widget.infos?.text);
    _imageController = TextEditingController(text: widget.infos?.imageUrl);
    _sourceController = TextEditingController(text: widget.infos?.source);
    _datetimeController = TextEditingController(text: widget.infos?.datetime);
  }

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  _onSubmit() async {
    if (_titleController.text.isEmpty ||
        _textController.text.isEmpty ||
        _datetimeController.text.isEmpty) {
      return;
    }
    final Infos infos = Infos(
      idInfos: widget.infos?.idInfos ?? 'I' + DateController.dateCollapsed,
      title: _titleController.text,
      text: _textController.text,
      imageUrl: _imageController.text,
      source: _sourceController.text,
      datetime: _datetimeController.text,
      idArbitre: widget.infos?.idArbitre ?? widget.categorieParams.idArbitre,
      idCoach: widget.infos?.idCoach ?? widget.categorieParams.idCoach,
      idEdition: widget.infos?.idEdition ?? widget.categorieParams.idEdition,
      idParticipant:
          widget.infos?.idParticipant ?? widget.categorieParams.idParticipant,
      idJoueur: widget.infos?.idJoueur ?? widget.categorieParams.idJoueur,
      idGame: widget.infos?.idGame ?? widget.categorieParams.idGame,
    );
    setIsloading(true);
    final bool result = widget.infos == null
        ? await context.read<InfosProvider>().addInfos(infos)
        : await context
            .read<InfosProvider>()
            .editInfos(widget.infos!.idInfos, infos);
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
          title: const Text('Informations'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFormFieldWidget(
                  controller: _titleController, hintText: 'Titre'),
              TextFormFieldWidget(
                  controller: _textController, hintText: 'Texte', minLines: 5),
              FileFormFieldWidget(
                  controller: _imageController,
                  hintText: 'Image',
                  directory: 'infos'),
              TextFormFieldWidget(
                  controller: _sourceController, hintText: 'Source'),
              Card(
                child: ListTile(
                  title: const Text('Date et heure'),
                  subtitle: Text(_datetimeController.text),
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
                            showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now())
                                .then((heure) {
                              if (heure != null) {
                                setState(() {
                                  _datetimeController.text = date
                                      .add(Duration(
                                          hours: heure.hour,
                                          minutes: heure.minute))
                                      .toString();
                                });
                              }
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

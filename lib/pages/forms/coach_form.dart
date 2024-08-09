import 'package:app/controllers/competition/date.dart';
import 'package:app/models/coachs/coach.dart';
import 'package:app/models/participant.dart';
import 'package:app/providers/coach_provider.dart';
import 'package:app/widget/form/dropdown_menu_app_form_widget.dart';
import 'package:app/widget/form/elevated_button_form_widget.dart';
import 'package:app/widget/form/file_form_field_widget.dart';
import 'package:app/widget/form/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoachForm extends StatefulWidget {
  final Participant participant;
  final Coach? coach;
  const CoachForm({super.key, required this.participant, this.coach});

  @override
  State<CoachForm> createState() => _CoachFormState();
}

class _CoachFormState extends State<CoachForm> {
  late final TextEditingController _nomController;
  late final TextEditingController _roleController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.coach?.nomCoach);
    _roleController = TextEditingController(text: widget.coach?.role);
    _imageUrlController = TextEditingController(text: widget.coach?.imageUrl);
  }

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void _onSubmit() async {
    if (_nomController.text.isEmpty || _roleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez remplir tous les champs'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final Coach coach = Coach(
      idParticipant: widget.participant.idParticipant,
      idCoach: widget.coach?.idCoach ?? 'C' + DateController.dateCollapsed,
      nomCoach: _nomController.text,
      role: _roleController.text,
      imageUrl: _imageUrlController.text,
    );
    setIsloading(true);
    bool result = false;
    if (widget.coach != null) {
      result = await context.read<CoachProvider>().editCoach(
            widget.coach!.idCoach,
            coach,
          );
    } else {
      result = await context.read<CoachProvider>().addCoach(coach);
    }
    setIsloading(false);
    if (result) {
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erreur lors de l\'enregistrement'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formulaire de Coach'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              SizedBox(height: 5.0),
              TextFormFieldWidget(
                controller: _nomController,
                hintText: 'Entrez le nom du coach',
              ),
              DropDownMenuAppFormWidget(
                  entries: {'coach': 'coach'},
                  title: 'Role',
                  controller: _roleController),
              FileFormFieldWidget(
                directory: 'coach',
                controller: _imageUrlController,
                hintText: 'Entrez l\'url de l\'image du coach',
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

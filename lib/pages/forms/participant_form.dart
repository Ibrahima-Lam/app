import 'package:app/models/participant.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/form/elevated_button_form_widget.dart';
import 'package:app/widget/form/slider_rating_form_widget.dart';
import 'package:app/widget/form/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParticipantForm extends StatefulWidget {
  final String codeEdition;
  final Participant? participant;
  const ParticipantForm(
      {super.key, required this.codeEdition, this.participant});

  @override
  State<ParticipantForm> createState() => _ParticipantFormState();
}

class _ParticipantFormState extends State<ParticipantForm> {
  late final TextEditingController nomController;
  late final TextEditingController libelleController;
  late final TextEditingController localiteController;
  late final TextEditingController urlController;
  late final TextEditingController ratingController;

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void _onSubmit() async {
    final Participant participant = Participant(
        idParticipant: widget.codeEdition +
            DateTime.now()
                .toString()
                .replaceAll(' ', '')
                .replaceAll(':', '')
                .replaceAll('-', '')
                .substring(0, 14),
        idEquipe: widget.codeEdition +
            DateTime.now()
                .toString()
                .replaceAll(' ', '')
                .replaceAll(':', '')
                .replaceAll('-', '')
                .substring(0, 14),
        nomEquipe: nomController.text,
        codeEdition: widget.codeEdition,
        imageUrl: urlController.text,
        libelleEquipe: libelleController.text,
        localiteEquipe: localiteController.text,
        rating: double.parse(ratingController.text));
    print(participant.idParticipant);
    setIsloading(true);
    final bool res = widget.participant != null
        ? await context
            .read<ParticipantProvider>()
            .editParticipant(widget.participant!.idParticipant, participant)
        : await context.read<ParticipantProvider>().addParticipant(participant);
    setIsloading(false);
    if (res) Navigator.pop(context);
  }

  @override
  void initState() {
    nomController = TextEditingController(text: widget.participant?.nomEquipe);
    libelleController =
        TextEditingController(text: widget.participant?.libelleEquipe);
    localiteController =
        TextEditingController(text: widget.participant?.localiteEquipe);
    urlController = TextEditingController(text: widget.participant?.imageUrl);
    ratingController = TextEditingController(
        text: (widget.participant?.rating ?? 0).toString());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Formulaire d\'équipe'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 5.0),
            TextFormFieldWidget(
                controller: nomController,
                hintText: 'Entrer le nom de l\'équipe'),
            const SizedBox(height: 5.0),
            TextFormFieldWidget(
                controller: libelleController,
                hintText: 'Entrer la libellé de l\'équipe'),
            const SizedBox(height: 5.0),
            TextFormFieldWidget(
                controller: localiteController,
                hintText: 'Entrer la localité de  l\'équipe'),
            const SizedBox(height: 5.0),
            TextFormFieldWidget(
                keyboardType: TextInputType.url,
                controller: urlController,
                hintText: 'Entrer l\'url du logo'),
            const SizedBox(height: 5.0),
            SliderRatingFormWidget(controller: ratingController),
            const SizedBox(height: 5.0),
            ElevatedButtonFormWidget(
              onPressed: _onSubmit,
              isSending: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

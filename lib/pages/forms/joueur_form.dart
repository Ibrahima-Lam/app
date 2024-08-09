import 'package:app/controllers/competition/date.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/participant.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/form/elevated_button_form_widget.dart';
import 'package:app/widget/form/file_form_field_widget.dart';
import 'package:app/widget/form/slider_rating_form_widget.dart';
import 'package:app/widget/form/text_form_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoueurForm extends StatefulWidget {
  final Participant participant;
  final Joueur? joueur;
  const JoueurForm({super.key, required this.participant, this.joueur});

  @override
  State<JoueurForm> createState() => _JoueurFormState();
}

class _JoueurFormState extends State<JoueurForm> {
  late final TextEditingController _nomController;
  late final TextEditingController _localiteController;
  late final TextEditingController _dateNaissanceController;
  late final TextEditingController _imageUrlController;
  late final TextEditingController _poidsController;
  late final TextEditingController _tailleController;
  late final TextEditingController _vitesseController;
  late final TextEditingController _pseudoController;
  late final TextEditingController _ratingController;
  late final TextEditingController _numeroController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.joueur?.nomJoueur);
    _localiteController =
        TextEditingController(text: widget.joueur?.localiteJoueur);
    _dateNaissanceController =
        TextEditingController(text: widget.joueur?.dateNaissance);
    _imageUrlController = TextEditingController(text: widget.joueur?.imageUrl);
    _poidsController =
        TextEditingController(text: (widget.joueur?.poids ?? 0).toString());
    _tailleController =
        TextEditingController(text: (widget.joueur?.taille ?? 0).toString());
    _vitesseController =
        TextEditingController(text: (widget.joueur?.vitesse ?? 0).toString());
    _pseudoController = TextEditingController(text: widget.joueur?.pseudo);
    _ratingController =
        TextEditingController(text: (widget.joueur?.rating ?? 0).toString());
    _numeroController =
        TextEditingController(text: (widget.joueur?.numero ?? 0).toString());
  }

  bool isLoading = false;
  void setIsloading(bool val) {
    setState(() {
      isLoading = val;
    });
  }

  void _onSubmit() async {
    if (_nomController.text.isEmpty || _localiteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Veuillez remplir tous les champs'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    final Joueur joueur = Joueur(
      idParticipant: widget.participant.idParticipant,
      participant: widget.participant,
      idJoueur: widget.joueur != null
          ? widget.joueur!.idJoueur
          : 'J' + DateController.dateCollapsed,
      nomJoueur: _nomController.text,
      localiteJoueur: _localiteController.text,
      dateNaissance: _dateNaissanceController.text,
      imageUrl: _imageUrlController.text,
      poids: double.parse(_poidsController.text),
      taille: double.parse(_tailleController.text),
      vitesse: double.parse(_vitesseController.text),
      pseudo: _pseudoController.text,
      rating: double.parse(_ratingController.text),
      numero: int.parse(_numeroController.text),
    );
    setIsloading(true);
    bool result = false;
    if (widget.joueur != null) {
      result = await context.read<JoueurProvider>().editJoueur(
            widget.joueur!.idJoueur,
            joueur,
          );
    } else {
      result = await context.read<JoueurProvider>().addJoueur(joueur);
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
        title: Text('Formulaire de Joueur'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              SizedBox(height: 5.0),
              TextFormFieldWidget(
                controller: _nomController,
                hintText: 'Entrez le nom du joueur',
              ),
              TextFormFieldWidget(
                controller: _pseudoController,
                hintText: 'Entrez le pseudo du joueur',
              ),
              TextFormFieldWidget(
                controller: _localiteController,
                hintText: 'Entrez la localité du joueur',
              ),
              Card(
                child: ListTile(
                  title: Text('Date de naissance'),
                  subtitle: Text(_dateNaissanceController.text),
                  trailing: IconButton(
                    onPressed: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime.now())
                          .then((value) {
                        if (value != null) {
                          setState(() {
                            _dateNaissanceController.text =
                                value.toString().substring(0, 10);
                          });
                        }
                      });
                    },
                    icon: Icon(Icons.edit),
                  ),
                ),
              ),
              FileFormFieldWidget(
                directory: 'joueur',
                controller: _imageUrlController,
                hintText: 'Entrez l\'url de l\'image du joueur',
              ),
              TextFormFieldWidget(
                controller: _poidsController,
                hintText: 'Entrez le poids du joueur en kg',
              ),
              TextFormFieldWidget(
                controller: _tailleController,
                hintText: 'Entrez la taille du joueur en m',
              ),
              TextFormFieldWidget(
                controller: _vitesseController,
                hintText: 'Entrez la vitesse du joueur en km/h',
              ),
              TextFormFieldWidget(
                controller: _numeroController,
                hintText: 'Entrez le numero du joueur',
              ),
              SliderRatingFormWidget(controller: _ratingController),
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

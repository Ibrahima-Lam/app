import 'package:fscore/controllers/competition/date.dart';
import 'package:fscore/models/arbitres/arbitre.dart';
import 'package:fscore/providers/arbitre_provider.dart';
import 'package:fscore/widget/form/dropdown_menu_app_form_widget.dart';
import 'package:fscore/widget/form/elevated_button_form_widget.dart';
import 'package:fscore/widget/form/file_form_field_widget.dart';
import 'package:fscore/widget/form/text_form_field_widget.dart';
import 'package:fscore/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ArbitreForm extends StatefulWidget {
  final String idEdition;
  final Arbitre? arbitre;
  const ArbitreForm({super.key, required this.idEdition, this.arbitre});

  @override
  State<ArbitreForm> createState() => _ArbitreFormState();
}

class _ArbitreFormState extends State<ArbitreForm> {
  late final TextEditingController _nomController;
  late final TextEditingController _roleController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.arbitre?.nomArbitre);
    _roleController = TextEditingController(text: widget.arbitre?.role);
    _imageUrlController = TextEditingController(text: widget.arbitre?.imageUrl);
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

    final Arbitre coach = Arbitre(
      idEdition: widget.idEdition,
      idArbitre:
          widget.arbitre?.idArbitre ?? 'A' + DateController.dateCollapsed,
      nomArbitre: _nomController.text,
      role: _roleController.text,
      imageUrl: _imageUrlController.text,
    );
    setIsloading(true);
    bool result = false;
    if (widget.arbitre != null) {
      result = await context.read<ArbitreProvider>().editArbitre(
            widget.arbitre!.idArbitre,
            coach,
          );
    } else {
      result = await context.read<ArbitreProvider>().addArbitre(coach);
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
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Formulaire de Arbitre'),
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
                DropDownMenuAppFormWidget(entries: {
                  'principale': 'principale',
                  'assistant': 'assistant',
                  'var': 'var',
                  'arbitre': 'arbitre'
                }, title: 'Role', controller: _roleController),
                FileFormFieldWidget(
                  directory: 'arbitre',
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
      ),
    );
  }
}

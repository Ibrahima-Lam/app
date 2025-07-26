import 'package:fscore/pages/forms/groupe_form.dart';
import 'package:fscore/pages/forms/participant_form.dart';
import 'package:fscore/pages/forms/participation_form.dart';
import 'package:flutter/material.dart';

class CompetitionFormsWidget extends StatelessWidget {
  final String codeEdition;
  const CompetitionFormsWidget({super.key, required this.codeEdition});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 5.0),
          FormButtonWidget(
            label: 'Groupe',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => GroupeForm(codeEdition: codeEdition)));
            },
          ),
          FormButtonWidget(
            label: 'Equipe',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ParticipantForm(codeEdition: codeEdition)));
            },
          ),
          FormButtonWidget(
            label: 'Participation',
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ParticipationForm(codeEdition: codeEdition)));
            },
          ),
        ],
      ),
    );
  }
}

class FormButtonWidget extends StatelessWidget {
  final String label;
  final Function()? onPressed;
  const FormButtonWidget(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: OutlinedButton(
              onPressed: onPressed,
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(
                  Theme.of(context).primaryColor,
                ),
                minimumSize: WidgetStatePropertyAll(Size(200, 40)),
              ),
              child:
                  Text(label, style: Theme.of(context).textTheme.titleMedium)),
        ),
      ),
    );
  }
}

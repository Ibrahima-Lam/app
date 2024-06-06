// ignore_for_file: invalid_use_of_protected_member

import 'package:app/core/extension/string_extension.dart';
import 'package:app/models/statistique.dart';
import 'package:app/providers/statistique_provider.dart';
import 'package:app/widget/elevated_button_widget.dart';
import 'package:app/widget/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatistiqueForm extends StatefulWidget {
  final Statistique statistique;
  const StatistiqueForm({super.key, required this.statistique});

  @override
  State<StatistiqueForm> createState() => _StatistiqueFormState();
}

class _StatistiqueFormState extends State<StatistiqueForm> {
  late final TextEditingController homeController;
  late final TextEditingController awayController;

  @override
  void initState() {
    homeController = TextEditingController(
        text: widget.statistique.homeStatistique.toString());
    awayController = TextEditingController(
        text: widget.statistique.awayStatistique.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.statistique.nomStatistique),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (widget.statistique.codeStatistique.contains('possession'))
              StatFormSliderWidget(
                homeController: homeController,
                awayController: awayController,
              )
            else
              StatFormTextFieldWidget(
                  homeController: homeController,
                  awayController: awayController),
            const SizedBox(height: 10),
            ElevatedButtonWidget(
              onPressed: () {
                widget.statistique.homeStatistique =
                    num.parse(homeController.text);
                widget.statistique.awayStatistique =
                    num.parse(awayController.text);
                // ignore: invalid_use_of_visible_for_testing_member
                context.read<StatistiqueProvider>().notifyListeners();
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class StatFormTextFieldWidget extends StatelessWidget {
  final TextEditingController homeController;
  final TextEditingController awayController;
  const StatFormTextFieldWidget(
      {super.key, required this.homeController, required this.awayController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFieldWidget(
            textEditingController: homeController
              ..text = homeController.text.toInt().toString(),
            hintText: 'Entrer la valeur a gauche '),
        const SizedBox(height: 10),
        TextFieldWidget(
            textEditingController: awayController
              ..text = awayController.text.toInt().toString(),
            hintText: 'Entrer la valeur a droite'),
      ],
    );
  }
}

class StatFormSliderWidget extends StatefulWidget {
  final TextEditingController homeController;
  final TextEditingController awayController;

  const StatFormSliderWidget({
    super.key,
    required this.homeController,
    required this.awayController,
  });

  @override
  State<StatFormSliderWidget> createState() => _StatFormSliderWidgetState();
}

class _StatFormSliderWidgetState extends State<StatFormSliderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(child: Text(widget.homeController.text)),
        const SizedBox(height: 10),
        Slider(
            label: widget.homeController.text,
            value: double.parse(widget.homeController.text) / 100,
            onChanged: (val) {
              setState(() {
                widget.homeController.text = (val * 100).toInt().toString();
                widget.awayController.text =
                    (100 - val * 100).ceil().toInt().toString();
              });
            }),
      ],
    );
  }
}

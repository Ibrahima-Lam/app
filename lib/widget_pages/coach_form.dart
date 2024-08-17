import 'package:app/models/coachs/coach.dart';
import 'package:app/models/composition.dart';
import 'package:app/providers/composition_provider.dart';
import 'package:app/widget/events/composition_events_widget.dart';
import 'package:app/widget/form/dropdown_menu_widget.dart';
import 'package:app/widget/form/elevated_button_widget.dart';
import 'package:app/widget/form/text_field_widget.dart';
import 'package:app/widget/modals/bottom_modal_coach_list_widget.dart';
import 'package:app/widget/skelton/layout_builder_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoachFormWidget extends StatefulWidget {
  final CoachComposition composition;
  const CoachFormWidget({super.key, required this.composition});

  @override
  State<CoachFormWidget> createState() => _CoachFormWidgetState();
}

class _CoachFormWidgetState extends State<CoachFormWidget> {
  late final TextEditingController nomEditingController;

  @override
  void initState() {
    nomEditingController = TextEditingController(text: widget.composition.nom);
    super.initState();
  }

  void _onPressed() async {
    final Coach? arbitre = await showModalBottomSheet(
        context: context,
        builder: (context) => BottomModalSheetCoachListWidget(
            idParticipant: widget.composition.idParticipant));
    if (arbitre is Coach) {
      widget.composition.idCoach = arbitre.idCoach;
      widget.composition.nom = arbitre.nomCoach;
      nomEditingController.text = arbitre.nomCoach;
      widget.composition.imageUrl = arbitre.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilderWidget(
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.composition.nom),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              TextFieldWidget(
                  prefixIcon:
                      IconButton(onPressed: _onPressed, icon: Icon(Icons.list)),
                  textEditingController: nomEditingController,
                  hintText: 'Entrer le nom'),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardWidget(),
                  DropDownMenuWidget(
                      onChanged: (val) {
                        setState(() {
                          widget.composition.jaune = val!;
                        });
                      },
                      tab: [0, 1, 2],
                      value: widget.composition.jaune),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CardWidget(
                    isRed: true,
                  ),
                  DropDownMenuWidget(
                      onChanged: (val) {
                        setState(() {
                          widget.composition.rouge = val!;
                        });
                      },
                      tab: [0, 1],
                      value: widget.composition.rouge),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButtonWidget(
                onPressed: () async {
                  setState(() {
                    widget.composition.nom = nomEditingController.text;
                  });
                  if (await context.read<CompositionProvider>().setComposition(
                      widget.composition.idComposition, widget.composition)) {
                    Navigator.pop(context);
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

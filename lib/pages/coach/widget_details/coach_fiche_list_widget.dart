import 'package:app/core/params/categorie/categorie_params.dart';
import 'package:app/models/coachs/coach.dart';
import 'package:app/widget/coach_logo_widget.dart';
import 'package:app/widget/fiches_widget.dart';
import 'package:flutter/material.dart';

class CoachFicheListWidget extends StatelessWidget {
  final Coach coach;
  const CoachFicheListWidget({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          FicheInfosWidget(
              categorieParams: CategorieParams(idCoach: coach.idCoach)),
          InformationCoachWidget(coach: coach),
          FicheSponsorWidget(
              categorieParams: CategorieParams(idCoach: coach.idCoach)),
        ],
      ),
    );
  }
}

class InformationCoachWidget extends StatelessWidget {
  final Coach coach;
  const InformationCoachWidget({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Card(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
          height: 300,
          width: MediaQuery.sizeOf(context).width,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    child: CoachImageLogoWidget(url: coach.imageUrl),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          child: Text(
                            coach.nomCoach,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            coach.role,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  //Todo
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(child: Text('Ajouter au favori')),
                      PopupMenuItem(child: Text('Voir plus')),
                      PopupMenuItem(child: Text('Contacter')),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 5.0,
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    gradient: LinearGradient(colors: [
                      Colors.lightGreenAccent,
                      Colors.white,
                      Colors.yellowAccent
                    ]),
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(
                          '',
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

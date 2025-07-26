import 'package:fscore/models/coachs/coach.dart';
import 'package:fscore/providers/coach_provider.dart';
import 'package:fscore/widget/coach/coach_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomModalSheetCoachListWidget extends StatelessWidget {
  final String idParticipant;
  const BottomModalSheetCoachListWidget(
      {super.key, required this.idParticipant});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CoachProvider>().getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur de chargement!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Consumer<CoachProvider>(
              builder: (context, coachProvider, child) {
            List<Coach> coaches = [
              coachProvider.getCoachByEquipe(idParticipant)!
            ];
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.8,
              builder: (context, scrollController) {
                return coaches.isEmpty
                    ? Center(
                        child: Text('Pas de coach disponible cette équipe !'),
                      )
                    : Container(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: coaches.length,
                          itemBuilder: (context, index) {
                            Coach coach = coaches[index];
                            return CoachListTileWidget(
                              coach: coach,
                              onTap: (c) => Navigator.pop(context, coach),
                            );
                          },
                        ),
                      );
              },
            );
          });
        });
  }
}

import 'package:app/models/coachs/coach.dart';
import 'package:app/providers/coach_provider.dart';
import 'package:app/providers/participant_provider.dart';
import 'package:app/widget/coach_list_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompetitionCoachListWidget extends StatelessWidget {
  final String idEdition;
  const CompetitionCoachListWidget({super.key, required this.idEdition});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          context.read<CoachProvider>().getData(),
          context.read<ParticipantProvider>().getParticipants()
        ]),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('erreur!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return Consumer2<CoachProvider, ParticipantProvider>(
              builder: (context, coac, part, child) {
            List<String> participants = part.participants
                .where((element) => element.idEdition == idEdition)
                .map((e) => e.idParticipant)
                .toList();
            List<Coach> coaches = coac.coachs
                .where(
                    (element) => participants.contains(element.idParticipant))
                .toList();

            return coaches.isEmpty
                ? SizedBox(
                    height: MediaQuery.sizeOf(context).height * .75,
                    child: const Center(
                      child: Text(
                          'Pas d\'entraineur disponible pour cette competition !'),
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: coaches
                          .map((e) => Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 4),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4.0)),
                              shadowColor: Colors.grey,
                              child: CoachListTileWidget(coach: e)))
                          .toList(),
                    ),
                  );
          });
        });
  }
}

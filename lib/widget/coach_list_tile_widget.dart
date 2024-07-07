import 'package:app/models/coachs/coach.dart';
import 'package:app/pages/coach/coach_details.dart';
import 'package:app/widget/coach_logo_widget.dart';
import 'package:flutter/material.dart';

class CoachListTileWidget extends StatelessWidget {
  final Coach coach;

  const CoachListTileWidget({super.key, required this.coach});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => CoachDetails(id: coach.idCoach)));
      },
      leading: Container(
        height: 50,
        width: 50,
        child: CoachImageLogoWidget(url: coach.imageUrl),
      ),
      title: Text(coach.nomCoach),
      subtitle: Text(coach.role),
    );
  }
}

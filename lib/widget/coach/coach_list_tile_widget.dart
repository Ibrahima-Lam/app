import 'package:app/models/coachs/coach.dart';
import 'package:app/pages/coach/coach_details.dart';
import 'package:app/widget/logos/coach_logo_widget.dart';
import 'package:flutter/material.dart';

class CoachListTileWidget extends StatelessWidget {
  final Coach coach;
  final Function(Coach coach)? onTap;
  const CoachListTileWidget({super.key, required this.coach, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (onTap != null) {
          onTap!(coach);
          return;
        }

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
      trailing: Icon(
        Icons.person_2_rounded,
        color: Colors.blueAccent,
      ),
    );
  }
}

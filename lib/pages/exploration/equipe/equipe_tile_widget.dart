import 'package:app/models/participant.dart';
import 'package:app/pages/equipe/equipe_details.dart';
import 'package:app/pages/exploration/rating_widget.dart';
import 'package:app/widget/logos/equipe_logo_widget.dart';
import 'package:flutter/material.dart';

abstract class EquipeSupTileWidget extends StatelessWidget {
  final Participant participant;
  const EquipeSupTileWidget({super.key, required this.participant});

  void onTap(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => EquipeDetails(id: participant.idParticipant)));
  }

  void onExplored(BuildContext context) {}
  void onBacked(BuildContext context) {}
}

class EquipeHorizontalTileWidget extends EquipeSupTileWidget {
  final bool back;
  final Function()? onBack;
  final Function(Participant participant)? onExplore;
  const EquipeHorizontalTileWidget(
      {super.key,
      required super.participant,
      this.back = false,
      this.onBack,
      this.onExplore});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(context),
      leading: SizedBox(
        width: 50,
        height: 50,
        child: EquipeImageLogoWidget(url: participant.imageUrl),
      ),
      title: Text(
        participant.nomEquipe,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: const TextStyle(),
      ),
      subtitle: RatingWidget(rating: participant.rating, centered: false),
      trailing: back
          ? IconButton(
              onPressed: onBack != null ? () => onBack!() : null,
              icon: Icon(
                Icons.clear,
                color: Colors.red,
              ))
          : IconButton(
              onPressed:
                  onExplore != null ? () => onExplore!(participant) : null,
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.green,
              )),
    );
  }
}

class EquipeVerticalTileWidget extends EquipeSupTileWidget {
  final Function(Participant participant)? onExplore;
  const EquipeVerticalTileWidget(
      {super.key, required super.participant, this.onExplore});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        GestureDetector(
          onTap: () => onTap(context),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            width: 130,
            height: 130,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 50,
                  width: 50,
                  child: EquipeImageLogoWidget(url: participant.imageUrl),
                ),
                Text(
                  participant.nomEquipe,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                  ),
                ),
                RatingWidget(rating: participant.rating),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: onExplore != null ? () => onExplore!(participant) : null,
          icon: Icon(Icons.exit_to_app, size: 20),
          color: Colors.green,
        )
      ],
    );
  }
}

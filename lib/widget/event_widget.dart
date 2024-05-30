import 'package:app/models/Event.dart';
import 'package:app/models/game.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:flutter/material.dart';

class EventWidget extends StatelessWidget {
  final Event event;
  final Game game;
  const EventWidget({super.key, required this.event, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey, width: 0.5))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Container(
            child: game.idHome != event.idParticipant
                ? null
                : EventSubWidget(
                    event: event,
                    isHome: true,
                  ),
          )),
          Center(
            child: Container(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                '${event.minute ?? 42}\'',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.italic),
              ),
              width: 40,
            ),
          ),
          Expanded(
              child: Container(
            child: game.idAway != event.idParticipant
                ? null
                : EventSubWidget(
                    event: event,
                    isHome: false,
                  ),
          )),
        ],
      ),
    );
  }
}

class EventSubWidget extends StatelessWidget {
  final Event event;
  final bool isHome;
  const EventSubWidget({super.key, required this.event, required this.isHome});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        if (isHome)
          Container(
            padding: const EdgeInsets.all(5.0),
            child: PersonWidget(radius: 15),
          ),
        if (!isHome) IconsTypeWidget(event: event),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                isHome ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  event.nom,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(
                height: 5.0,
              ),
              if (event.nomTarget != null)
                Container(
                  child: Text(
                    event.nomTarget ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (isHome) IconsTypeWidget(event: event),
        if (!isHome)
          Container(
            padding: const EdgeInsets.all(5.0),
            child: PersonWidget(radius: 15),
          )
      ],
    );
  }
}

class IconsTypeWidget extends StatelessWidget {
  final Event event;
  const IconsTypeWidget({super.key, required this.event});

  Widget? get titleIcon => event.type == 'but'
      ? Icon(Icons.sports_soccer)
      : event.type == 'carton'
          ? (CardWidget(
              isRed: (event as CardEvent).isRed,
            ))
          : event.type == 'changement'
              ? Icon(Icons.swap_vert)
              : null;

  IconData? get subTitleIcon {
    // swap icon pour changement
    if (event is GoalEvent) {
      return (event as GoalEvent).nomTarget != null
          ? Icons.arrow_circle_right_outlined
          : null;
    }
    if (event is CardEvent) {
      return (event as CardEvent).nomTarget == 'faute'
          ? Icons.play_arrow_outlined
          : null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            child: titleIcon,
          ),
          if (subTitleIcon != null)
            Icon(
              subTitleIcon,
              size: 15,
              color: Colors.grey,
            ),
        ],
      ),
    );
  }
}

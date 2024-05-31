import 'package:app/models/event.dart';
import 'package:app/models/game.dart';
import 'package:app/pages/joueur/joueur_details.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/composition_events_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventWidget extends StatelessWidget {
  final Event event;
  final Game game;
  final Function(Event)? onDoubleTap;
  const EventWidget(
      {super.key, required this.event, required this.game, this.onDoubleTap});

  void _onTap(BuildContext context) async {
    String? id = event.idJoueur;
    final String? idT = event.idTarget;
    final bool check = await context.read<JoueurProvider>().checkId(id);
    final bool check2 = await context.read<JoueurProvider>().checkId(idT ?? '');
    if (check && check2) {
      id = await showModalBottomSheet(
          context: context,
          builder: (context) => JoueurBottomSheetWidget(event: event));
    } else if (check) {
      id = event.idJoueur;
    } else if (check2) {
      id = event.idTarget;
    }
    if (!check || !check2) return;
    if (id != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => JoueurDetails(idJoueur: id!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onTap(context),
      onDoubleTap: onDoubleTap == null
          ? null
          : () {
              onDoubleTap!(event);
            },
      child: Container(
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
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    overflow: TextOverflow.ellipsis,
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
                      overflow: TextOverflow.ellipsis,
                      fontSize: 11,
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

class JoueurBottomSheetWidget extends StatelessWidget {
  final Event event;
  const JoueurBottomSheetWidget({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
        children: [
          ListTile(
            leading: PersonWidget(),
            title: Text(event.nom),
            onTap: () {
              Navigator.pop(context, event.idJoueur);
            },
          ),
          ListTile(
              leading: PersonWidget(),
              title: Text(event.nomTarget ?? ''),
              onTap: () {
                Navigator.pop(context, event.idTarget);
              }),
        ],
      ),
    );
  }
}

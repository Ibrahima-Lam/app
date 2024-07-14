import 'package:app/core/enums/enums.dart';
import 'package:app/core/extension/int_extension.dart';
import 'package:app/models/game.dart';
import 'package:app/models/gameEvent.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:app/widget/modals/game_etat_form_modal_widget.dart';
import 'package:app/widget/modals/score_form_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBottomNavbarEditWidget extends StatelessWidget {
  final Game game;
  const GameBottomNavbarEditWidget({super.key, required this.game});
  void _changeDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
        currentDate:
            game.dateGame == null ? null : DateTime.parse(game.dateGame!),
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (date != null) {
      String dt = date.toString().substring(0, 10);
      final bool? confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              defaut: ConfirmDialogDefault.non,
              title: 'Changer la date',
              content: 'Voulez vous changer la date ?'));
      if (confirm == true)
        context.read<GameProvider>().changeDate(id: game.idGame, date: dt);
    } else {
      final bool? confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              defaut: ConfirmDialogDefault.non,
              title: 'Annuler la date',
              content: 'Voulez vous annuler la date ?'));
      if (confirm == true)
        context.read<GameProvider>().changeDate(id: game.idGame, date: null);
    }
  }

  void _changeHeure(BuildContext context) async {
    TimeOfDay? heure =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (heure != null) {
      String dt =
          '${heure.hour.toStringMinLengh(2)}:${heure.minute.toStringMinLengh(2)}';

      final bool? confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              defaut: ConfirmDialogDefault.non,
              title: 'Changer la heure',
              content: 'Voulez vous changer la heure ?'));
      if (confirm == true)
        context.read<GameProvider>().changeHeure(id: game.idGame, heure: dt);
    } else {
      final bool? confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              defaut: ConfirmDialogDefault.non,
              title: 'Annuler la date',
              content: 'Voulez vous annuler la date ?'));
      if (confirm == true)
        context.read<GameProvider>().changeHeure(id: game.idGame, heure: null);
    }
  }

  void _changeChrono(BuildContext context) async {
    var res = await showModalBottomSheet(
        context: context,
        builder: (context) => GameTimerFormModalWidget(
              timer: game.score?.timer,
            ));
    if (res is TimerEvent) {
      context.read<GameProvider>().changeTimer(idGame: game.idGame, timer: res);
    } else if (res == false) {
      context
          .read<GameProvider>()
          .changeTimer(idGame: game.idGame, timer: null);
    }
  }

  void _changeEtat(BuildContext context) async {
    var res = await showModalBottomSheet(
      context: context,
      builder: (context) => GameEtatFormModalWidget(etat: game.etat.text),
    );
    if (res is String) {
      context.read<GameProvider>().changeEtat(id: game.idGame, etat: res);
    }
  }

  void _changeScore(BuildContext context) async {
    (int, int)? values = await showModalBottomSheet(
        context: context,
        builder: (context) => ScoreFormModalWidget(
            homeScore: game.score?.homeScore,
            awayScore: game.score?.awayScore));
    if (values != null) {
      bool confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              defaut: ConfirmDialogDefault.non,
              title: 'Changer le score',
              content: 'Voulez vous changer le score ?'));
      if (confirm)
        context
            .read<GameProvider>()
            .changeScore(idGame: game.idGame, hs: values.$1, as: values.$2);
    } else if (game.score?.homeScore != null && game.score?.awayScore != null) {
      bool confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              defaut: ConfirmDialogDefault.non,
              title: 'Annulation de Score',
              content: 'Voulez vous annulez le score ?'));
      if (confirm) {
        context
            .read<GameProvider>()
            .changeScore(idGame: game.idGame, hs: null, as: null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor,
      onTap: (value) {
        if (value == 0) {
          _changeDate(context);
        } else if (value == 1) {
          _changeHeure(context);
        } else if (value == 2) {
          _changeEtat(context);
        } else if (value == 3) {
          _changeChrono(context);
        } else if (value == 4) {
          _changeScore(context);
        }
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'Date'),
        BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded), label: 'Heure'),
        BottomNavigationBarItem(
            icon: Icon(game.isPlaying ? Icons.pause : Icons.play_arrow),
            label: 'Etat'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Chrono'),
        BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer), label: 'Score'),
      ],
    );
  }
}

import 'package:app/core/extension/int_extension.dart';
import 'package:app/providers/game_provider.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GameBottomNavbarEditWidget extends StatelessWidget {
  final String idGame;
  final String? heureGame;
  final String? dateGame;
  const GameBottomNavbarEditWidget(
      {super.key, required this.idGame, this.dateGame, this.heureGame});
  void _changeDate(BuildContext context) async {
    DateTime? date = await showDatePicker(
        currentDate: dateGame == null ? null : DateTime.parse(dateGame!),
        context: context,
        firstDate: DateTime(2020),
        lastDate: DateTime(2030));
    if (date != null) {
      String dt = date.toString().substring(0, 10);
      bool confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              title: 'Changer la date',
              content: 'Voulez vous changer la date ?'));
      if (confirm)
        context.read<GameProvider>().changeDate(id: idGame, date: dt);
    } else {
      bool confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              title: 'Annuler la date',
              content: 'Voulez vous annuler la date ?'));
      if (confirm)
        context.read<GameProvider>().changeDate(id: idGame, date: null);
    }
  }

  void _changeHeure(BuildContext context) async {
    TimeOfDay? heure =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (heure != null) {
      String dt =
          '${heure.hour.toStringMinLengh(2)}:${heure.minute.toStringMinLengh(2)}';

      bool confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              title: 'Changer la heure',
              content: 'Voulez vous changer la heure ?'));
      if (confirm)
        context.read<GameProvider>().changeHeure(id: idGame, heure: dt);
    } else {
      bool confirm = await showDialog(
          context: context,
          builder: (context) => ConfirmDialogWidget(
              title: 'Annuler la date',
              content: 'Voulez vous annuler la date ?'));
      if (confirm)
        context.read<GameProvider>().changeHeure(id: idGame, heure: null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Theme.of(context).primaryColor,
      onTap: (value) {
        if (value == 0) {
          _changeDate(context);
        } else if (value == 1) {
          _changeHeure(context);
        }
      },
      items: [
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month), label: 'Date'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Heure'),
        BottomNavigationBarItem(icon: Icon(Icons.play_arrow), label: 'Etat'),
      ],
    );
  }
}

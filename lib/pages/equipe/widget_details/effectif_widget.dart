import 'package:app/models/coachs/coach.dart';
import 'package:app/models/joueur.dart';
import 'package:app/models/participant.dart';
import 'package:app/pages/forms/coach_form.dart';
import 'package:app/pages/forms/joueur_form.dart';
import 'package:app/providers/coach_provider.dart';
import 'package:app/providers/joueur_provider.dart';
import 'package:app/widget/coach/coach_list_tile_widget.dart';
import 'package:app/widget/joueur/joueur_widget.dart';
import 'package:app/widget/app/section_title_widget.dart';
import 'package:app/widget/modals/confirm_dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class EffectifWidget extends StatelessWidget {
  final Participant participant;
  final bool checkUser;
  const EffectifWidget(
      {super.key, required this.participant, required this.checkUser});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          EffectifCoachSectionWidget(
            participant: participant,
            checkUser: checkUser,
          ),
          EffectifJoueurSectionWidget(
            participant: participant,
            checkUser: checkUser,
          ),
        ],
      ),
    );
  }
}

class EffectifCoachSectionWidget extends StatefulWidget {
  final Participant participant;
  final bool checkUser;

  const EffectifCoachSectionWidget({
    super.key,
    required this.participant,
    required this.checkUser,
  });

  @override
  State<EffectifCoachSectionWidget> createState() =>
      _EffectifCoachSectionWidgetState();
}

class _EffectifCoachSectionWidgetState
    extends State<EffectifCoachSectionWidget> {
  _onDelete(Coach coach) async {
    final confirm = await showDialog<bool>(
        context: context,
        builder: (context) => ConfirmDialogWidget(
            title: 'Supprimer entraineur',
            content: 'Voulez vous supprimer l\'entraineur?'));
    if (confirm ?? false) {
      context.read<CoachProvider>().deleteCoach(coach.idCoach);
    }
  }

  _onEdit(Coach coach) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CoachForm(
              coach: coach,
              participant: widget.participant,
            )));
  }

  _onAdd(Participant participant) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CoachForm(
              participant: participant,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context.read<CoachProvider>().getData(),
        builder: (context, snapshot) {
          return Consumer<CoachProvider>(
              builder: (context, coachProvider, child) {
            final Coach? coach = coachProvider
                .getCoachByEquipe(widget.participant.idParticipant);

            return coach == null && !widget.checkUser
                ? const SizedBox()
                : Card(
                    child: Column(
                      children: [
                        SectionTitleWidget(title: 'Entraineur'),
                        if (coach != null)
                          CoachSectionListTileWidget(
                            enable: widget.checkUser,
                            coach: coach,
                            onDelete: _onDelete,
                            onEdit: _onEdit,
                          ),
                        if (widget.checkUser)
                          OutlinedButton(
                            onPressed: () => _onAdd(widget.participant),
                            child: const Text('Ajouter un entraineur'),
                          ),
                      ],
                    ),
                  );
          });
        });
  }
}

class CoachSectionListTileWidget extends StatelessWidget {
  final Coach coach;
  final Function(Coach) onDelete;
  final Function(Coach) onEdit;
  final bool enable;
  const CoachSectionListTileWidget(
      {super.key,
      required this.coach,
      required this.onDelete,
      required this.onEdit,
      this.enable = false});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enable,
      startActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
              foregroundColor: Colors.red,
              onPressed: (context) => onDelete(coach),
              icon: Icons.delete),
        ],
      ),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.2,
        children: [
          SlidableAction(
              onPressed: (context) => onEdit(coach), icon: Icons.edit),
        ],
      ),
      child: CoachListTileWidget(coach: coach),
    );
  }
}

class EffectifJoueurSectionWidget extends StatefulWidget {
  final Participant participant;
  final bool checkUser;

  const EffectifJoueurSectionWidget({
    super.key,
    required this.participant,
    required this.checkUser,
  });

  @override
  State<EffectifJoueurSectionWidget> createState() =>
      _EffectifJoueurSectionWidgetState();
}

class _EffectifJoueurSectionWidgetState
    extends State<EffectifJoueurSectionWidget> {
  _onDelete(Joueur joueur) async {
    final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => ConfirmDialogWidget(
            title: 'Supprimer joueur',
            content: 'Voulez vous supprimer le joueur?'));
    if (confirm ?? false) {
      context.read<JoueurProvider>().deleteJoueur(joueur.idJoueur);
    }
  }

  _onEdit(Joueur joueur) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => JoueurForm(
              joueur: joueur,
              participant: widget.participant,
            )));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: context
            .read<JoueurProvider>()
            .getJoueursBy(idParticipant: widget.participant.idParticipant),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Erreur de chargement!'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: MediaQuery.sizeOf(context).height * .75,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return Consumer<JoueurProvider>(
              builder: (context, joueurProvider, child) {
            List<Joueur> joueurs = joueurProvider.joueurs
                .where((element) =>
                    element.idParticipant == widget.participant.idParticipant)
                .toList();

            return joueurs.isEmpty && !widget.checkUser
                ? Container(
                    height: MediaQuery.sizeOf(context).height * .75,
                    child: const Center(
                      child:
                          Text('Pas de joueur disponible pour cette equipe!'),
                    ),
                  )
                : Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3)),
                    child: Column(
                      children: [
                        SectionTitleWidget(title: "Joueurs"),
                        ...joueurs
                            .map((e) => JoueurSectionListTileWidget(
                                  enable: widget.checkUser,
                                  joueur: e,
                                  onDelete: _onDelete,
                                  onEdit: _onEdit,
                                ))
                            .toList(),
                        if (widget.checkUser)
                          OutlinedButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => JoueurForm(
                                        participant: widget.participant))),
                            child: const Text('Ajouter un joueur'),
                          ),
                      ],
                    ),
                  );
          });
        });
  }
}

class JoueurSectionListTileWidget extends StatelessWidget {
  final Function(Joueur) onDelete;
  final Function(Joueur) onEdit;
  final bool enable;

  final Joueur joueur;
  const JoueurSectionListTileWidget(
      {super.key,
      required this.joueur,
      required this.onDelete,
      required this.onEdit,
      this.enable = false});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      enabled: enable,
      startActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
              foregroundColor: Colors.red,
              onPressed: (context) => onDelete(joueur),
              icon: Icons.delete),
        ],
      ),
      endActionPane: ActionPane(
        extentRatio: 0.2,
        motion: const DrawerMotion(),
        children: [
          SlidableAction(
              onPressed: (context) => onEdit(joueur), icon: Icons.edit),
        ],
      ),
      child: JoueurListTileWidget(joueur: joueur),
    );
  }
}

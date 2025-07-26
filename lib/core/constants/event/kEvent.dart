import 'package:fscore/models/event.dart';

final kGoalEvent = GoalEvent(
    idJoueur: 'joueur',
    nom: 'Player',
    idParticipant: 'equipe',
    idGame: 'game',
    idEvent: 'event');
final kRedCardEvent = CardEvent(
    isRed: true,
    idJoueur: 'joueur',
    nom: 'Player',
    idParticipant: 'equipe',
    idGame: 'game',
    idEvent: 'event');
final kYellowCardEvent = CardEvent(
    isRed: false,
    idJoueur: 'joueur',
    nom: 'Player',
    idParticipant: 'equipe',
    idGame: 'game',
    idEvent: 'event');
final kRemplEvent = RemplEvent(
    idJoueur: 'joueur',
    nom: 'Player',
    idParticipant: 'equipe',
    idGame: 'game',
    idEvent: 'event');

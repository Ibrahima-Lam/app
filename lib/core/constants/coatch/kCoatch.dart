import 'package:app/models/composition.dart';

final CoachComposition kCoach = CoachComposition(
  idComposition: DateTime.now().millisecondsSinceEpoch.toString(),
  idCoach: 'coach',
  idParticipant: 'equipe',
  nom: 'Coach',
  idGame: 'game',
  jaune: 0,
  rouge: 0,
);

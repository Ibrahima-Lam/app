import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'coach.freezed.dart';
part 'coach.g.dart';

@freezed
class Coach with _$Coach {
  const factory Coach({
    required String idCoach,
    required String nomCoach,
    required String role,
    required String idParticipant,
    String? imageUrl,
  }) = _Coach;
  factory Coach.fromJson(Map<String, Object?> json) => _$CoachFromJson(json);
}

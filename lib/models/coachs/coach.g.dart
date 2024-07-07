// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coach.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CoachImpl _$$CoachImplFromJson(Map<String, dynamic> json) => _$CoachImpl(
      idCoach: json['idCoach'] as String,
      nomCoach: json['nomCoach'] as String,
      role: json['role'] as String,
      idParticipant: json['idParticipant'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$CoachImplToJson(_$CoachImpl instance) =>
    <String, dynamic>{
      'idCoach': instance.idCoach,
      'nomCoach': instance.nomCoach,
      'role': instance.role,
      'idParticipant': instance.idParticipant,
      'imageUrl': instance.imageUrl,
    };

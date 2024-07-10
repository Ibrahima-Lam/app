// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'infos.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InfosImpl _$$InfosImplFromJson(Map<String, dynamic> json) => _$InfosImpl(
      id: json['id'] as String,
      text: json['text'] as String,
      title: json['title'] as String,
      datetime: json['datetime'] as String,
      source: json['source'] as String?,
      imageUrl: json['imageUrl'] as String?,
      idEdition: json['idEdition'] as String?,
      idGame: json['idGame'] as String?,
      idParticipant: json['idParticipant'] as String?,
      idJoueur: json['idJoueur'] as String?,
      idArbitre: json['idArbitre'] as String?,
      idCoach: json['idCoach'] as String?,
    );

Map<String, dynamic> _$$InfosImplToJson(_$InfosImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'title': instance.title,
      'datetime': instance.datetime,
      'source': instance.source,
      'imageUrl': instance.imageUrl,
      'idEdition': instance.idEdition,
      'idGame': instance.idGame,
      'idParticipant': instance.idParticipant,
      'idJoueur': instance.idJoueur,
      'idArbitre': instance.idArbitre,
      'idCoach': instance.idCoach,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'arbitre.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArbitreImpl _$$ArbitreImplFromJson(Map<String, dynamic> json) =>
    _$ArbitreImpl(
      idArbitre: json['idArbitre'] as String,
      nomArbitre: json['nomArbitre'] as String,
      role: json['role'] as String,
      idEdition: json['idEdition'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$$ArbitreImplToJson(_$ArbitreImpl instance) =>
    <String, dynamic>{
      'idArbitre': instance.idArbitre,
      'nomArbitre': instance.nomArbitre,
      'role': instance.role,
      'idEdition': instance.idEdition,
      'imageUrl': instance.imageUrl,
    };

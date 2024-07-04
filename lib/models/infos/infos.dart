import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'infos.freezed.dart';
part 'infos.g.dart';

@freezed
class Infos with _$Infos {
  const factory Infos({
    required String id,
    required String text,
    required String title,
    required String datetime,
    String? source,
    String? imageUrl,
    String? idEdition,
    String? idGame,
    String? idPartcipant,
    String? idJoueur,
  }) = _Infos;
  factory Infos.fromJson(Map<String, Object?> json) => _$InfosFromJson(json);
}

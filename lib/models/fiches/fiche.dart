import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'fiche.freezed.dart';
part 'fiche.g.dart';

@freezed
class Fiche with _$Fiche {
  const factory Fiche({
    required String id,
    required String libelle,
    required String image,
    required String description,
  }) = _Fiche;
  factory Fiche.fromJson(Map<String, Object?> json) => _$FicheFromJson(json);
}

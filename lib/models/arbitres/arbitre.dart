import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'arbitre.freezed.dart';
part 'arbitre.g.dart';

@freezed
class Arbitre with _$Arbitre {
  const factory Arbitre({
    required String idArbitre,
    required String nomArbitre,
    required String role,
    required String idEdition,
    String? imageUrl,
  }) = _Arbitre;
  factory Arbitre.fromJson(Map<String, Object?> json) =>
      _$ArbitreFromJson(json);
}

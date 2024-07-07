// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'arbitre.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Arbitre _$ArbitreFromJson(Map<String, dynamic> json) {
  return _Arbitre.fromJson(json);
}

/// @nodoc
mixin _$Arbitre {
  String get idArbitre => throw _privateConstructorUsedError;
  String get nomArbitre => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get idEdition => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ArbitreCopyWith<Arbitre> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ArbitreCopyWith<$Res> {
  factory $ArbitreCopyWith(Arbitre value, $Res Function(Arbitre) then) =
      _$ArbitreCopyWithImpl<$Res, Arbitre>;
  @useResult
  $Res call(
      {String idArbitre,
      String nomArbitre,
      String role,
      String idEdition,
      String? imageUrl});
}

/// @nodoc
class _$ArbitreCopyWithImpl<$Res, $Val extends Arbitre>
    implements $ArbitreCopyWith<$Res> {
  _$ArbitreCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idArbitre = null,
    Object? nomArbitre = null,
    Object? role = null,
    Object? idEdition = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      idArbitre: null == idArbitre
          ? _value.idArbitre
          : idArbitre // ignore: cast_nullable_to_non_nullable
              as String,
      nomArbitre: null == nomArbitre
          ? _value.nomArbitre
          : nomArbitre // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      idEdition: null == idEdition
          ? _value.idEdition
          : idEdition // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ArbitreImplCopyWith<$Res> implements $ArbitreCopyWith<$Res> {
  factory _$$ArbitreImplCopyWith(
          _$ArbitreImpl value, $Res Function(_$ArbitreImpl) then) =
      __$$ArbitreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String idArbitre,
      String nomArbitre,
      String role,
      String idEdition,
      String? imageUrl});
}

/// @nodoc
class __$$ArbitreImplCopyWithImpl<$Res>
    extends _$ArbitreCopyWithImpl<$Res, _$ArbitreImpl>
    implements _$$ArbitreImplCopyWith<$Res> {
  __$$ArbitreImplCopyWithImpl(
      _$ArbitreImpl _value, $Res Function(_$ArbitreImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idArbitre = null,
    Object? nomArbitre = null,
    Object? role = null,
    Object? idEdition = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$ArbitreImpl(
      idArbitre: null == idArbitre
          ? _value.idArbitre
          : idArbitre // ignore: cast_nullable_to_non_nullable
              as String,
      nomArbitre: null == nomArbitre
          ? _value.nomArbitre
          : nomArbitre // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      idEdition: null == idEdition
          ? _value.idEdition
          : idEdition // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ArbitreImpl with DiagnosticableTreeMixin implements _Arbitre {
  const _$ArbitreImpl(
      {required this.idArbitre,
      required this.nomArbitre,
      required this.role,
      required this.idEdition,
      this.imageUrl});

  factory _$ArbitreImpl.fromJson(Map<String, dynamic> json) =>
      _$$ArbitreImplFromJson(json);

  @override
  final String idArbitre;
  @override
  final String nomArbitre;
  @override
  final String role;
  @override
  final String idEdition;
  @override
  final String? imageUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Arbitre(idArbitre: $idArbitre, nomArbitre: $nomArbitre, role: $role, idEdition: $idEdition, imageUrl: $imageUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Arbitre'))
      ..add(DiagnosticsProperty('idArbitre', idArbitre))
      ..add(DiagnosticsProperty('nomArbitre', nomArbitre))
      ..add(DiagnosticsProperty('role', role))
      ..add(DiagnosticsProperty('idEdition', idEdition))
      ..add(DiagnosticsProperty('imageUrl', imageUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ArbitreImpl &&
            (identical(other.idArbitre, idArbitre) ||
                other.idArbitre == idArbitre) &&
            (identical(other.nomArbitre, nomArbitre) ||
                other.nomArbitre == nomArbitre) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.idEdition, idEdition) ||
                other.idEdition == idEdition) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, idArbitre, nomArbitre, role, idEdition, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ArbitreImplCopyWith<_$ArbitreImpl> get copyWith =>
      __$$ArbitreImplCopyWithImpl<_$ArbitreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ArbitreImplToJson(
      this,
    );
  }
}

abstract class _Arbitre implements Arbitre {
  const factory _Arbitre(
      {required final String idArbitre,
      required final String nomArbitre,
      required final String role,
      required final String idEdition,
      final String? imageUrl}) = _$ArbitreImpl;

  factory _Arbitre.fromJson(Map<String, dynamic> json) = _$ArbitreImpl.fromJson;

  @override
  String get idArbitre;
  @override
  String get nomArbitre;
  @override
  String get role;
  @override
  String get idEdition;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$ArbitreImplCopyWith<_$ArbitreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

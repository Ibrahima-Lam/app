// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'fiche.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Fiche _$FicheFromJson(Map<String, dynamic> json) {
  return _Fiche.fromJson(json);
}

/// @nodoc
mixin _$Fiche {
  String get id => throw _privateConstructorUsedError;
  String get libelle => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FicheCopyWith<Fiche> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FicheCopyWith<$Res> {
  factory $FicheCopyWith(Fiche value, $Res Function(Fiche) then) =
      _$FicheCopyWithImpl<$Res, Fiche>;
  @useResult
  $Res call({String id, String libelle, String image, String description});
}

/// @nodoc
class _$FicheCopyWithImpl<$Res, $Val extends Fiche>
    implements $FicheCopyWith<$Res> {
  _$FicheCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? libelle = null,
    Object? image = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FicheImplCopyWith<$Res> implements $FicheCopyWith<$Res> {
  factory _$$FicheImplCopyWith(
          _$FicheImpl value, $Res Function(_$FicheImpl) then) =
      __$$FicheImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String libelle, String image, String description});
}

/// @nodoc
class __$$FicheImplCopyWithImpl<$Res>
    extends _$FicheCopyWithImpl<$Res, _$FicheImpl>
    implements _$$FicheImplCopyWith<$Res> {
  __$$FicheImplCopyWithImpl(
      _$FicheImpl _value, $Res Function(_$FicheImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? libelle = null,
    Object? image = null,
    Object? description = null,
  }) {
    return _then(_$FicheImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      libelle: null == libelle
          ? _value.libelle
          : libelle // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FicheImpl with DiagnosticableTreeMixin implements _Fiche {
  const _$FicheImpl(
      {required this.id,
      required this.libelle,
      required this.image,
      required this.description});

  factory _$FicheImpl.fromJson(Map<String, dynamic> json) =>
      _$$FicheImplFromJson(json);

  @override
  final String id;
  @override
  final String libelle;
  @override
  final String image;
  @override
  final String description;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Fiche(id: $id, libelle: $libelle, image: $image, description: $description)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Fiche'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('libelle', libelle))
      ..add(DiagnosticsProperty('image', image))
      ..add(DiagnosticsProperty('description', description));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FicheImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.libelle, libelle) || other.libelle == libelle) &&
            (identical(other.image, image) || other.image == image) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, libelle, image, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FicheImplCopyWith<_$FicheImpl> get copyWith =>
      __$$FicheImplCopyWithImpl<_$FicheImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FicheImplToJson(
      this,
    );
  }
}

abstract class _Fiche implements Fiche {
  const factory _Fiche(
      {required final String id,
      required final String libelle,
      required final String image,
      required final String description}) = _$FicheImpl;

  factory _Fiche.fromJson(Map<String, dynamic> json) = _$FicheImpl.fromJson;

  @override
  String get id;
  @override
  String get libelle;
  @override
  String get image;
  @override
  String get description;
  @override
  @JsonKey(ignore: true)
  _$$FicheImplCopyWith<_$FicheImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

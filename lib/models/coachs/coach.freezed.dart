// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'coach.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Coach _$CoachFromJson(Map<String, dynamic> json) {
  return _Coach.fromJson(json);
}

/// @nodoc
mixin _$Coach {
  String get idCoach => throw _privateConstructorUsedError;
  String get nomCoach => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  String get idParticipant => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CoachCopyWith<Coach> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CoachCopyWith<$Res> {
  factory $CoachCopyWith(Coach value, $Res Function(Coach) then) =
      _$CoachCopyWithImpl<$Res, Coach>;
  @useResult
  $Res call(
      {String idCoach,
      String nomCoach,
      String role,
      String idParticipant,
      String? imageUrl});
}

/// @nodoc
class _$CoachCopyWithImpl<$Res, $Val extends Coach>
    implements $CoachCopyWith<$Res> {
  _$CoachCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idCoach = null,
    Object? nomCoach = null,
    Object? role = null,
    Object? idParticipant = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_value.copyWith(
      idCoach: null == idCoach
          ? _value.idCoach
          : idCoach // ignore: cast_nullable_to_non_nullable
              as String,
      nomCoach: null == nomCoach
          ? _value.nomCoach
          : nomCoach // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      idParticipant: null == idParticipant
          ? _value.idParticipant
          : idParticipant // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CoachImplCopyWith<$Res> implements $CoachCopyWith<$Res> {
  factory _$$CoachImplCopyWith(
          _$CoachImpl value, $Res Function(_$CoachImpl) then) =
      __$$CoachImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String idCoach,
      String nomCoach,
      String role,
      String idParticipant,
      String? imageUrl});
}

/// @nodoc
class __$$CoachImplCopyWithImpl<$Res>
    extends _$CoachCopyWithImpl<$Res, _$CoachImpl>
    implements _$$CoachImplCopyWith<$Res> {
  __$$CoachImplCopyWithImpl(
      _$CoachImpl _value, $Res Function(_$CoachImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? idCoach = null,
    Object? nomCoach = null,
    Object? role = null,
    Object? idParticipant = null,
    Object? imageUrl = freezed,
  }) {
    return _then(_$CoachImpl(
      idCoach: null == idCoach
          ? _value.idCoach
          : idCoach // ignore: cast_nullable_to_non_nullable
              as String,
      nomCoach: null == nomCoach
          ? _value.nomCoach
          : nomCoach // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      idParticipant: null == idParticipant
          ? _value.idParticipant
          : idParticipant // ignore: cast_nullable_to_non_nullable
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
class _$CoachImpl with DiagnosticableTreeMixin implements _Coach {
  const _$CoachImpl(
      {required this.idCoach,
      required this.nomCoach,
      required this.role,
      required this.idParticipant,
      this.imageUrl});

  factory _$CoachImpl.fromJson(Map<String, dynamic> json) =>
      _$$CoachImplFromJson(json);

  @override
  final String idCoach;
  @override
  final String nomCoach;
  @override
  final String role;
  @override
  final String idParticipant;
  @override
  final String? imageUrl;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Coach(idCoach: $idCoach, nomCoach: $nomCoach, role: $role, idParticipant: $idParticipant, imageUrl: $imageUrl)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Coach'))
      ..add(DiagnosticsProperty('idCoach', idCoach))
      ..add(DiagnosticsProperty('nomCoach', nomCoach))
      ..add(DiagnosticsProperty('role', role))
      ..add(DiagnosticsProperty('idParticipant', idParticipant))
      ..add(DiagnosticsProperty('imageUrl', imageUrl));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CoachImpl &&
            (identical(other.idCoach, idCoach) || other.idCoach == idCoach) &&
            (identical(other.nomCoach, nomCoach) ||
                other.nomCoach == nomCoach) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.idParticipant, idParticipant) ||
                other.idParticipant == idParticipant) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, idCoach, nomCoach, role, idParticipant, imageUrl);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CoachImplCopyWith<_$CoachImpl> get copyWith =>
      __$$CoachImplCopyWithImpl<_$CoachImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CoachImplToJson(
      this,
    );
  }
}

abstract class _Coach implements Coach {
  const factory _Coach(
      {required final String idCoach,
      required final String nomCoach,
      required final String role,
      required final String idParticipant,
      final String? imageUrl}) = _$CoachImpl;

  factory _Coach.fromJson(Map<String, dynamic> json) = _$CoachImpl.fromJson;

  @override
  String get idCoach;
  @override
  String get nomCoach;
  @override
  String get role;
  @override
  String get idParticipant;
  @override
  String? get imageUrl;
  @override
  @JsonKey(ignore: true)
  _$$CoachImplCopyWith<_$CoachImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

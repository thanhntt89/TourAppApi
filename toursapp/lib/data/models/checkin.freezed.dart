// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'checkin.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Checkin {

 int get id; int get placeId; String get method; DateTime get createdAt; String? get placeName; int get flowersEarned; double? get lat; double? get lng;
/// Create a copy of Checkin
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CheckinCopyWith<Checkin> get copyWith => _$CheckinCopyWithImpl<Checkin>(this as Checkin, _$identity);

  /// Serializes this Checkin to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Checkin&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.method, method) || other.method == method)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.flowersEarned, flowersEarned) || other.flowersEarned == flowersEarned)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,method,createdAt,placeName,flowersEarned,lat,lng);

@override
String toString() {
  return 'Checkin(id: $id, placeId: $placeId, method: $method, createdAt: $createdAt, placeName: $placeName, flowersEarned: $flowersEarned, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class $CheckinCopyWith<$Res>  {
  factory $CheckinCopyWith(Checkin value, $Res Function(Checkin) _then) = _$CheckinCopyWithImpl;
@useResult
$Res call({
 int id, int placeId, String method, DateTime createdAt, String? placeName, int flowersEarned, double? lat, double? lng
});




}
/// @nodoc
class _$CheckinCopyWithImpl<$Res>
    implements $CheckinCopyWith<$Res> {
  _$CheckinCopyWithImpl(this._self, this._then);

  final Checkin _self;
  final $Res Function(Checkin) _then;

/// Create a copy of Checkin
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? placeId = null,Object? method = null,Object? createdAt = null,Object? placeName = freezed,Object? flowersEarned = null,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,flowersEarned: null == flowersEarned ? _self.flowersEarned : flowersEarned // ignore: cast_nullable_to_non_nullable
as int,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Checkin].
extension CheckinPatterns on Checkin {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Checkin value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Checkin() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Checkin value)  $default,){
final _that = this;
switch (_that) {
case _Checkin():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Checkin value)?  $default,){
final _that = this;
switch (_that) {
case _Checkin() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int placeId,  String method,  DateTime createdAt,  String? placeName,  int flowersEarned,  double? lat,  double? lng)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Checkin() when $default != null:
return $default(_that.id,_that.placeId,_that.method,_that.createdAt,_that.placeName,_that.flowersEarned,_that.lat,_that.lng);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int placeId,  String method,  DateTime createdAt,  String? placeName,  int flowersEarned,  double? lat,  double? lng)  $default,) {final _that = this;
switch (_that) {
case _Checkin():
return $default(_that.id,_that.placeId,_that.method,_that.createdAt,_that.placeName,_that.flowersEarned,_that.lat,_that.lng);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int placeId,  String method,  DateTime createdAt,  String? placeName,  int flowersEarned,  double? lat,  double? lng)?  $default,) {final _that = this;
switch (_that) {
case _Checkin() when $default != null:
return $default(_that.id,_that.placeId,_that.method,_that.createdAt,_that.placeName,_that.flowersEarned,_that.lat,_that.lng);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Checkin implements Checkin {
  const _Checkin({required this.id, required this.placeId, required this.method, required this.createdAt, this.placeName, this.flowersEarned = 0, this.lat, this.lng});
  factory _Checkin.fromJson(Map<String, dynamic> json) => _$CheckinFromJson(json);

@override final  int id;
@override final  int placeId;
@override final  String method;
@override final  DateTime createdAt;
@override final  String? placeName;
@override@JsonKey() final  int flowersEarned;
@override final  double? lat;
@override final  double? lng;

/// Create a copy of Checkin
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CheckinCopyWith<_Checkin> get copyWith => __$CheckinCopyWithImpl<_Checkin>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CheckinToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Checkin&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.method, method) || other.method == method)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.flowersEarned, flowersEarned) || other.flowersEarned == flowersEarned)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,method,createdAt,placeName,flowersEarned,lat,lng);

@override
String toString() {
  return 'Checkin(id: $id, placeId: $placeId, method: $method, createdAt: $createdAt, placeName: $placeName, flowersEarned: $flowersEarned, lat: $lat, lng: $lng)';
}


}

/// @nodoc
abstract mixin class _$CheckinCopyWith<$Res> implements $CheckinCopyWith<$Res> {
  factory _$CheckinCopyWith(_Checkin value, $Res Function(_Checkin) _then) = __$CheckinCopyWithImpl;
@override @useResult
$Res call({
 int id, int placeId, String method, DateTime createdAt, String? placeName, int flowersEarned, double? lat, double? lng
});




}
/// @nodoc
class __$CheckinCopyWithImpl<$Res>
    implements _$CheckinCopyWith<$Res> {
  __$CheckinCopyWithImpl(this._self, this._then);

  final _Checkin _self;
  final $Res Function(_Checkin) _then;

/// Create a copy of Checkin
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? placeId = null,Object? method = null,Object? createdAt = null,Object? placeName = freezed,Object? flowersEarned = null,Object? lat = freezed,Object? lng = freezed,}) {
  return _then(_Checkin(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,flowersEarned: null == flowersEarned ? _self.flowersEarned : flowersEarned // ignore: cast_nullable_to_non_nullable
as int,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on

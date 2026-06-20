// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey_stop.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$JourneyStop {

 int get id; int get journeyId; int get placeId; int get orderNum; String? get placeName; String? get placeImageUrl; double? get lat; double? get lng; String? get distanceFromPrev;
/// Create a copy of JourneyStop
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyStopCopyWith<JourneyStop> get copyWith => _$JourneyStopCopyWithImpl<JourneyStop>(this as JourneyStop, _$identity);

  /// Serializes this JourneyStop to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is JourneyStop&&(identical(other.id, id) || other.id == id)&&(identical(other.journeyId, journeyId) || other.journeyId == journeyId)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.orderNum, orderNum) || other.orderNum == orderNum)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeImageUrl, placeImageUrl) || other.placeImageUrl == placeImageUrl)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.distanceFromPrev, distanceFromPrev) || other.distanceFromPrev == distanceFromPrev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,journeyId,placeId,orderNum,placeName,placeImageUrl,lat,lng,distanceFromPrev);

@override
String toString() {
  return 'JourneyStop(id: $id, journeyId: $journeyId, placeId: $placeId, orderNum: $orderNum, placeName: $placeName, placeImageUrl: $placeImageUrl, lat: $lat, lng: $lng, distanceFromPrev: $distanceFromPrev)';
}


}

/// @nodoc
abstract mixin class $JourneyStopCopyWith<$Res>  {
  factory $JourneyStopCopyWith(JourneyStop value, $Res Function(JourneyStop) _then) = _$JourneyStopCopyWithImpl;
@useResult
$Res call({
 int id, int journeyId, int placeId, int orderNum, String? placeName, String? placeImageUrl, double? lat, double? lng, String? distanceFromPrev
});




}
/// @nodoc
class _$JourneyStopCopyWithImpl<$Res>
    implements $JourneyStopCopyWith<$Res> {
  _$JourneyStopCopyWithImpl(this._self, this._then);

  final JourneyStop _self;
  final $Res Function(JourneyStop) _then;

/// Create a copy of JourneyStop
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? journeyId = null,Object? placeId = null,Object? orderNum = null,Object? placeName = freezed,Object? placeImageUrl = freezed,Object? lat = freezed,Object? lng = freezed,Object? distanceFromPrev = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,journeyId: null == journeyId ? _self.journeyId : journeyId // ignore: cast_nullable_to_non_nullable
as int,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int,orderNum: null == orderNum ? _self.orderNum : orderNum // ignore: cast_nullable_to_non_nullable
as int,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,placeImageUrl: freezed == placeImageUrl ? _self.placeImageUrl : placeImageUrl // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,distanceFromPrev: freezed == distanceFromPrev ? _self.distanceFromPrev : distanceFromPrev // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [JourneyStop].
extension JourneyStopPatterns on JourneyStop {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _JourneyStop value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _JourneyStop() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _JourneyStop value)  $default,){
final _that = this;
switch (_that) {
case _JourneyStop():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _JourneyStop value)?  $default,){
final _that = this;
switch (_that) {
case _JourneyStop() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int journeyId,  int placeId,  int orderNum,  String? placeName,  String? placeImageUrl,  double? lat,  double? lng,  String? distanceFromPrev)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _JourneyStop() when $default != null:
return $default(_that.id,_that.journeyId,_that.placeId,_that.orderNum,_that.placeName,_that.placeImageUrl,_that.lat,_that.lng,_that.distanceFromPrev);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int journeyId,  int placeId,  int orderNum,  String? placeName,  String? placeImageUrl,  double? lat,  double? lng,  String? distanceFromPrev)  $default,) {final _that = this;
switch (_that) {
case _JourneyStop():
return $default(_that.id,_that.journeyId,_that.placeId,_that.orderNum,_that.placeName,_that.placeImageUrl,_that.lat,_that.lng,_that.distanceFromPrev);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int journeyId,  int placeId,  int orderNum,  String? placeName,  String? placeImageUrl,  double? lat,  double? lng,  String? distanceFromPrev)?  $default,) {final _that = this;
switch (_that) {
case _JourneyStop() when $default != null:
return $default(_that.id,_that.journeyId,_that.placeId,_that.orderNum,_that.placeName,_that.placeImageUrl,_that.lat,_that.lng,_that.distanceFromPrev);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _JourneyStop implements JourneyStop {
  const _JourneyStop({required this.id, required this.journeyId, required this.placeId, this.orderNum = 0, this.placeName, this.placeImageUrl, this.lat, this.lng, this.distanceFromPrev});
  factory _JourneyStop.fromJson(Map<String, dynamic> json) => _$JourneyStopFromJson(json);

@override final  int id;
@override final  int journeyId;
@override final  int placeId;
@override@JsonKey() final  int orderNum;
@override final  String? placeName;
@override final  String? placeImageUrl;
@override final  double? lat;
@override final  double? lng;
@override final  String? distanceFromPrev;

/// Create a copy of JourneyStop
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyStopCopyWith<_JourneyStop> get copyWith => __$JourneyStopCopyWithImpl<_JourneyStop>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyStopToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _JourneyStop&&(identical(other.id, id) || other.id == id)&&(identical(other.journeyId, journeyId) || other.journeyId == journeyId)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.orderNum, orderNum) || other.orderNum == orderNum)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeImageUrl, placeImageUrl) || other.placeImageUrl == placeImageUrl)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.distanceFromPrev, distanceFromPrev) || other.distanceFromPrev == distanceFromPrev));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,journeyId,placeId,orderNum,placeName,placeImageUrl,lat,lng,distanceFromPrev);

@override
String toString() {
  return 'JourneyStop(id: $id, journeyId: $journeyId, placeId: $placeId, orderNum: $orderNum, placeName: $placeName, placeImageUrl: $placeImageUrl, lat: $lat, lng: $lng, distanceFromPrev: $distanceFromPrev)';
}


}

/// @nodoc
abstract mixin class _$JourneyStopCopyWith<$Res> implements $JourneyStopCopyWith<$Res> {
  factory _$JourneyStopCopyWith(_JourneyStop value, $Res Function(_JourneyStop) _then) = __$JourneyStopCopyWithImpl;
@override @useResult
$Res call({
 int id, int journeyId, int placeId, int orderNum, String? placeName, String? placeImageUrl, double? lat, double? lng, String? distanceFromPrev
});




}
/// @nodoc
class __$JourneyStopCopyWithImpl<$Res>
    implements _$JourneyStopCopyWith<$Res> {
  __$JourneyStopCopyWithImpl(this._self, this._then);

  final _JourneyStop _self;
  final $Res Function(_JourneyStop) _then;

/// Create a copy of JourneyStop
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? journeyId = null,Object? placeId = null,Object? orderNum = null,Object? placeName = freezed,Object? placeImageUrl = freezed,Object? lat = freezed,Object? lng = freezed,Object? distanceFromPrev = freezed,}) {
  return _then(_JourneyStop(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,journeyId: null == journeyId ? _self.journeyId : journeyId // ignore: cast_nullable_to_non_nullable
as int,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int,orderNum: null == orderNum ? _self.orderNum : orderNum // ignore: cast_nullable_to_non_nullable
as int,placeName: freezed == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String?,placeImageUrl: freezed == placeImageUrl ? _self.placeImageUrl : placeImageUrl // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lng: freezed == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double?,distanceFromPrev: freezed == distanceFromPrev ? _self.distanceFromPrev : distanceFromPrev // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

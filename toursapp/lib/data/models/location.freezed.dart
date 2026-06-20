// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'location.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Location {

 int get id; int get provinceId; String get name; double get lat; double get lng; String? get nameEn; String? get nameKo; String? get nameZh; String? get description; int get orderNum; String? get imageUrl;
/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LocationCopyWith<Location> get copyWith => _$LocationCopyWithImpl<Location>(this as Location, _$identity);

  /// Serializes this Location to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Location&&(identical(other.id, id) || other.id == id)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.orderNum, orderNum) || other.orderNum == orderNum)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,provinceId,name,lat,lng,nameEn,nameKo,nameZh,description,orderNum,imageUrl);

@override
String toString() {
  return 'Location(id: $id, provinceId: $provinceId, name: $name, lat: $lat, lng: $lng, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, orderNum: $orderNum, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class $LocationCopyWith<$Res>  {
  factory $LocationCopyWith(Location value, $Res Function(Location) _then) = _$LocationCopyWithImpl;
@useResult
$Res call({
 int id, int provinceId, String name, double lat, double lng, String? nameEn, String? nameKo, String? nameZh, String? description, int orderNum, String? imageUrl
});




}
/// @nodoc
class _$LocationCopyWithImpl<$Res>
    implements $LocationCopyWith<$Res> {
  _$LocationCopyWithImpl(this._self, this._then);

  final Location _self;
  final $Res Function(Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provinceId = null,Object? name = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? orderNum = null,Object? imageUrl = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,provinceId: null == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,orderNum: null == orderNum ? _self.orderNum : orderNum // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Location].
extension LocationPatterns on Location {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Location value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Location value)  $default,){
final _that = this;
switch (_that) {
case _Location():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Location value)?  $default,){
final _that = this;
switch (_that) {
case _Location() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int provinceId,  String name,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  int orderNum,  String? imageUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.provinceId,_that.name,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.orderNum,_that.imageUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int provinceId,  String name,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  int orderNum,  String? imageUrl)  $default,) {final _that = this;
switch (_that) {
case _Location():
return $default(_that.id,_that.provinceId,_that.name,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.orderNum,_that.imageUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int provinceId,  String name,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  int orderNum,  String? imageUrl)?  $default,) {final _that = this;
switch (_that) {
case _Location() when $default != null:
return $default(_that.id,_that.provinceId,_that.name,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.orderNum,_that.imageUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Location implements Location {
  const _Location({required this.id, required this.provinceId, required this.name, required this.lat, required this.lng, this.nameEn, this.nameKo, this.nameZh, this.description, this.orderNum = 0, this.imageUrl});
  factory _Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);

@override final  int id;
@override final  int provinceId;
@override final  String name;
@override final  double lat;
@override final  double lng;
@override final  String? nameEn;
@override final  String? nameKo;
@override final  String? nameZh;
@override final  String? description;
@override@JsonKey() final  int orderNum;
@override final  String? imageUrl;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LocationCopyWith<_Location> get copyWith => __$LocationCopyWithImpl<_Location>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LocationToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Location&&(identical(other.id, id) || other.id == id)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.orderNum, orderNum) || other.orderNum == orderNum)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,provinceId,name,lat,lng,nameEn,nameKo,nameZh,description,orderNum,imageUrl);

@override
String toString() {
  return 'Location(id: $id, provinceId: $provinceId, name: $name, lat: $lat, lng: $lng, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, orderNum: $orderNum, imageUrl: $imageUrl)';
}


}

/// @nodoc
abstract mixin class _$LocationCopyWith<$Res> implements $LocationCopyWith<$Res> {
  factory _$LocationCopyWith(_Location value, $Res Function(_Location) _then) = __$LocationCopyWithImpl;
@override @useResult
$Res call({
 int id, int provinceId, String name, double lat, double lng, String? nameEn, String? nameKo, String? nameZh, String? description, int orderNum, String? imageUrl
});




}
/// @nodoc
class __$LocationCopyWithImpl<$Res>
    implements _$LocationCopyWith<$Res> {
  __$LocationCopyWithImpl(this._self, this._then);

  final _Location _self;
  final $Res Function(_Location) _then;

/// Create a copy of Location
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provinceId = null,Object? name = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? orderNum = null,Object? imageUrl = freezed,}) {
  return _then(_Location(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,provinceId: null == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,orderNum: null == orderNum ? _self.orderNum : orderNum // ignore: cast_nullable_to_non_nullable
as int,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

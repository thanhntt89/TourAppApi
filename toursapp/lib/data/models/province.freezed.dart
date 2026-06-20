// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'province.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Province {

 int get id; String get name; double get lat; double get lng; String? get imageUrl; bool get isActive; int get totalLocations; int get totalPlaces; int get sortOrder; int get detectionRadiusKm;
/// Create a copy of Province
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvinceCopyWith<Province> get copyWith => _$ProvinceCopyWithImpl<Province>(this as Province, _$identity);

  /// Serializes this Province to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Province&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.totalLocations, totalLocations) || other.totalLocations == totalLocations)&&(identical(other.totalPlaces, totalPlaces) || other.totalPlaces == totalPlaces)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.detectionRadiusKm, detectionRadiusKm) || other.detectionRadiusKm == detectionRadiusKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,imageUrl,isActive,totalLocations,totalPlaces,sortOrder,detectionRadiusKm);

@override
String toString() {
  return 'Province(id: $id, name: $name, lat: $lat, lng: $lng, imageUrl: $imageUrl, isActive: $isActive, totalLocations: $totalLocations, totalPlaces: $totalPlaces, sortOrder: $sortOrder, detectionRadiusKm: $detectionRadiusKm)';
}


}

/// @nodoc
abstract mixin class $ProvinceCopyWith<$Res>  {
  factory $ProvinceCopyWith(Province value, $Res Function(Province) _then) = _$ProvinceCopyWithImpl;
@useResult
$Res call({
 int id, String name, double lat, double lng, String? imageUrl, bool isActive, int totalLocations, int totalPlaces, int sortOrder, int detectionRadiusKm
});




}
/// @nodoc
class _$ProvinceCopyWithImpl<$Res>
    implements $ProvinceCopyWith<$Res> {
  _$ProvinceCopyWithImpl(this._self, this._then);

  final Province _self;
  final $Res Function(Province) _then;

/// Create a copy of Province
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? imageUrl = freezed,Object? isActive = null,Object? totalLocations = null,Object? totalPlaces = null,Object? sortOrder = null,Object? detectionRadiusKm = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,totalLocations: null == totalLocations ? _self.totalLocations : totalLocations // ignore: cast_nullable_to_non_nullable
as int,totalPlaces: null == totalPlaces ? _self.totalPlaces : totalPlaces // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,detectionRadiusKm: null == detectionRadiusKm ? _self.detectionRadiusKm : detectionRadiusKm // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Province].
extension ProvincePatterns on Province {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Province value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Province() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Province value)  $default,){
final _that = this;
switch (_that) {
case _Province():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Province value)?  $default,){
final _that = this;
switch (_that) {
case _Province() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  double lat,  double lng,  String? imageUrl,  bool isActive,  int totalLocations,  int totalPlaces,  int sortOrder,  int detectionRadiusKm)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Province() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.imageUrl,_that.isActive,_that.totalLocations,_that.totalPlaces,_that.sortOrder,_that.detectionRadiusKm);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  double lat,  double lng,  String? imageUrl,  bool isActive,  int totalLocations,  int totalPlaces,  int sortOrder,  int detectionRadiusKm)  $default,) {final _that = this;
switch (_that) {
case _Province():
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.imageUrl,_that.isActive,_that.totalLocations,_that.totalPlaces,_that.sortOrder,_that.detectionRadiusKm);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  double lat,  double lng,  String? imageUrl,  bool isActive,  int totalLocations,  int totalPlaces,  int sortOrder,  int detectionRadiusKm)?  $default,) {final _that = this;
switch (_that) {
case _Province() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.imageUrl,_that.isActive,_that.totalLocations,_that.totalPlaces,_that.sortOrder,_that.detectionRadiusKm);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Province implements Province {
  const _Province({required this.id, required this.name, required this.lat, required this.lng, this.imageUrl, this.isActive = true, this.totalLocations = 0, this.totalPlaces = 0, this.sortOrder = 0, this.detectionRadiusKm = 50});
  factory _Province.fromJson(Map<String, dynamic> json) => _$ProvinceFromJson(json);

@override final  int id;
@override final  String name;
@override final  double lat;
@override final  double lng;
@override final  String? imageUrl;
@override@JsonKey() final  bool isActive;
@override@JsonKey() final  int totalLocations;
@override@JsonKey() final  int totalPlaces;
@override@JsonKey() final  int sortOrder;
@override@JsonKey() final  int detectionRadiusKm;

/// Create a copy of Province
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProvinceCopyWith<_Province> get copyWith => __$ProvinceCopyWithImpl<_Province>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProvinceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Province&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.totalLocations, totalLocations) || other.totalLocations == totalLocations)&&(identical(other.totalPlaces, totalPlaces) || other.totalPlaces == totalPlaces)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.detectionRadiusKm, detectionRadiusKm) || other.detectionRadiusKm == detectionRadiusKm));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,imageUrl,isActive,totalLocations,totalPlaces,sortOrder,detectionRadiusKm);

@override
String toString() {
  return 'Province(id: $id, name: $name, lat: $lat, lng: $lng, imageUrl: $imageUrl, isActive: $isActive, totalLocations: $totalLocations, totalPlaces: $totalPlaces, sortOrder: $sortOrder, detectionRadiusKm: $detectionRadiusKm)';
}


}

/// @nodoc
abstract mixin class _$ProvinceCopyWith<$Res> implements $ProvinceCopyWith<$Res> {
  factory _$ProvinceCopyWith(_Province value, $Res Function(_Province) _then) = __$ProvinceCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, double lat, double lng, String? imageUrl, bool isActive, int totalLocations, int totalPlaces, int sortOrder, int detectionRadiusKm
});




}
/// @nodoc
class __$ProvinceCopyWithImpl<$Res>
    implements _$ProvinceCopyWith<$Res> {
  __$ProvinceCopyWithImpl(this._self, this._then);

  final _Province _self;
  final $Res Function(_Province) _then;

/// Create a copy of Province
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? imageUrl = freezed,Object? isActive = null,Object? totalLocations = null,Object? totalPlaces = null,Object? sortOrder = null,Object? detectionRadiusKm = null,}) {
  return _then(_Province(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,totalLocations: null == totalLocations ? _self.totalLocations : totalLocations // ignore: cast_nullable_to_non_nullable
as int,totalPlaces: null == totalPlaces ? _self.totalPlaces : totalPlaces // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,detectionRadiusKm: null == detectionRadiusKm ? _self.detectionRadiusKm : detectionRadiusKm // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

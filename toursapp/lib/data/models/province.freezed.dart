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

 int get id; String get name; double get lat; double get lng; String? get nameEn; String? get nameKo; String? get nameZh; String? get description; String? get descriptionEn; String? get imageUrl; bool get isActive;
/// Create a copy of Province
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProvinceCopyWith<Province> get copyWith => _$ProvinceCopyWithImpl<Province>(this as Province, _$identity);

  /// Serializes this Province to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Province&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,nameEn,nameKo,nameZh,description,descriptionEn,imageUrl,isActive);

@override
String toString() {
  return 'Province(id: $id, name: $name, lat: $lat, lng: $lng, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, descriptionEn: $descriptionEn, imageUrl: $imageUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $ProvinceCopyWith<$Res>  {
  factory $ProvinceCopyWith(Province value, $Res Function(Province) _then) = _$ProvinceCopyWithImpl;
@useResult
$Res call({
 int id, String name, double lat, double lng, String? nameEn, String? nameKo, String? nameZh, String? description, String? descriptionEn, String? imageUrl, bool isActive
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? imageUrl = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Province() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _Province():
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _Province() when $default != null:
return $default(_that.id,_that.name,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Province implements Province {
  const _Province({required this.id, required this.name, required this.lat, required this.lng, this.nameEn, this.nameKo, this.nameZh, this.description, this.descriptionEn, this.imageUrl, this.isActive = true});
  factory _Province.fromJson(Map<String, dynamic> json) => _$ProvinceFromJson(json);

@override final  int id;
@override final  String name;
@override final  double lat;
@override final  double lng;
@override final  String? nameEn;
@override final  String? nameKo;
@override final  String? nameZh;
@override final  String? description;
@override final  String? descriptionEn;
@override final  String? imageUrl;
@override@JsonKey() final  bool isActive;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Province&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,lat,lng,nameEn,nameKo,nameZh,description,descriptionEn,imageUrl,isActive);

@override
String toString() {
  return 'Province(id: $id, name: $name, lat: $lat, lng: $lng, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, descriptionEn: $descriptionEn, imageUrl: $imageUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$ProvinceCopyWith<$Res> implements $ProvinceCopyWith<$Res> {
  factory _$ProvinceCopyWith(_Province value, $Res Function(_Province) _then) = __$ProvinceCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, double lat, double lng, String? nameEn, String? nameKo, String? nameZh, String? description, String? descriptionEn, String? imageUrl, bool isActive
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? imageUrl = freezed,Object? isActive = null,}) {
  return _then(_Province(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

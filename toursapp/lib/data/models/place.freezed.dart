// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Place {

 int get id; int get locationId; String get name; String get slug; double get lat; double get lng; String? get nameEn; String? get nameKo; String? get nameZh; String? get description; String? get descriptionEn; String? get imageUrl; List<String> get galleryUrls; String? get audioUrlVi; String? get audioUrlEn; String? get audioUrlKo; String? get audioUrlZh; int get audioDuration; String? get category; String? get difficulty; String? get openingHours; String? get entranceFee; String? get tips; String? get tipsEn; int get flowerCost; String? get qrCode; String? get status; String? get visitDuration;
/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlaceCopyWith<Place> get copyWith => _$PlaceCopyWithImpl<Place>(this as Place, _$identity);

  /// Serializes this Place to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Place&&(identical(other.id, id) || other.id == id)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other.galleryUrls, galleryUrls)&&(identical(other.audioUrlVi, audioUrlVi) || other.audioUrlVi == audioUrlVi)&&(identical(other.audioUrlEn, audioUrlEn) || other.audioUrlEn == audioUrlEn)&&(identical(other.audioUrlKo, audioUrlKo) || other.audioUrlKo == audioUrlKo)&&(identical(other.audioUrlZh, audioUrlZh) || other.audioUrlZh == audioUrlZh)&&(identical(other.audioDuration, audioDuration) || other.audioDuration == audioDuration)&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.openingHours, openingHours) || other.openingHours == openingHours)&&(identical(other.entranceFee, entranceFee) || other.entranceFee == entranceFee)&&(identical(other.tips, tips) || other.tips == tips)&&(identical(other.tipsEn, tipsEn) || other.tipsEn == tipsEn)&&(identical(other.flowerCost, flowerCost) || other.flowerCost == flowerCost)&&(identical(other.qrCode, qrCode) || other.qrCode == qrCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.visitDuration, visitDuration) || other.visitDuration == visitDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,locationId,name,slug,lat,lng,nameEn,nameKo,nameZh,description,descriptionEn,imageUrl,const DeepCollectionEquality().hash(galleryUrls),audioUrlVi,audioUrlEn,audioUrlKo,audioUrlZh,audioDuration,category,difficulty,openingHours,entranceFee,tips,tipsEn,flowerCost,qrCode,status,visitDuration]);

@override
String toString() {
  return 'Place(id: $id, locationId: $locationId, name: $name, slug: $slug, lat: $lat, lng: $lng, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, descriptionEn: $descriptionEn, imageUrl: $imageUrl, galleryUrls: $galleryUrls, audioUrlVi: $audioUrlVi, audioUrlEn: $audioUrlEn, audioUrlKo: $audioUrlKo, audioUrlZh: $audioUrlZh, audioDuration: $audioDuration, category: $category, difficulty: $difficulty, openingHours: $openingHours, entranceFee: $entranceFee, tips: $tips, tipsEn: $tipsEn, flowerCost: $flowerCost, qrCode: $qrCode, status: $status, visitDuration: $visitDuration)';
}


}

/// @nodoc
abstract mixin class $PlaceCopyWith<$Res>  {
  factory $PlaceCopyWith(Place value, $Res Function(Place) _then) = _$PlaceCopyWithImpl;
@useResult
$Res call({
 int id, int locationId, String name, String slug, double lat, double lng, String? nameEn, String? nameKo, String? nameZh, String? description, String? descriptionEn, String? imageUrl, List<String> galleryUrls, String? audioUrlVi, String? audioUrlEn, String? audioUrlKo, String? audioUrlZh, int audioDuration, String? category, String? difficulty, String? openingHours, String? entranceFee, String? tips, String? tipsEn, int flowerCost, String? qrCode, String? status, String? visitDuration
});




}
/// @nodoc
class _$PlaceCopyWithImpl<$Res>
    implements $PlaceCopyWith<$Res> {
  _$PlaceCopyWithImpl(this._self, this._then);

  final Place _self;
  final $Res Function(Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? locationId = null,Object? name = null,Object? slug = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? imageUrl = freezed,Object? galleryUrls = null,Object? audioUrlVi = freezed,Object? audioUrlEn = freezed,Object? audioUrlKo = freezed,Object? audioUrlZh = freezed,Object? audioDuration = null,Object? category = freezed,Object? difficulty = freezed,Object? openingHours = freezed,Object? entranceFee = freezed,Object? tips = freezed,Object? tipsEn = freezed,Object? flowerCost = null,Object? qrCode = freezed,Object? status = freezed,Object? visitDuration = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,locationId: null == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,galleryUrls: null == galleryUrls ? _self.galleryUrls : galleryUrls // ignore: cast_nullable_to_non_nullable
as List<String>,audioUrlVi: freezed == audioUrlVi ? _self.audioUrlVi : audioUrlVi // ignore: cast_nullable_to_non_nullable
as String?,audioUrlEn: freezed == audioUrlEn ? _self.audioUrlEn : audioUrlEn // ignore: cast_nullable_to_non_nullable
as String?,audioUrlKo: freezed == audioUrlKo ? _self.audioUrlKo : audioUrlKo // ignore: cast_nullable_to_non_nullable
as String?,audioUrlZh: freezed == audioUrlZh ? _self.audioUrlZh : audioUrlZh // ignore: cast_nullable_to_non_nullable
as String?,audioDuration: null == audioDuration ? _self.audioDuration : audioDuration // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,openingHours: freezed == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as String?,entranceFee: freezed == entranceFee ? _self.entranceFee : entranceFee // ignore: cast_nullable_to_non_nullable
as String?,tips: freezed == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as String?,tipsEn: freezed == tipsEn ? _self.tipsEn : tipsEn // ignore: cast_nullable_to_non_nullable
as String?,flowerCost: null == flowerCost ? _self.flowerCost : flowerCost // ignore: cast_nullable_to_non_nullable
as int,qrCode: freezed == qrCode ? _self.qrCode : qrCode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,visitDuration: freezed == visitDuration ? _self.visitDuration : visitDuration // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Place].
extension PlacePatterns on Place {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Place value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Place value)  $default,){
final _that = this;
switch (_that) {
case _Place():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Place value)?  $default,){
final _that = this;
switch (_that) {
case _Place() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int locationId,  String name,  String slug,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  List<String> galleryUrls,  String? audioUrlVi,  String? audioUrlEn,  String? audioUrlKo,  String? audioUrlZh,  int audioDuration,  String? category,  String? difficulty,  String? openingHours,  String? entranceFee,  String? tips,  String? tipsEn,  int flowerCost,  String? qrCode,  String? status,  String? visitDuration)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.locationId,_that.name,_that.slug,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.galleryUrls,_that.audioUrlVi,_that.audioUrlEn,_that.audioUrlKo,_that.audioUrlZh,_that.audioDuration,_that.category,_that.difficulty,_that.openingHours,_that.entranceFee,_that.tips,_that.tipsEn,_that.flowerCost,_that.qrCode,_that.status,_that.visitDuration);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int locationId,  String name,  String slug,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  List<String> galleryUrls,  String? audioUrlVi,  String? audioUrlEn,  String? audioUrlKo,  String? audioUrlZh,  int audioDuration,  String? category,  String? difficulty,  String? openingHours,  String? entranceFee,  String? tips,  String? tipsEn,  int flowerCost,  String? qrCode,  String? status,  String? visitDuration)  $default,) {final _that = this;
switch (_that) {
case _Place():
return $default(_that.id,_that.locationId,_that.name,_that.slug,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.galleryUrls,_that.audioUrlVi,_that.audioUrlEn,_that.audioUrlKo,_that.audioUrlZh,_that.audioDuration,_that.category,_that.difficulty,_that.openingHours,_that.entranceFee,_that.tips,_that.tipsEn,_that.flowerCost,_that.qrCode,_that.status,_that.visitDuration);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int locationId,  String name,  String slug,  double lat,  double lng,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  List<String> galleryUrls,  String? audioUrlVi,  String? audioUrlEn,  String? audioUrlKo,  String? audioUrlZh,  int audioDuration,  String? category,  String? difficulty,  String? openingHours,  String? entranceFee,  String? tips,  String? tipsEn,  int flowerCost,  String? qrCode,  String? status,  String? visitDuration)?  $default,) {final _that = this;
switch (_that) {
case _Place() when $default != null:
return $default(_that.id,_that.locationId,_that.name,_that.slug,_that.lat,_that.lng,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.galleryUrls,_that.audioUrlVi,_that.audioUrlEn,_that.audioUrlKo,_that.audioUrlZh,_that.audioDuration,_that.category,_that.difficulty,_that.openingHours,_that.entranceFee,_that.tips,_that.tipsEn,_that.flowerCost,_that.qrCode,_that.status,_that.visitDuration);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Place implements Place {
  const _Place({required this.id, required this.locationId, required this.name, required this.slug, required this.lat, required this.lng, this.nameEn, this.nameKo, this.nameZh, this.description, this.descriptionEn, this.imageUrl, final  List<String> galleryUrls = const [], this.audioUrlVi, this.audioUrlEn, this.audioUrlKo, this.audioUrlZh, this.audioDuration = 0, this.category, this.difficulty, this.openingHours, this.entranceFee, this.tips, this.tipsEn, this.flowerCost = 5, this.qrCode, this.status, this.visitDuration}): _galleryUrls = galleryUrls;
  factory _Place.fromJson(Map<String, dynamic> json) => _$PlaceFromJson(json);

@override final  int id;
@override final  int locationId;
@override final  String name;
@override final  String slug;
@override final  double lat;
@override final  double lng;
@override final  String? nameEn;
@override final  String? nameKo;
@override final  String? nameZh;
@override final  String? description;
@override final  String? descriptionEn;
@override final  String? imageUrl;
 final  List<String> _galleryUrls;
@override@JsonKey() List<String> get galleryUrls {
  if (_galleryUrls is EqualUnmodifiableListView) return _galleryUrls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_galleryUrls);
}

@override final  String? audioUrlVi;
@override final  String? audioUrlEn;
@override final  String? audioUrlKo;
@override final  String? audioUrlZh;
@override@JsonKey() final  int audioDuration;
@override final  String? category;
@override final  String? difficulty;
@override final  String? openingHours;
@override final  String? entranceFee;
@override final  String? tips;
@override final  String? tipsEn;
@override@JsonKey() final  int flowerCost;
@override final  String? qrCode;
@override final  String? status;
@override final  String? visitDuration;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlaceCopyWith<_Place> get copyWith => __$PlaceCopyWithImpl<_Place>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Place&&(identical(other.id, id) || other.id == id)&&(identical(other.locationId, locationId) || other.locationId == locationId)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&const DeepCollectionEquality().equals(other._galleryUrls, _galleryUrls)&&(identical(other.audioUrlVi, audioUrlVi) || other.audioUrlVi == audioUrlVi)&&(identical(other.audioUrlEn, audioUrlEn) || other.audioUrlEn == audioUrlEn)&&(identical(other.audioUrlKo, audioUrlKo) || other.audioUrlKo == audioUrlKo)&&(identical(other.audioUrlZh, audioUrlZh) || other.audioUrlZh == audioUrlZh)&&(identical(other.audioDuration, audioDuration) || other.audioDuration == audioDuration)&&(identical(other.category, category) || other.category == category)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.openingHours, openingHours) || other.openingHours == openingHours)&&(identical(other.entranceFee, entranceFee) || other.entranceFee == entranceFee)&&(identical(other.tips, tips) || other.tips == tips)&&(identical(other.tipsEn, tipsEn) || other.tipsEn == tipsEn)&&(identical(other.flowerCost, flowerCost) || other.flowerCost == flowerCost)&&(identical(other.qrCode, qrCode) || other.qrCode == qrCode)&&(identical(other.status, status) || other.status == status)&&(identical(other.visitDuration, visitDuration) || other.visitDuration == visitDuration));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,id,locationId,name,slug,lat,lng,nameEn,nameKo,nameZh,description,descriptionEn,imageUrl,const DeepCollectionEquality().hash(_galleryUrls),audioUrlVi,audioUrlEn,audioUrlKo,audioUrlZh,audioDuration,category,difficulty,openingHours,entranceFee,tips,tipsEn,flowerCost,qrCode,status,visitDuration]);

@override
String toString() {
  return 'Place(id: $id, locationId: $locationId, name: $name, slug: $slug, lat: $lat, lng: $lng, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, descriptionEn: $descriptionEn, imageUrl: $imageUrl, galleryUrls: $galleryUrls, audioUrlVi: $audioUrlVi, audioUrlEn: $audioUrlEn, audioUrlKo: $audioUrlKo, audioUrlZh: $audioUrlZh, audioDuration: $audioDuration, category: $category, difficulty: $difficulty, openingHours: $openingHours, entranceFee: $entranceFee, tips: $tips, tipsEn: $tipsEn, flowerCost: $flowerCost, qrCode: $qrCode, status: $status, visitDuration: $visitDuration)';
}


}

/// @nodoc
abstract mixin class _$PlaceCopyWith<$Res> implements $PlaceCopyWith<$Res> {
  factory _$PlaceCopyWith(_Place value, $Res Function(_Place) _then) = __$PlaceCopyWithImpl;
@override @useResult
$Res call({
 int id, int locationId, String name, String slug, double lat, double lng, String? nameEn, String? nameKo, String? nameZh, String? description, String? descriptionEn, String? imageUrl, List<String> galleryUrls, String? audioUrlVi, String? audioUrlEn, String? audioUrlKo, String? audioUrlZh, int audioDuration, String? category, String? difficulty, String? openingHours, String? entranceFee, String? tips, String? tipsEn, int flowerCost, String? qrCode, String? status, String? visitDuration
});




}
/// @nodoc
class __$PlaceCopyWithImpl<$Res>
    implements _$PlaceCopyWith<$Res> {
  __$PlaceCopyWithImpl(this._self, this._then);

  final _Place _self;
  final $Res Function(_Place) _then;

/// Create a copy of Place
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? locationId = null,Object? name = null,Object? slug = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? imageUrl = freezed,Object? galleryUrls = null,Object? audioUrlVi = freezed,Object? audioUrlEn = freezed,Object? audioUrlKo = freezed,Object? audioUrlZh = freezed,Object? audioDuration = null,Object? category = freezed,Object? difficulty = freezed,Object? openingHours = freezed,Object? entranceFee = freezed,Object? tips = freezed,Object? tipsEn = freezed,Object? flowerCost = null,Object? qrCode = freezed,Object? status = freezed,Object? visitDuration = freezed,}) {
  return _then(_Place(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,locationId: null == locationId ? _self.locationId : locationId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,galleryUrls: null == galleryUrls ? _self._galleryUrls : galleryUrls // ignore: cast_nullable_to_non_nullable
as List<String>,audioUrlVi: freezed == audioUrlVi ? _self.audioUrlVi : audioUrlVi // ignore: cast_nullable_to_non_nullable
as String?,audioUrlEn: freezed == audioUrlEn ? _self.audioUrlEn : audioUrlEn // ignore: cast_nullable_to_non_nullable
as String?,audioUrlKo: freezed == audioUrlKo ? _self.audioUrlKo : audioUrlKo // ignore: cast_nullable_to_non_nullable
as String?,audioUrlZh: freezed == audioUrlZh ? _self.audioUrlZh : audioUrlZh // ignore: cast_nullable_to_non_nullable
as String?,audioDuration: null == audioDuration ? _self.audioDuration : audioDuration // ignore: cast_nullable_to_non_nullable
as int,category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,openingHours: freezed == openingHours ? _self.openingHours : openingHours // ignore: cast_nullable_to_non_nullable
as String?,entranceFee: freezed == entranceFee ? _self.entranceFee : entranceFee // ignore: cast_nullable_to_non_nullable
as String?,tips: freezed == tips ? _self.tips : tips // ignore: cast_nullable_to_non_nullable
as String?,tipsEn: freezed == tipsEn ? _self.tipsEn : tipsEn // ignore: cast_nullable_to_non_nullable
as String?,flowerCost: null == flowerCost ? _self.flowerCost : flowerCost // ignore: cast_nullable_to_non_nullable
as int,qrCode: freezed == qrCode ? _self.qrCode : qrCode // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String?,visitDuration: freezed == visitDuration ? _self.visitDuration : visitDuration // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'service_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ServiceProvider {

 int get id; String get name; String get category; double get lat; double get lng; String? get nameEn; String? get description; String? get descriptionEn; String? get address; String? get phone; String? get website; String? get imageUrl; double? get rating; String? get priceRange;
/// Create a copy of ServiceProvider
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ServiceProviderCopyWith<ServiceProvider> get copyWith => _$ServiceProviderCopyWithImpl<ServiceProvider>(this as ServiceProvider, _$identity);

  /// Serializes this ServiceProvider to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.website, website) || other.website == website)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.priceRange, priceRange) || other.priceRange == priceRange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,lat,lng,nameEn,description,descriptionEn,address,phone,website,imageUrl,rating,priceRange);

@override
String toString() {
  return 'ServiceProvider(id: $id, name: $name, category: $category, lat: $lat, lng: $lng, nameEn: $nameEn, description: $description, descriptionEn: $descriptionEn, address: $address, phone: $phone, website: $website, imageUrl: $imageUrl, rating: $rating, priceRange: $priceRange)';
}


}

/// @nodoc
abstract mixin class $ServiceProviderCopyWith<$Res>  {
  factory $ServiceProviderCopyWith(ServiceProvider value, $Res Function(ServiceProvider) _then) = _$ServiceProviderCopyWithImpl;
@useResult
$Res call({
 int id, String name, String category, double lat, double lng, String? nameEn, String? description, String? descriptionEn, String? address, String? phone, String? website, String? imageUrl, double? rating, String? priceRange
});




}
/// @nodoc
class _$ServiceProviderCopyWithImpl<$Res>
    implements $ServiceProviderCopyWith<$Res> {
  _$ServiceProviderCopyWithImpl(this._self, this._then);

  final ServiceProvider _self;
  final $Res Function(ServiceProvider) _then;

/// Create a copy of ServiceProvider
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? category = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? address = freezed,Object? phone = freezed,Object? website = freezed,Object? imageUrl = freezed,Object? rating = freezed,Object? priceRange = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,priceRange: freezed == priceRange ? _self.priceRange : priceRange // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ServiceProvider].
extension ServiceProviderPatterns on ServiceProvider {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ServiceProvider value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ServiceProvider() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ServiceProvider value)  $default,){
final _that = this;
switch (_that) {
case _ServiceProvider():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ServiceProvider value)?  $default,){
final _that = this;
switch (_that) {
case _ServiceProvider() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String category,  double lat,  double lng,  String? nameEn,  String? description,  String? descriptionEn,  String? address,  String? phone,  String? website,  String? imageUrl,  double? rating,  String? priceRange)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ServiceProvider() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.lat,_that.lng,_that.nameEn,_that.description,_that.descriptionEn,_that.address,_that.phone,_that.website,_that.imageUrl,_that.rating,_that.priceRange);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String category,  double lat,  double lng,  String? nameEn,  String? description,  String? descriptionEn,  String? address,  String? phone,  String? website,  String? imageUrl,  double? rating,  String? priceRange)  $default,) {final _that = this;
switch (_that) {
case _ServiceProvider():
return $default(_that.id,_that.name,_that.category,_that.lat,_that.lng,_that.nameEn,_that.description,_that.descriptionEn,_that.address,_that.phone,_that.website,_that.imageUrl,_that.rating,_that.priceRange);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String category,  double lat,  double lng,  String? nameEn,  String? description,  String? descriptionEn,  String? address,  String? phone,  String? website,  String? imageUrl,  double? rating,  String? priceRange)?  $default,) {final _that = this;
switch (_that) {
case _ServiceProvider() when $default != null:
return $default(_that.id,_that.name,_that.category,_that.lat,_that.lng,_that.nameEn,_that.description,_that.descriptionEn,_that.address,_that.phone,_that.website,_that.imageUrl,_that.rating,_that.priceRange);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ServiceProvider implements ServiceProvider {
  const _ServiceProvider({required this.id, required this.name, required this.category, required this.lat, required this.lng, this.nameEn, this.description, this.descriptionEn, this.address, this.phone, this.website, this.imageUrl, this.rating, this.priceRange});
  factory _ServiceProvider.fromJson(Map<String, dynamic> json) => _$ServiceProviderFromJson(json);

@override final  int id;
@override final  String name;
@override final  String category;
@override final  double lat;
@override final  double lng;
@override final  String? nameEn;
@override final  String? description;
@override final  String? descriptionEn;
@override final  String? address;
@override final  String? phone;
@override final  String? website;
@override final  String? imageUrl;
@override final  double? rating;
@override final  String? priceRange;

/// Create a copy of ServiceProvider
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ServiceProviderCopyWith<_ServiceProvider> get copyWith => __$ServiceProviderCopyWithImpl<_ServiceProvider>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ServiceProviderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ServiceProvider&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.category, category) || other.category == category)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lng, lng) || other.lng == lng)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.address, address) || other.address == address)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.website, website) || other.website == website)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.rating, rating) || other.rating == rating)&&(identical(other.priceRange, priceRange) || other.priceRange == priceRange));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,category,lat,lng,nameEn,description,descriptionEn,address,phone,website,imageUrl,rating,priceRange);

@override
String toString() {
  return 'ServiceProvider(id: $id, name: $name, category: $category, lat: $lat, lng: $lng, nameEn: $nameEn, description: $description, descriptionEn: $descriptionEn, address: $address, phone: $phone, website: $website, imageUrl: $imageUrl, rating: $rating, priceRange: $priceRange)';
}


}

/// @nodoc
abstract mixin class _$ServiceProviderCopyWith<$Res> implements $ServiceProviderCopyWith<$Res> {
  factory _$ServiceProviderCopyWith(_ServiceProvider value, $Res Function(_ServiceProvider) _then) = __$ServiceProviderCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String category, double lat, double lng, String? nameEn, String? description, String? descriptionEn, String? address, String? phone, String? website, String? imageUrl, double? rating, String? priceRange
});




}
/// @nodoc
class __$ServiceProviderCopyWithImpl<$Res>
    implements _$ServiceProviderCopyWith<$Res> {
  __$ServiceProviderCopyWithImpl(this._self, this._then);

  final _ServiceProvider _self;
  final $Res Function(_ServiceProvider) _then;

/// Create a copy of ServiceProvider
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? category = null,Object? lat = null,Object? lng = null,Object? nameEn = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? address = freezed,Object? phone = freezed,Object? website = freezed,Object? imageUrl = freezed,Object? rating = freezed,Object? priceRange = freezed,}) {
  return _then(_ServiceProvider(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,lat: null == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double,lng: null == lng ? _self.lng : lng // ignore: cast_nullable_to_non_nullable
as double,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,rating: freezed == rating ? _self.rating : rating // ignore: cast_nullable_to_non_nullable
as double?,priceRange: freezed == priceRange ? _self.priceRange : priceRange // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

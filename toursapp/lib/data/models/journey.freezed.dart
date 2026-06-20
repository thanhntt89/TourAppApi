// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'journey.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Journey {

 int get id; String get name; String? get nameEn; String? get nameKo; String? get nameZh; String? get description; String? get descriptionEn; String? get imageUrl; String? get totalDistance; String? get estimatedDays; String? get difficulty; bool get isPopular; List<JourneyStop> get stops;
/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$JourneyCopyWith<Journey> get copyWith => _$JourneyCopyWithImpl<Journey>(this as Journey, _$identity);

  /// Serializes this Journey to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Journey&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.estimatedDays, estimatedDays) || other.estimatedDays == estimatedDays)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&const DeepCollectionEquality().equals(other.stops, stops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameEn,nameKo,nameZh,description,descriptionEn,imageUrl,totalDistance,estimatedDays,difficulty,isPopular,const DeepCollectionEquality().hash(stops));

@override
String toString() {
  return 'Journey(id: $id, name: $name, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, descriptionEn: $descriptionEn, imageUrl: $imageUrl, totalDistance: $totalDistance, estimatedDays: $estimatedDays, difficulty: $difficulty, isPopular: $isPopular, stops: $stops)';
}


}

/// @nodoc
abstract mixin class $JourneyCopyWith<$Res>  {
  factory $JourneyCopyWith(Journey value, $Res Function(Journey) _then) = _$JourneyCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? nameEn, String? nameKo, String? nameZh, String? description, String? descriptionEn, String? imageUrl, String? totalDistance, String? estimatedDays, String? difficulty, bool isPopular, List<JourneyStop> stops
});




}
/// @nodoc
class _$JourneyCopyWithImpl<$Res>
    implements $JourneyCopyWith<$Res> {
  _$JourneyCopyWithImpl(this._self, this._then);

  final Journey _self;
  final $Res Function(Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? imageUrl = freezed,Object? totalDistance = freezed,Object? estimatedDays = freezed,Object? difficulty = freezed,Object? isPopular = null,Object? stops = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as String?,estimatedDays: freezed == estimatedDays ? _self.estimatedDays : estimatedDays // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,stops: null == stops ? _self.stops : stops // ignore: cast_nullable_to_non_nullable
as List<JourneyStop>,
  ));
}

}


/// Adds pattern-matching-related methods to [Journey].
extension JourneyPatterns on Journey {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Journey value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Journey() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Journey value)  $default,){
final _that = this;
switch (_that) {
case _Journey():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Journey value)?  $default,){
final _that = this;
switch (_that) {
case _Journey() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  String? totalDistance,  String? estimatedDays,  String? difficulty,  bool isPopular,  List<JourneyStop> stops)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.totalDistance,_that.estimatedDays,_that.difficulty,_that.isPopular,_that.stops);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  String? totalDistance,  String? estimatedDays,  String? difficulty,  bool isPopular,  List<JourneyStop> stops)  $default,) {final _that = this;
switch (_that) {
case _Journey():
return $default(_that.id,_that.name,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.totalDistance,_that.estimatedDays,_that.difficulty,_that.isPopular,_that.stops);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? nameEn,  String? nameKo,  String? nameZh,  String? description,  String? descriptionEn,  String? imageUrl,  String? totalDistance,  String? estimatedDays,  String? difficulty,  bool isPopular,  List<JourneyStop> stops)?  $default,) {final _that = this;
switch (_that) {
case _Journey() when $default != null:
return $default(_that.id,_that.name,_that.nameEn,_that.nameKo,_that.nameZh,_that.description,_that.descriptionEn,_that.imageUrl,_that.totalDistance,_that.estimatedDays,_that.difficulty,_that.isPopular,_that.stops);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Journey implements Journey {
  const _Journey({required this.id, required this.name, this.nameEn, this.nameKo, this.nameZh, this.description, this.descriptionEn, this.imageUrl, this.totalDistance, this.estimatedDays, this.difficulty, this.isPopular = false, final  List<JourneyStop> stops = const []}): _stops = stops;
  factory _Journey.fromJson(Map<String, dynamic> json) => _$JourneyFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? nameEn;
@override final  String? nameKo;
@override final  String? nameZh;
@override final  String? description;
@override final  String? descriptionEn;
@override final  String? imageUrl;
@override final  String? totalDistance;
@override final  String? estimatedDays;
@override final  String? difficulty;
@override@JsonKey() final  bool isPopular;
 final  List<JourneyStop> _stops;
@override@JsonKey() List<JourneyStop> get stops {
  if (_stops is EqualUnmodifiableListView) return _stops;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stops);
}


/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$JourneyCopyWith<_Journey> get copyWith => __$JourneyCopyWithImpl<_Journey>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$JourneyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Journey&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.nameKo, nameKo) || other.nameKo == nameKo)&&(identical(other.nameZh, nameZh) || other.nameZh == nameZh)&&(identical(other.description, description) || other.description == description)&&(identical(other.descriptionEn, descriptionEn) || other.descriptionEn == descriptionEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.estimatedDays, estimatedDays) || other.estimatedDays == estimatedDays)&&(identical(other.difficulty, difficulty) || other.difficulty == difficulty)&&(identical(other.isPopular, isPopular) || other.isPopular == isPopular)&&const DeepCollectionEquality().equals(other._stops, _stops));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,nameEn,nameKo,nameZh,description,descriptionEn,imageUrl,totalDistance,estimatedDays,difficulty,isPopular,const DeepCollectionEquality().hash(_stops));

@override
String toString() {
  return 'Journey(id: $id, name: $name, nameEn: $nameEn, nameKo: $nameKo, nameZh: $nameZh, description: $description, descriptionEn: $descriptionEn, imageUrl: $imageUrl, totalDistance: $totalDistance, estimatedDays: $estimatedDays, difficulty: $difficulty, isPopular: $isPopular, stops: $stops)';
}


}

/// @nodoc
abstract mixin class _$JourneyCopyWith<$Res> implements $JourneyCopyWith<$Res> {
  factory _$JourneyCopyWith(_Journey value, $Res Function(_Journey) _then) = __$JourneyCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? nameEn, String? nameKo, String? nameZh, String? description, String? descriptionEn, String? imageUrl, String? totalDistance, String? estimatedDays, String? difficulty, bool isPopular, List<JourneyStop> stops
});




}
/// @nodoc
class __$JourneyCopyWithImpl<$Res>
    implements _$JourneyCopyWith<$Res> {
  __$JourneyCopyWithImpl(this._self, this._then);

  final _Journey _self;
  final $Res Function(_Journey) _then;

/// Create a copy of Journey
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? nameEn = freezed,Object? nameKo = freezed,Object? nameZh = freezed,Object? description = freezed,Object? descriptionEn = freezed,Object? imageUrl = freezed,Object? totalDistance = freezed,Object? estimatedDays = freezed,Object? difficulty = freezed,Object? isPopular = null,Object? stops = null,}) {
  return _then(_Journey(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,nameKo: freezed == nameKo ? _self.nameKo : nameKo // ignore: cast_nullable_to_non_nullable
as String?,nameZh: freezed == nameZh ? _self.nameZh : nameZh // ignore: cast_nullable_to_non_nullable
as String?,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,descriptionEn: freezed == descriptionEn ? _self.descriptionEn : descriptionEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,totalDistance: freezed == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as String?,estimatedDays: freezed == estimatedDays ? _self.estimatedDays : estimatedDays // ignore: cast_nullable_to_non_nullable
as String?,difficulty: freezed == difficulty ? _self.difficulty : difficulty // ignore: cast_nullable_to_non_nullable
as String?,isPopular: null == isPopular ? _self.isPopular : isPopular // ignore: cast_nullable_to_non_nullable
as bool,stops: null == stops ? _self._stops : stops // ignore: cast_nullable_to_non_nullable
as List<JourneyStop>,
  ));
}


}

// dart format on

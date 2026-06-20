// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_place.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SubPlace {

 int get id; int get placeId; String get name; String? get nameEn; String? get content; String? get contentEn; String? get imageUrl; int get orderNum;
/// Create a copy of SubPlace
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubPlaceCopyWith<SubPlace> get copyWith => _$SubPlaceCopyWithImpl<SubPlace>(this as SubPlace, _$identity);

  /// Serializes this SubPlace to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubPlace&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentEn, contentEn) || other.contentEn == contentEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.orderNum, orderNum) || other.orderNum == orderNum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,name,nameEn,content,contentEn,imageUrl,orderNum);

@override
String toString() {
  return 'SubPlace(id: $id, placeId: $placeId, name: $name, nameEn: $nameEn, content: $content, contentEn: $contentEn, imageUrl: $imageUrl, orderNum: $orderNum)';
}


}

/// @nodoc
abstract mixin class $SubPlaceCopyWith<$Res>  {
  factory $SubPlaceCopyWith(SubPlace value, $Res Function(SubPlace) _then) = _$SubPlaceCopyWithImpl;
@useResult
$Res call({
 int id, int placeId, String name, String? nameEn, String? content, String? contentEn, String? imageUrl, int orderNum
});




}
/// @nodoc
class _$SubPlaceCopyWithImpl<$Res>
    implements $SubPlaceCopyWith<$Res> {
  _$SubPlaceCopyWithImpl(this._self, this._then);

  final SubPlace _self;
  final $Res Function(SubPlace) _then;

/// Create a copy of SubPlace
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? placeId = null,Object? name = null,Object? nameEn = freezed,Object? content = freezed,Object? contentEn = freezed,Object? imageUrl = freezed,Object? orderNum = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,contentEn: freezed == contentEn ? _self.contentEn : contentEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,orderNum: null == orderNum ? _self.orderNum : orderNum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [SubPlace].
extension SubPlacePatterns on SubPlace {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubPlace value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubPlace() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubPlace value)  $default,){
final _that = this;
switch (_that) {
case _SubPlace():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubPlace value)?  $default,){
final _that = this;
switch (_that) {
case _SubPlace() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int placeId,  String name,  String? nameEn,  String? content,  String? contentEn,  String? imageUrl,  int orderNum)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubPlace() when $default != null:
return $default(_that.id,_that.placeId,_that.name,_that.nameEn,_that.content,_that.contentEn,_that.imageUrl,_that.orderNum);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int placeId,  String name,  String? nameEn,  String? content,  String? contentEn,  String? imageUrl,  int orderNum)  $default,) {final _that = this;
switch (_that) {
case _SubPlace():
return $default(_that.id,_that.placeId,_that.name,_that.nameEn,_that.content,_that.contentEn,_that.imageUrl,_that.orderNum);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int placeId,  String name,  String? nameEn,  String? content,  String? contentEn,  String? imageUrl,  int orderNum)?  $default,) {final _that = this;
switch (_that) {
case _SubPlace() when $default != null:
return $default(_that.id,_that.placeId,_that.name,_that.nameEn,_that.content,_that.contentEn,_that.imageUrl,_that.orderNum);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SubPlace implements SubPlace {
  const _SubPlace({required this.id, required this.placeId, required this.name, this.nameEn, this.content, this.contentEn, this.imageUrl, this.orderNum = 0});
  factory _SubPlace.fromJson(Map<String, dynamic> json) => _$SubPlaceFromJson(json);

@override final  int id;
@override final  int placeId;
@override final  String name;
@override final  String? nameEn;
@override final  String? content;
@override final  String? contentEn;
@override final  String? imageUrl;
@override@JsonKey() final  int orderNum;

/// Create a copy of SubPlace
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubPlaceCopyWith<_SubPlace> get copyWith => __$SubPlaceCopyWithImpl<_SubPlace>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubPlaceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubPlace&&(identical(other.id, id) || other.id == id)&&(identical(other.placeId, placeId) || other.placeId == placeId)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEn, nameEn) || other.nameEn == nameEn)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentEn, contentEn) || other.contentEn == contentEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.orderNum, orderNum) || other.orderNum == orderNum));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,placeId,name,nameEn,content,contentEn,imageUrl,orderNum);

@override
String toString() {
  return 'SubPlace(id: $id, placeId: $placeId, name: $name, nameEn: $nameEn, content: $content, contentEn: $contentEn, imageUrl: $imageUrl, orderNum: $orderNum)';
}


}

/// @nodoc
abstract mixin class _$SubPlaceCopyWith<$Res> implements $SubPlaceCopyWith<$Res> {
  factory _$SubPlaceCopyWith(_SubPlace value, $Res Function(_SubPlace) _then) = __$SubPlaceCopyWithImpl;
@override @useResult
$Res call({
 int id, int placeId, String name, String? nameEn, String? content, String? contentEn, String? imageUrl, int orderNum
});




}
/// @nodoc
class __$SubPlaceCopyWithImpl<$Res>
    implements _$SubPlaceCopyWith<$Res> {
  __$SubPlaceCopyWithImpl(this._self, this._then);

  final _SubPlace _self;
  final $Res Function(_SubPlace) _then;

/// Create a copy of SubPlace
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? placeId = null,Object? name = null,Object? nameEn = freezed,Object? content = freezed,Object? contentEn = freezed,Object? imageUrl = freezed,Object? orderNum = null,}) {
  return _then(_SubPlace(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,placeId: null == placeId ? _self.placeId : placeId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEn: freezed == nameEn ? _self.nameEn : nameEn // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,contentEn: freezed == contentEn ? _self.contentEn : contentEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,orderNum: null == orderNum ? _self.orderNum : orderNum // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

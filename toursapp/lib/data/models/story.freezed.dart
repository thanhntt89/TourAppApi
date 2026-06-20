// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Story {

 int get id; String get title; String? get titleEn; String? get titleKo; String? get content; String? get contentEn; String? get imageUrl; int? get readTimeMinutes; List<int> get relatedPlaceIds;
/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryCopyWith<Story> get copyWith => _$StoryCopyWithImpl<Story>(this as Story, _$identity);

  /// Serializes this Story to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleKo, titleKo) || other.titleKo == titleKo)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentEn, contentEn) || other.contentEn == contentEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.readTimeMinutes, readTimeMinutes) || other.readTimeMinutes == readTimeMinutes)&&const DeepCollectionEquality().equals(other.relatedPlaceIds, relatedPlaceIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleEn,titleKo,content,contentEn,imageUrl,readTimeMinutes,const DeepCollectionEquality().hash(relatedPlaceIds));

@override
String toString() {
  return 'Story(id: $id, title: $title, titleEn: $titleEn, titleKo: $titleKo, content: $content, contentEn: $contentEn, imageUrl: $imageUrl, readTimeMinutes: $readTimeMinutes, relatedPlaceIds: $relatedPlaceIds)';
}


}

/// @nodoc
abstract mixin class $StoryCopyWith<$Res>  {
  factory $StoryCopyWith(Story value, $Res Function(Story) _then) = _$StoryCopyWithImpl;
@useResult
$Res call({
 int id, String title, String? titleEn, String? titleKo, String? content, String? contentEn, String? imageUrl, int? readTimeMinutes, List<int> relatedPlaceIds
});




}
/// @nodoc
class _$StoryCopyWithImpl<$Res>
    implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._self, this._then);

  final Story _self;
  final $Res Function(Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? titleEn = freezed,Object? titleKo = freezed,Object? content = freezed,Object? contentEn = freezed,Object? imageUrl = freezed,Object? readTimeMinutes = freezed,Object? relatedPlaceIds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleEn: freezed == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String?,titleKo: freezed == titleKo ? _self.titleKo : titleKo // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,contentEn: freezed == contentEn ? _self.contentEn : contentEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,readTimeMinutes: freezed == readTimeMinutes ? _self.readTimeMinutes : readTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,relatedPlaceIds: null == relatedPlaceIds ? _self.relatedPlaceIds : relatedPlaceIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

}


/// Adds pattern-matching-related methods to [Story].
extension StoryPatterns on Story {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Story value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Story() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Story value)  $default,){
final _that = this;
switch (_that) {
case _Story():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Story value)?  $default,){
final _that = this;
switch (_that) {
case _Story() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  String? titleEn,  String? titleKo,  String? content,  String? contentEn,  String? imageUrl,  int? readTimeMinutes,  List<int> relatedPlaceIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.titleEn,_that.titleKo,_that.content,_that.contentEn,_that.imageUrl,_that.readTimeMinutes,_that.relatedPlaceIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  String? titleEn,  String? titleKo,  String? content,  String? contentEn,  String? imageUrl,  int? readTimeMinutes,  List<int> relatedPlaceIds)  $default,) {final _that = this;
switch (_that) {
case _Story():
return $default(_that.id,_that.title,_that.titleEn,_that.titleKo,_that.content,_that.contentEn,_that.imageUrl,_that.readTimeMinutes,_that.relatedPlaceIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  String? titleEn,  String? titleKo,  String? content,  String? contentEn,  String? imageUrl,  int? readTimeMinutes,  List<int> relatedPlaceIds)?  $default,) {final _that = this;
switch (_that) {
case _Story() when $default != null:
return $default(_that.id,_that.title,_that.titleEn,_that.titleKo,_that.content,_that.contentEn,_that.imageUrl,_that.readTimeMinutes,_that.relatedPlaceIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Story implements Story {
  const _Story({required this.id, required this.title, this.titleEn, this.titleKo, this.content, this.contentEn, this.imageUrl, this.readTimeMinutes, final  List<int> relatedPlaceIds = const []}): _relatedPlaceIds = relatedPlaceIds;
  factory _Story.fromJson(Map<String, dynamic> json) => _$StoryFromJson(json);

@override final  int id;
@override final  String title;
@override final  String? titleEn;
@override final  String? titleKo;
@override final  String? content;
@override final  String? contentEn;
@override final  String? imageUrl;
@override final  int? readTimeMinutes;
 final  List<int> _relatedPlaceIds;
@override@JsonKey() List<int> get relatedPlaceIds {
  if (_relatedPlaceIds is EqualUnmodifiableListView) return _relatedPlaceIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_relatedPlaceIds);
}


/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryCopyWith<_Story> get copyWith => __$StoryCopyWithImpl<_Story>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Story&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.titleKo, titleKo) || other.titleKo == titleKo)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentEn, contentEn) || other.contentEn == contentEn)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.readTimeMinutes, readTimeMinutes) || other.readTimeMinutes == readTimeMinutes)&&const DeepCollectionEquality().equals(other._relatedPlaceIds, _relatedPlaceIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,titleEn,titleKo,content,contentEn,imageUrl,readTimeMinutes,const DeepCollectionEquality().hash(_relatedPlaceIds));

@override
String toString() {
  return 'Story(id: $id, title: $title, titleEn: $titleEn, titleKo: $titleKo, content: $content, contentEn: $contentEn, imageUrl: $imageUrl, readTimeMinutes: $readTimeMinutes, relatedPlaceIds: $relatedPlaceIds)';
}


}

/// @nodoc
abstract mixin class _$StoryCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$StoryCopyWith(_Story value, $Res Function(_Story) _then) = __$StoryCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, String? titleEn, String? titleKo, String? content, String? contentEn, String? imageUrl, int? readTimeMinutes, List<int> relatedPlaceIds
});




}
/// @nodoc
class __$StoryCopyWithImpl<$Res>
    implements _$StoryCopyWith<$Res> {
  __$StoryCopyWithImpl(this._self, this._then);

  final _Story _self;
  final $Res Function(_Story) _then;

/// Create a copy of Story
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? titleEn = freezed,Object? titleKo = freezed,Object? content = freezed,Object? contentEn = freezed,Object? imageUrl = freezed,Object? readTimeMinutes = freezed,Object? relatedPlaceIds = null,}) {
  return _then(_Story(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,titleEn: freezed == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String?,titleKo: freezed == titleKo ? _self.titleKo : titleKo // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,contentEn: freezed == contentEn ? _self.contentEn : contentEn // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,readTimeMinutes: freezed == readTimeMinutes ? _self.readTimeMinutes : readTimeMinutes // ignore: cast_nullable_to_non_nullable
as int?,relatedPlaceIds: null == relatedPlaceIds ? _self._relatedPlaceIds : relatedPlaceIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}


}

// dart format on

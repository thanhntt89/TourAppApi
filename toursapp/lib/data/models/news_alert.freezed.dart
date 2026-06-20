// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_alert.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NewsAlert {

 int get id; String get title; int get provinceId; DateTime get publishedAt; String? get titleEn; String? get content; String? get contentEn; String get type; String? get imageUrl; bool get isActive;
/// Create a copy of NewsAlert
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsAlertCopyWith<NewsAlert> get copyWith => _$NewsAlertCopyWithImpl<NewsAlert>(this as NewsAlert, _$identity);

  /// Serializes this NewsAlert to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentEn, contentEn) || other.contentEn == contentEn)&&(identical(other.type, type) || other.type == type)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,provinceId,publishedAt,titleEn,content,contentEn,type,imageUrl,isActive);

@override
String toString() {
  return 'NewsAlert(id: $id, title: $title, provinceId: $provinceId, publishedAt: $publishedAt, titleEn: $titleEn, content: $content, contentEn: $contentEn, type: $type, imageUrl: $imageUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $NewsAlertCopyWith<$Res>  {
  factory $NewsAlertCopyWith(NewsAlert value, $Res Function(NewsAlert) _then) = _$NewsAlertCopyWithImpl;
@useResult
$Res call({
 int id, String title, int provinceId, DateTime publishedAt, String? titleEn, String? content, String? contentEn, String type, String? imageUrl, bool isActive
});




}
/// @nodoc
class _$NewsAlertCopyWithImpl<$Res>
    implements $NewsAlertCopyWith<$Res> {
  _$NewsAlertCopyWithImpl(this._self, this._then);

  final NewsAlert _self;
  final $Res Function(NewsAlert) _then;

/// Create a copy of NewsAlert
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? provinceId = null,Object? publishedAt = null,Object? titleEn = freezed,Object? content = freezed,Object? contentEn = freezed,Object? type = null,Object? imageUrl = freezed,Object? isActive = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,provinceId: null == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,titleEn: freezed == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,contentEn: freezed == contentEn ? _self.contentEn : contentEn // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NewsAlert].
extension NewsAlertPatterns on NewsAlert {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsAlert value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsAlert() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsAlert value)  $default,){
final _that = this;
switch (_that) {
case _NewsAlert():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsAlert value)?  $default,){
final _that = this;
switch (_that) {
case _NewsAlert() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  int provinceId,  DateTime publishedAt,  String? titleEn,  String? content,  String? contentEn,  String type,  String? imageUrl,  bool isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsAlert() when $default != null:
return $default(_that.id,_that.title,_that.provinceId,_that.publishedAt,_that.titleEn,_that.content,_that.contentEn,_that.type,_that.imageUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  int provinceId,  DateTime publishedAt,  String? titleEn,  String? content,  String? contentEn,  String type,  String? imageUrl,  bool isActive)  $default,) {final _that = this;
switch (_that) {
case _NewsAlert():
return $default(_that.id,_that.title,_that.provinceId,_that.publishedAt,_that.titleEn,_that.content,_that.contentEn,_that.type,_that.imageUrl,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  int provinceId,  DateTime publishedAt,  String? titleEn,  String? content,  String? contentEn,  String type,  String? imageUrl,  bool isActive)?  $default,) {final _that = this;
switch (_that) {
case _NewsAlert() when $default != null:
return $default(_that.id,_that.title,_that.provinceId,_that.publishedAt,_that.titleEn,_that.content,_that.contentEn,_that.type,_that.imageUrl,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewsAlert implements NewsAlert {
  const _NewsAlert({required this.id, required this.title, required this.provinceId, required this.publishedAt, this.titleEn, this.content, this.contentEn, this.type = 'news', this.imageUrl, this.isActive = true});
  factory _NewsAlert.fromJson(Map<String, dynamic> json) => _$NewsAlertFromJson(json);

@override final  int id;
@override final  String title;
@override final  int provinceId;
@override final  DateTime publishedAt;
@override final  String? titleEn;
@override final  String? content;
@override final  String? contentEn;
@override@JsonKey() final  String type;
@override final  String? imageUrl;
@override@JsonKey() final  bool isActive;

/// Create a copy of NewsAlert
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsAlertCopyWith<_NewsAlert> get copyWith => __$NewsAlertCopyWithImpl<_NewsAlert>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewsAlertToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsAlert&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.provinceId, provinceId) || other.provinceId == provinceId)&&(identical(other.publishedAt, publishedAt) || other.publishedAt == publishedAt)&&(identical(other.titleEn, titleEn) || other.titleEn == titleEn)&&(identical(other.content, content) || other.content == content)&&(identical(other.contentEn, contentEn) || other.contentEn == contentEn)&&(identical(other.type, type) || other.type == type)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,provinceId,publishedAt,titleEn,content,contentEn,type,imageUrl,isActive);

@override
String toString() {
  return 'NewsAlert(id: $id, title: $title, provinceId: $provinceId, publishedAt: $publishedAt, titleEn: $titleEn, content: $content, contentEn: $contentEn, type: $type, imageUrl: $imageUrl, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$NewsAlertCopyWith<$Res> implements $NewsAlertCopyWith<$Res> {
  factory _$NewsAlertCopyWith(_NewsAlert value, $Res Function(_NewsAlert) _then) = __$NewsAlertCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, int provinceId, DateTime publishedAt, String? titleEn, String? content, String? contentEn, String type, String? imageUrl, bool isActive
});




}
/// @nodoc
class __$NewsAlertCopyWithImpl<$Res>
    implements _$NewsAlertCopyWith<$Res> {
  __$NewsAlertCopyWithImpl(this._self, this._then);

  final _NewsAlert _self;
  final $Res Function(_NewsAlert) _then;

/// Create a copy of NewsAlert
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? provinceId = null,Object? publishedAt = null,Object? titleEn = freezed,Object? content = freezed,Object? contentEn = freezed,Object? type = null,Object? imageUrl = freezed,Object? isActive = null,}) {
  return _then(_NewsAlert(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,provinceId: null == provinceId ? _self.provinceId : provinceId // ignore: cast_nullable_to_non_nullable
as int,publishedAt: null == publishedAt ? _self.publishedAt : publishedAt // ignore: cast_nullable_to_non_nullable
as DateTime,titleEn: freezed == titleEn ? _self.titleEn : titleEn // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,contentEn: freezed == contentEn ? _self.contentEn : contentEn // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

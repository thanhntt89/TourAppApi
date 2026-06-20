// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserStats {

 int get placesVisited; int get audioPlayed; int get articlesRead; int get journeysStarted; int get journeysCompleted; int get totalCheckIns;
/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatsCopyWith<UserStats> get copyWith => _$UserStatsCopyWithImpl<UserStats>(this as UserStats, _$identity);

  /// Serializes this UserStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStats&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited)&&(identical(other.audioPlayed, audioPlayed) || other.audioPlayed == audioPlayed)&&(identical(other.articlesRead, articlesRead) || other.articlesRead == articlesRead)&&(identical(other.journeysStarted, journeysStarted) || other.journeysStarted == journeysStarted)&&(identical(other.journeysCompleted, journeysCompleted) || other.journeysCompleted == journeysCompleted)&&(identical(other.totalCheckIns, totalCheckIns) || other.totalCheckIns == totalCheckIns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,placesVisited,audioPlayed,articlesRead,journeysStarted,journeysCompleted,totalCheckIns);

@override
String toString() {
  return 'UserStats(placesVisited: $placesVisited, audioPlayed: $audioPlayed, articlesRead: $articlesRead, journeysStarted: $journeysStarted, journeysCompleted: $journeysCompleted, totalCheckIns: $totalCheckIns)';
}


}

/// @nodoc
abstract mixin class $UserStatsCopyWith<$Res>  {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) _then) = _$UserStatsCopyWithImpl;
@useResult
$Res call({
 int placesVisited, int audioPlayed, int articlesRead, int journeysStarted, int journeysCompleted, int totalCheckIns
});




}
/// @nodoc
class _$UserStatsCopyWithImpl<$Res>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._self, this._then);

  final UserStats _self;
  final $Res Function(UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? placesVisited = null,Object? audioPlayed = null,Object? articlesRead = null,Object? journeysStarted = null,Object? journeysCompleted = null,Object? totalCheckIns = null,}) {
  return _then(_self.copyWith(
placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,audioPlayed: null == audioPlayed ? _self.audioPlayed : audioPlayed // ignore: cast_nullable_to_non_nullable
as int,articlesRead: null == articlesRead ? _self.articlesRead : articlesRead // ignore: cast_nullable_to_non_nullable
as int,journeysStarted: null == journeysStarted ? _self.journeysStarted : journeysStarted // ignore: cast_nullable_to_non_nullable
as int,journeysCompleted: null == journeysCompleted ? _self.journeysCompleted : journeysCompleted // ignore: cast_nullable_to_non_nullable
as int,totalCheckIns: null == totalCheckIns ? _self.totalCheckIns : totalCheckIns // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStats].
extension UserStatsPatterns on UserStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStats value)  $default,){
final _that = this;
switch (_that) {
case _UserStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStats value)?  $default,){
final _that = this;
switch (_that) {
case _UserStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int placesVisited,  int audioPlayed,  int articlesRead,  int journeysStarted,  int journeysCompleted,  int totalCheckIns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.placesVisited,_that.audioPlayed,_that.articlesRead,_that.journeysStarted,_that.journeysCompleted,_that.totalCheckIns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int placesVisited,  int audioPlayed,  int articlesRead,  int journeysStarted,  int journeysCompleted,  int totalCheckIns)  $default,) {final _that = this;
switch (_that) {
case _UserStats():
return $default(_that.placesVisited,_that.audioPlayed,_that.articlesRead,_that.journeysStarted,_that.journeysCompleted,_that.totalCheckIns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int placesVisited,  int audioPlayed,  int articlesRead,  int journeysStarted,  int journeysCompleted,  int totalCheckIns)?  $default,) {final _that = this;
switch (_that) {
case _UserStats() when $default != null:
return $default(_that.placesVisited,_that.audioPlayed,_that.articlesRead,_that.journeysStarted,_that.journeysCompleted,_that.totalCheckIns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStats implements UserStats {
  const _UserStats({this.placesVisited = 0, this.audioPlayed = 0, this.articlesRead = 0, this.journeysStarted = 0, this.journeysCompleted = 0, this.totalCheckIns = 0});
  factory _UserStats.fromJson(Map<String, dynamic> json) => _$UserStatsFromJson(json);

@override@JsonKey() final  int placesVisited;
@override@JsonKey() final  int audioPlayed;
@override@JsonKey() final  int articlesRead;
@override@JsonKey() final  int journeysStarted;
@override@JsonKey() final  int journeysCompleted;
@override@JsonKey() final  int totalCheckIns;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatsCopyWith<_UserStats> get copyWith => __$UserStatsCopyWithImpl<_UserStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStats&&(identical(other.placesVisited, placesVisited) || other.placesVisited == placesVisited)&&(identical(other.audioPlayed, audioPlayed) || other.audioPlayed == audioPlayed)&&(identical(other.articlesRead, articlesRead) || other.articlesRead == articlesRead)&&(identical(other.journeysStarted, journeysStarted) || other.journeysStarted == journeysStarted)&&(identical(other.journeysCompleted, journeysCompleted) || other.journeysCompleted == journeysCompleted)&&(identical(other.totalCheckIns, totalCheckIns) || other.totalCheckIns == totalCheckIns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,placesVisited,audioPlayed,articlesRead,journeysStarted,journeysCompleted,totalCheckIns);

@override
String toString() {
  return 'UserStats(placesVisited: $placesVisited, audioPlayed: $audioPlayed, articlesRead: $articlesRead, journeysStarted: $journeysStarted, journeysCompleted: $journeysCompleted, totalCheckIns: $totalCheckIns)';
}


}

/// @nodoc
abstract mixin class _$UserStatsCopyWith<$Res> implements $UserStatsCopyWith<$Res> {
  factory _$UserStatsCopyWith(_UserStats value, $Res Function(_UserStats) _then) = __$UserStatsCopyWithImpl;
@override @useResult
$Res call({
 int placesVisited, int audioPlayed, int articlesRead, int journeysStarted, int journeysCompleted, int totalCheckIns
});




}
/// @nodoc
class __$UserStatsCopyWithImpl<$Res>
    implements _$UserStatsCopyWith<$Res> {
  __$UserStatsCopyWithImpl(this._self, this._then);

  final _UserStats _self;
  final $Res Function(_UserStats) _then;

/// Create a copy of UserStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? placesVisited = null,Object? audioPlayed = null,Object? articlesRead = null,Object? journeysStarted = null,Object? journeysCompleted = null,Object? totalCheckIns = null,}) {
  return _then(_UserStats(
placesVisited: null == placesVisited ? _self.placesVisited : placesVisited // ignore: cast_nullable_to_non_nullable
as int,audioPlayed: null == audioPlayed ? _self.audioPlayed : audioPlayed // ignore: cast_nullable_to_non_nullable
as int,articlesRead: null == articlesRead ? _self.articlesRead : articlesRead // ignore: cast_nullable_to_non_nullable
as int,journeysStarted: null == journeysStarted ? _self.journeysStarted : journeysStarted // ignore: cast_nullable_to_non_nullable
as int,journeysCompleted: null == journeysCompleted ? _self.journeysCompleted : journeysCompleted // ignore: cast_nullable_to_non_nullable
as int,totalCheckIns: null == totalCheckIns ? _self.totalCheckIns : totalCheckIns // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeState {

 HomeLoadingStatus get loadingStatus; String get msg; List<dynamic> get transactions; Hometype get hometype;
/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeStateCopyWith<HomeState> get copyWith => _$HomeStateCopyWithImpl<HomeState>(this as HomeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg)&&const DeepCollectionEquality().equals(other.transactions, transactions)&&(identical(other.hometype, hometype) || other.hometype == hometype));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,msg,const DeepCollectionEquality().hash(transactions),hometype);

@override
String toString() {
  return 'HomeState(loadingStatus: $loadingStatus, msg: $msg, transactions: $transactions, hometype: $hometype)';
}


}

/// @nodoc
abstract mixin class $HomeStateCopyWith<$Res>  {
  factory $HomeStateCopyWith(HomeState value, $Res Function(HomeState) _then) = _$HomeStateCopyWithImpl;
@useResult
$Res call({
 HomeLoadingStatus loadingStatus, String msg, List<dynamic> transactions, Hometype hometype
});




}
/// @nodoc
class _$HomeStateCopyWithImpl<$Res>
    implements $HomeStateCopyWith<$Res> {
  _$HomeStateCopyWithImpl(this._self, this._then);

  final HomeState _self;
  final $Res Function(HomeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStatus = null,Object? msg = null,Object? transactions = null,Object? hometype = null,}) {
  return _then(_self.copyWith(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as HomeLoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<dynamic>,hometype: null == hometype ? _self.hometype : hometype // ignore: cast_nullable_to_non_nullable
as Hometype,
  ));
}

}


/// Adds pattern-matching-related methods to [HomeState].
extension HomeStatePatterns on HomeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _homeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _homeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _homeState value)  $default,){
final _that = this;
switch (_that) {
case _homeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _homeState value)?  $default,){
final _that = this;
switch (_that) {
case _homeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( HomeLoadingStatus loadingStatus,  String msg,  List<dynamic> transactions,  Hometype hometype)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _homeState() when $default != null:
return $default(_that.loadingStatus,_that.msg,_that.transactions,_that.hometype);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( HomeLoadingStatus loadingStatus,  String msg,  List<dynamic> transactions,  Hometype hometype)  $default,) {final _that = this;
switch (_that) {
case _homeState():
return $default(_that.loadingStatus,_that.msg,_that.transactions,_that.hometype);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( HomeLoadingStatus loadingStatus,  String msg,  List<dynamic> transactions,  Hometype hometype)?  $default,) {final _that = this;
switch (_that) {
case _homeState() when $default != null:
return $default(_that.loadingStatus,_that.msg,_that.transactions,_that.hometype);case _:
  return null;

}
}

}

/// @nodoc


class _homeState implements HomeState {
  const _homeState({this.loadingStatus = HomeLoadingStatus.none, this.msg = '', final  List<dynamic> transactions = const [], this.hometype = Hometype.none}): _transactions = transactions;
  

@override@JsonKey() final  HomeLoadingStatus loadingStatus;
@override@JsonKey() final  String msg;
 final  List<dynamic> _transactions;
@override@JsonKey() List<dynamic> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

@override@JsonKey() final  Hometype hometype;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$homeStateCopyWith<_homeState> get copyWith => __$homeStateCopyWithImpl<_homeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _homeState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg)&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.hometype, hometype) || other.hometype == hometype));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,msg,const DeepCollectionEquality().hash(_transactions),hometype);

@override
String toString() {
  return 'HomeState(loadingStatus: $loadingStatus, msg: $msg, transactions: $transactions, hometype: $hometype)';
}


}

/// @nodoc
abstract mixin class _$homeStateCopyWith<$Res> implements $HomeStateCopyWith<$Res> {
  factory _$homeStateCopyWith(_homeState value, $Res Function(_homeState) _then) = __$homeStateCopyWithImpl;
@override @useResult
$Res call({
 HomeLoadingStatus loadingStatus, String msg, List<dynamic> transactions, Hometype hometype
});




}
/// @nodoc
class __$homeStateCopyWithImpl<$Res>
    implements _$homeStateCopyWith<$Res> {
  __$homeStateCopyWithImpl(this._self, this._then);

  final _homeState _self;
  final $Res Function(_homeState) _then;

/// Create a copy of HomeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStatus = null,Object? msg = null,Object? transactions = null,Object? hometype = null,}) {
  return _then(_homeState(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as HomeLoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<dynamic>,hometype: null == hometype ? _self.hometype : hometype // ignore: cast_nullable_to_non_nullable
as Hometype,
  ));
}


}

/// @nodoc
mixin _$HomeEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent()';
}


}

/// @nodoc
class $HomeEventCopyWith<$Res>  {
$HomeEventCopyWith(HomeEvent _, $Res Function(HomeEvent) __);
}


/// Adds pattern-matching-related methods to [HomeEvent].
extension HomeEventPatterns on HomeEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( fetchsmsTransactions value)?  FetchsmsTransactions,TResult Function( refreshsmsTransactions value)?  RefreshsmsTransactions,TResult Function( fetchAppUsername value)?  FetchAppUsername,required TResult orElse(),}){
final _that = this;
switch (_that) {
case fetchsmsTransactions() when FetchsmsTransactions != null:
return FetchsmsTransactions(_that);case refreshsmsTransactions() when RefreshsmsTransactions != null:
return RefreshsmsTransactions(_that);case fetchAppUsername() when FetchAppUsername != null:
return FetchAppUsername(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( fetchsmsTransactions value)  FetchsmsTransactions,required TResult Function( refreshsmsTransactions value)  RefreshsmsTransactions,required TResult Function( fetchAppUsername value)  FetchAppUsername,}){
final _that = this;
switch (_that) {
case fetchsmsTransactions():
return FetchsmsTransactions(_that);case refreshsmsTransactions():
return RefreshsmsTransactions(_that);case fetchAppUsername():
return FetchAppUsername(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( fetchsmsTransactions value)?  FetchsmsTransactions,TResult? Function( refreshsmsTransactions value)?  RefreshsmsTransactions,TResult? Function( fetchAppUsername value)?  FetchAppUsername,}){
final _that = this;
switch (_that) {
case fetchsmsTransactions() when FetchsmsTransactions != null:
return FetchsmsTransactions(_that);case refreshsmsTransactions() when RefreshsmsTransactions != null:
return RefreshsmsTransactions(_that);case fetchAppUsername() when FetchAppUsername != null:
return FetchAppUsername(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  FetchsmsTransactions,TResult Function()?  RefreshsmsTransactions,TResult Function( String uid)?  FetchAppUsername,required TResult orElse(),}) {final _that = this;
switch (_that) {
case fetchsmsTransactions() when FetchsmsTransactions != null:
return FetchsmsTransactions();case refreshsmsTransactions() when RefreshsmsTransactions != null:
return RefreshsmsTransactions();case fetchAppUsername() when FetchAppUsername != null:
return FetchAppUsername(_that.uid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  FetchsmsTransactions,required TResult Function()  RefreshsmsTransactions,required TResult Function( String uid)  FetchAppUsername,}) {final _that = this;
switch (_that) {
case fetchsmsTransactions():
return FetchsmsTransactions();case refreshsmsTransactions():
return RefreshsmsTransactions();case fetchAppUsername():
return FetchAppUsername(_that.uid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  FetchsmsTransactions,TResult? Function()?  RefreshsmsTransactions,TResult? Function( String uid)?  FetchAppUsername,}) {final _that = this;
switch (_that) {
case fetchsmsTransactions() when FetchsmsTransactions != null:
return FetchsmsTransactions();case refreshsmsTransactions() when RefreshsmsTransactions != null:
return RefreshsmsTransactions();case fetchAppUsername() when FetchAppUsername != null:
return FetchAppUsername(_that.uid);case _:
  return null;

}
}

}

/// @nodoc


class fetchsmsTransactions implements HomeEvent {
  const fetchsmsTransactions();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is fetchsmsTransactions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.FetchsmsTransactions()';
}


}




/// @nodoc


class refreshsmsTransactions implements HomeEvent {
  const refreshsmsTransactions();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is refreshsmsTransactions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'HomeEvent.RefreshsmsTransactions()';
}


}




/// @nodoc


class fetchAppUsername implements HomeEvent {
  const fetchAppUsername(this.uid);
  

 final  String uid;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$fetchAppUsernameCopyWith<fetchAppUsername> get copyWith => _$fetchAppUsernameCopyWithImpl<fetchAppUsername>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is fetchAppUsername&&(identical(other.uid, uid) || other.uid == uid));
}


@override
int get hashCode => Object.hash(runtimeType,uid);

@override
String toString() {
  return 'HomeEvent.FetchAppUsername(uid: $uid)';
}


}

/// @nodoc
abstract mixin class $fetchAppUsernameCopyWith<$Res> implements $HomeEventCopyWith<$Res> {
  factory $fetchAppUsernameCopyWith(fetchAppUsername value, $Res Function(fetchAppUsername) _then) = _$fetchAppUsernameCopyWithImpl;
@useResult
$Res call({
 String uid
});




}
/// @nodoc
class _$fetchAppUsernameCopyWithImpl<$Res>
    implements $fetchAppUsernameCopyWith<$Res> {
  _$fetchAppUsernameCopyWithImpl(this._self, this._then);

  final fetchAppUsername _self;
  final $Res Function(fetchAppUsername) _then;

/// Create a copy of HomeEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? uid = null,}) {
  return _then(fetchAppUsername(
null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

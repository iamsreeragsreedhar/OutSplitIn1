// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'addtrans_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AddtransState {

 LoadingStatus get loadingStatus; String get msg; type get hometype;
/// Create a copy of AddtransState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddtransStateCopyWith<AddtransState> get copyWith => _$AddtransStateCopyWithImpl<AddtransState>(this as AddtransState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddtransState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.hometype, hometype) || other.hometype == hometype));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,msg,hometype);

@override
String toString() {
  return 'AddtransState(loadingStatus: $loadingStatus, msg: $msg, hometype: $hometype)';
}


}

/// @nodoc
abstract mixin class $AddtransStateCopyWith<$Res>  {
  factory $AddtransStateCopyWith(AddtransState value, $Res Function(AddtransState) _then) = _$AddtransStateCopyWithImpl;
@useResult
$Res call({
 LoadingStatus loadingStatus, String msg, type hometype
});




}
/// @nodoc
class _$AddtransStateCopyWithImpl<$Res>
    implements $AddtransStateCopyWith<$Res> {
  _$AddtransStateCopyWithImpl(this._self, this._then);

  final AddtransState _self;
  final $Res Function(AddtransState) _then;

/// Create a copy of AddtransState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStatus = null,Object? msg = null,Object? hometype = null,}) {
  return _then(_self.copyWith(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as LoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,hometype: null == hometype ? _self.hometype : hometype // ignore: cast_nullable_to_non_nullable
as type,
  ));
}

}


/// Adds pattern-matching-related methods to [AddtransState].
extension AddtransStatePatterns on AddtransState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( addtransState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case addtransState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( addtransState value)  $default,){
final _that = this;
switch (_that) {
case addtransState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( addtransState value)?  $default,){
final _that = this;
switch (_that) {
case addtransState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LoadingStatus loadingStatus,  String msg,  type hometype)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case addtransState() when $default != null:
return $default(_that.loadingStatus,_that.msg,_that.hometype);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LoadingStatus loadingStatus,  String msg,  type hometype)  $default,) {final _that = this;
switch (_that) {
case addtransState():
return $default(_that.loadingStatus,_that.msg,_that.hometype);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LoadingStatus loadingStatus,  String msg,  type hometype)?  $default,) {final _that = this;
switch (_that) {
case addtransState() when $default != null:
return $default(_that.loadingStatus,_that.msg,_that.hometype);case _:
  return null;

}
}

}

/// @nodoc


class addtransState implements AddtransState {
  const addtransState({this.loadingStatus = LoadingStatus.none, this.msg = '', this.hometype = type.none});
  

@override@JsonKey() final  LoadingStatus loadingStatus;
@override@JsonKey() final  String msg;
@override@JsonKey() final  type hometype;

/// Create a copy of AddtransState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$addtransStateCopyWith<addtransState> get copyWith => _$addtransStateCopyWithImpl<addtransState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is addtransState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.hometype, hometype) || other.hometype == hometype));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,msg,hometype);

@override
String toString() {
  return 'AddtransState(loadingStatus: $loadingStatus, msg: $msg, hometype: $hometype)';
}


}

/// @nodoc
abstract mixin class $addtransStateCopyWith<$Res> implements $AddtransStateCopyWith<$Res> {
  factory $addtransStateCopyWith(addtransState value, $Res Function(addtransState) _then) = _$addtransStateCopyWithImpl;
@override @useResult
$Res call({
 LoadingStatus loadingStatus, String msg, type hometype
});




}
/// @nodoc
class _$addtransStateCopyWithImpl<$Res>
    implements $addtransStateCopyWith<$Res> {
  _$addtransStateCopyWithImpl(this._self, this._then);

  final addtransState _self;
  final $Res Function(addtransState) _then;

/// Create a copy of AddtransState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStatus = null,Object? msg = null,Object? hometype = null,}) {
  return _then(addtransState(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as LoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,hometype: null == hometype ? _self.hometype : hometype // ignore: cast_nullable_to_non_nullable
as type,
  ));
}


}

/// @nodoc
mixin _$AddtransEvent {

 TransactionModel get model;
/// Create a copy of AddtransEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddtransEventCopyWith<AddtransEvent> get copyWith => _$AddtransEventCopyWithImpl<AddtransEvent>(this as AddtransEvent, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddtransEvent&&(identical(other.model, model) || other.model == model));
}


@override
int get hashCode => Object.hash(runtimeType,model);

@override
String toString() {
  return 'AddtransEvent(model: $model)';
}


}

/// @nodoc
abstract mixin class $AddtransEventCopyWith<$Res>  {
  factory $AddtransEventCopyWith(AddtransEvent value, $Res Function(AddtransEvent) _then) = _$AddtransEventCopyWithImpl;
@useResult
$Res call({
 TransactionModel model
});




}
/// @nodoc
class _$AddtransEventCopyWithImpl<$Res>
    implements $AddtransEventCopyWith<$Res> {
  _$AddtransEventCopyWithImpl(this._self, this._then);

  final AddtransEvent _self;
  final $Res Function(AddtransEvent) _then;

/// Create a copy of AddtransEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,}) {
  return _then(_self.copyWith(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as TransactionModel,
  ));
}

}


/// Adds pattern-matching-related methods to [AddtransEvent].
extension AddtransEventPatterns on AddtransEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( addTransaction value)?  AddTransaction,required TResult orElse(),}){
final _that = this;
switch (_that) {
case addTransaction() when AddTransaction != null:
return AddTransaction(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( addTransaction value)  AddTransaction,}){
final _that = this;
switch (_that) {
case addTransaction():
return AddTransaction(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( addTransaction value)?  AddTransaction,}){
final _that = this;
switch (_that) {
case addTransaction() when AddTransaction != null:
return AddTransaction(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( TransactionModel model)?  AddTransaction,required TResult orElse(),}) {final _that = this;
switch (_that) {
case addTransaction() when AddTransaction != null:
return AddTransaction(_that.model);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( TransactionModel model)  AddTransaction,}) {final _that = this;
switch (_that) {
case addTransaction():
return AddTransaction(_that.model);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( TransactionModel model)?  AddTransaction,}) {final _that = this;
switch (_that) {
case addTransaction() when AddTransaction != null:
return AddTransaction(_that.model);case _:
  return null;

}
}

}

/// @nodoc


class addTransaction implements AddtransEvent {
  const addTransaction(this.model);
  

@override final  TransactionModel model;

/// Create a copy of AddtransEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$addTransactionCopyWith<addTransaction> get copyWith => _$addTransactionCopyWithImpl<addTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is addTransaction&&(identical(other.model, model) || other.model == model));
}


@override
int get hashCode => Object.hash(runtimeType,model);

@override
String toString() {
  return 'AddtransEvent.AddTransaction(model: $model)';
}


}

/// @nodoc
abstract mixin class $addTransactionCopyWith<$Res> implements $AddtransEventCopyWith<$Res> {
  factory $addTransactionCopyWith(addTransaction value, $Res Function(addTransaction) _then) = _$addTransactionCopyWithImpl;
@override @useResult
$Res call({
 TransactionModel model
});




}
/// @nodoc
class _$addTransactionCopyWithImpl<$Res>
    implements $addTransactionCopyWith<$Res> {
  _$addTransactionCopyWithImpl(this._self, this._then);

  final addTransaction _self;
  final $Res Function(addTransaction) _then;

/// Create a copy of AddtransEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,}) {
  return _then(addTransaction(
null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as TransactionModel,
  ));
}


}

// dart format on

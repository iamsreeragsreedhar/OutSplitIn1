// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

 Authtype get authtype; AuthLoadingStatus get loadingStatus; String get msg;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.authtype, authtype) || other.authtype == authtype)&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg));
}


@override
int get hashCode => Object.hash(runtimeType,authtype,loadingStatus,msg);

@override
String toString() {
  return 'AuthState(authtype: $authtype, loadingStatus: $loadingStatus, msg: $msg)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 Authtype authtype, AuthLoadingStatus loadingStatus, String msg
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? authtype = null,Object? loadingStatus = null,Object? msg = null,}) {
  return _then(_self.copyWith(
authtype: null == authtype ? _self.authtype : authtype // ignore: cast_nullable_to_non_nullable
as Authtype,loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as AuthLoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _authState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _authState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _authState value)  $default,){
final _that = this;
switch (_that) {
case _authState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _authState value)?  $default,){
final _that = this;
switch (_that) {
case _authState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Authtype authtype,  AuthLoadingStatus loadingStatus,  String msg)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _authState() when $default != null:
return $default(_that.authtype,_that.loadingStatus,_that.msg);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Authtype authtype,  AuthLoadingStatus loadingStatus,  String msg)  $default,) {final _that = this;
switch (_that) {
case _authState():
return $default(_that.authtype,_that.loadingStatus,_that.msg);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Authtype authtype,  AuthLoadingStatus loadingStatus,  String msg)?  $default,) {final _that = this;
switch (_that) {
case _authState() when $default != null:
return $default(_that.authtype,_that.loadingStatus,_that.msg);case _:
  return null;

}
}

}

/// @nodoc


class _authState implements AuthState {
  const _authState({this.authtype = Authtype.none, this.loadingStatus = AuthLoadingStatus.none, this.msg = ''});
  

@override@JsonKey() final  Authtype authtype;
@override@JsonKey() final  AuthLoadingStatus loadingStatus;
@override@JsonKey() final  String msg;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$authStateCopyWith<_authState> get copyWith => __$authStateCopyWithImpl<_authState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _authState&&(identical(other.authtype, authtype) || other.authtype == authtype)&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg));
}


@override
int get hashCode => Object.hash(runtimeType,authtype,loadingStatus,msg);

@override
String toString() {
  return 'AuthState(authtype: $authtype, loadingStatus: $loadingStatus, msg: $msg)';
}


}

/// @nodoc
abstract mixin class _$authStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$authStateCopyWith(_authState value, $Res Function(_authState) _then) = __$authStateCopyWithImpl;
@override @useResult
$Res call({
 Authtype authtype, AuthLoadingStatus loadingStatus, String msg
});




}
/// @nodoc
class __$authStateCopyWithImpl<$Res>
    implements _$authStateCopyWith<$Res> {
  __$authStateCopyWithImpl(this._self, this._then);

  final _authState _self;
  final $Res Function(_authState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? authtype = null,Object? loadingStatus = null,Object? msg = null,}) {
  return _then(_authState(
authtype: null == authtype ? _self.authtype : authtype // ignore: cast_nullable_to_non_nullable
as Authtype,loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as AuthLoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$AuthEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent()';
}


}

/// @nodoc
class $AuthEventCopyWith<$Res>  {
$AuthEventCopyWith(AuthEvent _, $Res Function(AuthEvent) __);
}


/// Adds pattern-matching-related methods to [AuthEvent].
extension AuthEventPatterns on AuthEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignupPressed value)?  signupPressed,TResult Function( LoginPressed value)?  loginPressed,TResult Function( GoogleSignIn value)?  googleSignIn,TResult Function( Logout value)?  logout,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignupPressed() when signupPressed != null:
return signupPressed(_that);case LoginPressed() when loginPressed != null:
return loginPressed(_that);case GoogleSignIn() when googleSignIn != null:
return googleSignIn(_that);case Logout() when logout != null:
return logout(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignupPressed value)  signupPressed,required TResult Function( LoginPressed value)  loginPressed,required TResult Function( GoogleSignIn value)  googleSignIn,required TResult Function( Logout value)  logout,}){
final _that = this;
switch (_that) {
case SignupPressed():
return signupPressed(_that);case LoginPressed():
return loginPressed(_that);case GoogleSignIn():
return googleSignIn(_that);case Logout():
return logout(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignupPressed value)?  signupPressed,TResult? Function( LoginPressed value)?  loginPressed,TResult? Function( GoogleSignIn value)?  googleSignIn,TResult? Function( Logout value)?  logout,}){
final _that = this;
switch (_that) {
case SignupPressed() when signupPressed != null:
return signupPressed(_that);case LoginPressed() when loginPressed != null:
return loginPressed(_that);case GoogleSignIn() when googleSignIn != null:
return googleSignIn(_that);case Logout() when logout != null:
return logout(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String email,  String password,  String displayname)?  signupPressed,TResult Function( String email,  String password)?  loginPressed,TResult Function()?  googleSignIn,TResult Function()?  logout,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignupPressed() when signupPressed != null:
return signupPressed(_that.email,_that.password,_that.displayname);case LoginPressed() when loginPressed != null:
return loginPressed(_that.email,_that.password);case GoogleSignIn() when googleSignIn != null:
return googleSignIn();case Logout() when logout != null:
return logout();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String email,  String password,  String displayname)  signupPressed,required TResult Function( String email,  String password)  loginPressed,required TResult Function()  googleSignIn,required TResult Function()  logout,}) {final _that = this;
switch (_that) {
case SignupPressed():
return signupPressed(_that.email,_that.password,_that.displayname);case LoginPressed():
return loginPressed(_that.email,_that.password);case GoogleSignIn():
return googleSignIn();case Logout():
return logout();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String email,  String password,  String displayname)?  signupPressed,TResult? Function( String email,  String password)?  loginPressed,TResult? Function()?  googleSignIn,TResult? Function()?  logout,}) {final _that = this;
switch (_that) {
case SignupPressed() when signupPressed != null:
return signupPressed(_that.email,_that.password,_that.displayname);case LoginPressed() when loginPressed != null:
return loginPressed(_that.email,_that.password);case GoogleSignIn() when googleSignIn != null:
return googleSignIn();case Logout() when logout != null:
return logout();case _:
  return null;

}
}

}

/// @nodoc


class SignupPressed implements AuthEvent {
  const SignupPressed(this.email, this.password, this.displayname);
  

 final  String email;
 final  String password;
 final  String displayname;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupPressedCopyWith<SignupPressed> get copyWith => _$SignupPressedCopyWithImpl<SignupPressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupPressed&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password)&&(identical(other.displayname, displayname) || other.displayname == displayname));
}


@override
int get hashCode => Object.hash(runtimeType,email,password,displayname);

@override
String toString() {
  return 'AuthEvent.signupPressed(email: $email, password: $password, displayname: $displayname)';
}


}

/// @nodoc
abstract mixin class $SignupPressedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $SignupPressedCopyWith(SignupPressed value, $Res Function(SignupPressed) _then) = _$SignupPressedCopyWithImpl;
@useResult
$Res call({
 String email, String password, String displayname
});




}
/// @nodoc
class _$SignupPressedCopyWithImpl<$Res>
    implements $SignupPressedCopyWith<$Res> {
  _$SignupPressedCopyWithImpl(this._self, this._then);

  final SignupPressed _self;
  final $Res Function(SignupPressed) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,Object? displayname = null,}) {
  return _then(SignupPressed(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,null == displayname ? _self.displayname : displayname // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class LoginPressed implements AuthEvent {
  const LoginPressed(this.email, this.password);
  

 final  String email;
 final  String password;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginPressedCopyWith<LoginPressed> get copyWith => _$LoginPressedCopyWithImpl<LoginPressed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginPressed&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'AuthEvent.loginPressed(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginPressedCopyWith<$Res> implements $AuthEventCopyWith<$Res> {
  factory $LoginPressedCopyWith(LoginPressed value, $Res Function(LoginPressed) _then) = _$LoginPressedCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$LoginPressedCopyWithImpl<$Res>
    implements $LoginPressedCopyWith<$Res> {
  _$LoginPressedCopyWithImpl(this._self, this._then);

  final LoginPressed _self;
  final $Res Function(LoginPressed) _then;

/// Create a copy of AuthEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(LoginPressed(
null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class GoogleSignIn implements AuthEvent {
  const GoogleSignIn();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GoogleSignIn);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.googleSignIn()';
}


}




/// @nodoc


class Logout implements AuthEvent {
  const Logout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Logout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AuthEvent.logout()';
}


}




// dart format on

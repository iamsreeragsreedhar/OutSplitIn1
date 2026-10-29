// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileState implements DiagnosticableTreeMixin {

 ProfileLoadingStatus get loadingStatus; String get msg; Profiletype get profiletype;
/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileStateCopyWith<ProfileState> get copyWith => _$ProfileStateCopyWithImpl<ProfileState>(this as ProfileState, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileState'))
    ..add(DiagnosticsProperty('loadingStatus', loadingStatus))..add(DiagnosticsProperty('msg', msg))..add(DiagnosticsProperty('profiletype', profiletype));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.profiletype, profiletype) || other.profiletype == profiletype));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,msg,profiletype);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileState(loadingStatus: $loadingStatus, msg: $msg, profiletype: $profiletype)';
}


}

/// @nodoc
abstract mixin class $ProfileStateCopyWith<$Res>  {
  factory $ProfileStateCopyWith(ProfileState value, $Res Function(ProfileState) _then) = _$ProfileStateCopyWithImpl;
@useResult
$Res call({
 ProfileLoadingStatus loadingStatus, String msg, Profiletype profiletype
});




}
/// @nodoc
class _$ProfileStateCopyWithImpl<$Res>
    implements $ProfileStateCopyWith<$Res> {
  _$ProfileStateCopyWithImpl(this._self, this._then);

  final ProfileState _self;
  final $Res Function(ProfileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loadingStatus = null,Object? msg = null,Object? profiletype = null,}) {
  return _then(_self.copyWith(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as ProfileLoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,profiletype: null == profiletype ? _self.profiletype : profiletype // ignore: cast_nullable_to_non_nullable
as Profiletype,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileState].
extension ProfileStatePatterns on ProfileState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( profileState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case profileState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( profileState value)  $default,){
final _that = this;
switch (_that) {
case profileState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( profileState value)?  $default,){
final _that = this;
switch (_that) {
case profileState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProfileLoadingStatus loadingStatus,  String msg,  Profiletype profiletype)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case profileState() when $default != null:
return $default(_that.loadingStatus,_that.msg,_that.profiletype);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProfileLoadingStatus loadingStatus,  String msg,  Profiletype profiletype)  $default,) {final _that = this;
switch (_that) {
case profileState():
return $default(_that.loadingStatus,_that.msg,_that.profiletype);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProfileLoadingStatus loadingStatus,  String msg,  Profiletype profiletype)?  $default,) {final _that = this;
switch (_that) {
case profileState() when $default != null:
return $default(_that.loadingStatus,_that.msg,_that.profiletype);case _:
  return null;

}
}

}

/// @nodoc


class profileState with DiagnosticableTreeMixin implements ProfileState {
  const profileState({this.loadingStatus = ProfileLoadingStatus.none, this.msg = '', this.profiletype = Profiletype.none});
  

@override@JsonKey() final  ProfileLoadingStatus loadingStatus;
@override@JsonKey() final  String msg;
@override@JsonKey() final  Profiletype profiletype;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$profileStateCopyWith<profileState> get copyWith => _$profileStateCopyWithImpl<profileState>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileState'))
    ..add(DiagnosticsProperty('loadingStatus', loadingStatus))..add(DiagnosticsProperty('msg', msg))..add(DiagnosticsProperty('profiletype', profiletype));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is profileState&&(identical(other.loadingStatus, loadingStatus) || other.loadingStatus == loadingStatus)&&(identical(other.msg, msg) || other.msg == msg)&&(identical(other.profiletype, profiletype) || other.profiletype == profiletype));
}


@override
int get hashCode => Object.hash(runtimeType,loadingStatus,msg,profiletype);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileState(loadingStatus: $loadingStatus, msg: $msg, profiletype: $profiletype)';
}


}

/// @nodoc
abstract mixin class $profileStateCopyWith<$Res> implements $ProfileStateCopyWith<$Res> {
  factory $profileStateCopyWith(profileState value, $Res Function(profileState) _then) = _$profileStateCopyWithImpl;
@override @useResult
$Res call({
 ProfileLoadingStatus loadingStatus, String msg, Profiletype profiletype
});




}
/// @nodoc
class _$profileStateCopyWithImpl<$Res>
    implements $profileStateCopyWith<$Res> {
  _$profileStateCopyWithImpl(this._self, this._then);

  final profileState _self;
  final $Res Function(profileState) _then;

/// Create a copy of ProfileState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loadingStatus = null,Object? msg = null,Object? profiletype = null,}) {
  return _then(profileState(
loadingStatus: null == loadingStatus ? _self.loadingStatus : loadingStatus // ignore: cast_nullable_to_non_nullable
as ProfileLoadingStatus,msg: null == msg ? _self.msg : msg // ignore: cast_nullable_to_non_nullable
as String,profiletype: null == profiletype ? _self.profiletype : profiletype // ignore: cast_nullable_to_non_nullable
as Profiletype,
  ));
}


}

/// @nodoc
mixin _$ProfileEvent implements DiagnosticableTreeMixin {




@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileEvent'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileEvent()';
}


}

/// @nodoc
class $ProfileEventCopyWith<$Res>  {
$ProfileEventCopyWith(ProfileEvent _, $Res Function(ProfileEvent) __);
}


/// Adds pattern-matching-related methods to [ProfileEvent].
extension ProfileEventPatterns on ProfileEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FetchProfileData value)?  fetchProfileData,TResult Function( UpdateProfileData value)?  updateProfileData,TResult Function( UpdateProfileImage value)?  updateProfileImage,TResult Function( MessageSync value)?  messageSync,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FetchProfileData() when fetchProfileData != null:
return fetchProfileData(_that);case UpdateProfileData() when updateProfileData != null:
return updateProfileData(_that);case UpdateProfileImage() when updateProfileImage != null:
return updateProfileImage(_that);case MessageSync() when messageSync != null:
return messageSync(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FetchProfileData value)  fetchProfileData,required TResult Function( UpdateProfileData value)  updateProfileData,required TResult Function( UpdateProfileImage value)  updateProfileImage,required TResult Function( MessageSync value)  messageSync,}){
final _that = this;
switch (_that) {
case FetchProfileData():
return fetchProfileData(_that);case UpdateProfileData():
return updateProfileData(_that);case UpdateProfileImage():
return updateProfileImage(_that);case MessageSync():
return messageSync(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FetchProfileData value)?  fetchProfileData,TResult? Function( UpdateProfileData value)?  updateProfileData,TResult? Function( UpdateProfileImage value)?  updateProfileImage,TResult? Function( MessageSync value)?  messageSync,}){
final _that = this;
switch (_that) {
case FetchProfileData() when fetchProfileData != null:
return fetchProfileData(_that);case UpdateProfileData() when updateProfileData != null:
return updateProfileData(_that);case UpdateProfileImage() when updateProfileImage != null:
return updateProfileImage(_that);case MessageSync() when messageSync != null:
return messageSync(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  fetchProfileData,TResult Function( String name,  String email)?  updateProfileData,TResult Function( String imagePath)?  updateProfileImage,TResult Function( bool enabled)?  messageSync,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FetchProfileData() when fetchProfileData != null:
return fetchProfileData();case UpdateProfileData() when updateProfileData != null:
return updateProfileData(_that.name,_that.email);case UpdateProfileImage() when updateProfileImage != null:
return updateProfileImage(_that.imagePath);case MessageSync() when messageSync != null:
return messageSync(_that.enabled);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  fetchProfileData,required TResult Function( String name,  String email)  updateProfileData,required TResult Function( String imagePath)  updateProfileImage,required TResult Function( bool enabled)  messageSync,}) {final _that = this;
switch (_that) {
case FetchProfileData():
return fetchProfileData();case UpdateProfileData():
return updateProfileData(_that.name,_that.email);case UpdateProfileImage():
return updateProfileImage(_that.imagePath);case MessageSync():
return messageSync(_that.enabled);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  fetchProfileData,TResult? Function( String name,  String email)?  updateProfileData,TResult? Function( String imagePath)?  updateProfileImage,TResult? Function( bool enabled)?  messageSync,}) {final _that = this;
switch (_that) {
case FetchProfileData() when fetchProfileData != null:
return fetchProfileData();case UpdateProfileData() when updateProfileData != null:
return updateProfileData(_that.name,_that.email);case UpdateProfileImage() when updateProfileImage != null:
return updateProfileImage(_that.imagePath);case MessageSync() when messageSync != null:
return messageSync(_that.enabled);case _:
  return null;

}
}

}

/// @nodoc


class FetchProfileData with DiagnosticableTreeMixin implements ProfileEvent {
  const FetchProfileData();
  





@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileEvent.fetchProfileData'))
    ;
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FetchProfileData);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileEvent.fetchProfileData()';
}


}




/// @nodoc


class UpdateProfileData with DiagnosticableTreeMixin implements ProfileEvent {
  const UpdateProfileData(this.name, this.email);
  

 final  String name;
 final  String email;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileDataCopyWith<UpdateProfileData> get copyWith => _$UpdateProfileDataCopyWithImpl<UpdateProfileData>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileEvent.updateProfileData'))
    ..add(DiagnosticsProperty('name', name))..add(DiagnosticsProperty('email', email));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfileData&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email));
}


@override
int get hashCode => Object.hash(runtimeType,name,email);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileEvent.updateProfileData(name: $name, email: $email)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileDataCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $UpdateProfileDataCopyWith(UpdateProfileData value, $Res Function(UpdateProfileData) _then) = _$UpdateProfileDataCopyWithImpl;
@useResult
$Res call({
 String name, String email
});




}
/// @nodoc
class _$UpdateProfileDataCopyWithImpl<$Res>
    implements $UpdateProfileDataCopyWith<$Res> {
  _$UpdateProfileDataCopyWithImpl(this._self, this._then);

  final UpdateProfileData _self;
  final $Res Function(UpdateProfileData) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,}) {
  return _then(UpdateProfileData(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UpdateProfileImage with DiagnosticableTreeMixin implements ProfileEvent {
  const UpdateProfileImage(this.imagePath);
  

 final  String imagePath;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProfileImageCopyWith<UpdateProfileImage> get copyWith => _$UpdateProfileImageCopyWithImpl<UpdateProfileImage>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileEvent.updateProfileImage'))
    ..add(DiagnosticsProperty('imagePath', imagePath));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProfileImage&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath));
}


@override
int get hashCode => Object.hash(runtimeType,imagePath);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileEvent.updateProfileImage(imagePath: $imagePath)';
}


}

/// @nodoc
abstract mixin class $UpdateProfileImageCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $UpdateProfileImageCopyWith(UpdateProfileImage value, $Res Function(UpdateProfileImage) _then) = _$UpdateProfileImageCopyWithImpl;
@useResult
$Res call({
 String imagePath
});




}
/// @nodoc
class _$UpdateProfileImageCopyWithImpl<$Res>
    implements $UpdateProfileImageCopyWith<$Res> {
  _$UpdateProfileImageCopyWithImpl(this._self, this._then);

  final UpdateProfileImage _self;
  final $Res Function(UpdateProfileImage) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? imagePath = null,}) {
  return _then(UpdateProfileImage(
null == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MessageSync with DiagnosticableTreeMixin implements ProfileEvent {
  const MessageSync(this.enabled);
  

 final  bool enabled;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageSyncCopyWith<MessageSync> get copyWith => _$MessageSyncCopyWithImpl<MessageSync>(this, _$identity);


@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'ProfileEvent.messageSync'))
    ..add(DiagnosticsProperty('enabled', enabled));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageSync&&(identical(other.enabled, enabled) || other.enabled == enabled));
}


@override
int get hashCode => Object.hash(runtimeType,enabled);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'ProfileEvent.messageSync(enabled: $enabled)';
}


}

/// @nodoc
abstract mixin class $MessageSyncCopyWith<$Res> implements $ProfileEventCopyWith<$Res> {
  factory $MessageSyncCopyWith(MessageSync value, $Res Function(MessageSync) _then) = _$MessageSyncCopyWithImpl;
@useResult
$Res call({
 bool enabled
});




}
/// @nodoc
class _$MessageSyncCopyWithImpl<$Res>
    implements $MessageSyncCopyWith<$Res> {
  _$MessageSyncCopyWithImpl(this._self, this._then);

  final MessageSync _self;
  final $Res Function(MessageSync) _then;

/// Create a copy of ProfileEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? enabled = null,}) {
  return _then(MessageSync(
null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on

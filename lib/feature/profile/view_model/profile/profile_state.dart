part of 'profile_bloc.dart';

enum ProfileLoadingStatus { none, loading, success, error }

enum Profiletype { none, profileData, profileImage, messageSync }

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(ProfileLoadingStatus.none) ProfileLoadingStatus loadingStatus,
    @Default('') String msg,
    @Default(Profiletype.none) Profiletype profiletype,
  }) = profileState;
}

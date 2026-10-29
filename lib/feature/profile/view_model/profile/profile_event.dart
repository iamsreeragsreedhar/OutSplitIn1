part of 'profile_bloc.dart';

@freezed
abstract class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.fetchProfileData() = FetchProfileData;
  const factory ProfileEvent.updateProfileData(String name, String email) =
      UpdateProfileData;
  const factory ProfileEvent.updateProfileImage(String imagePath) =
      UpdateProfileImage;
  const factory ProfileEvent.messageSync(bool enabled) = MessageSync;
}

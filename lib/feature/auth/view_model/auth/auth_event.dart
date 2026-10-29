part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.signupPressed(
    String email,
    String password,
    String displayname,
  ) = SignupPressed;
  const factory AuthEvent.loginPressed(String email, String password) =
      LoginPressed;
  const factory AuthEvent.googleSignIn() = GoogleSignIn;
  const factory AuthEvent.logout() = Logout;
}

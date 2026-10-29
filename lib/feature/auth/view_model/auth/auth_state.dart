part of 'auth_bloc.dart';

enum Authtype { none, login, google, signup, logout }

enum AuthLoadingStatus { none, loading, success, error }

@freezed
abstract class AuthState with _$AuthState {
  const factory AuthState({
    @Default(Authtype.none) Authtype authtype,
    @Default(AuthLoadingStatus.none) AuthLoadingStatus loadingStatus,
    @Default('') String msg,
  }) = _authState;
}

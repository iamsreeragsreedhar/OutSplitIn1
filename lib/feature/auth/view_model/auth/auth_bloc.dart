import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:out_split_in/core/services/firebase_services.dart';

part 'auth_state.dart';
part 'auth_event.dart';
part 'auth_bloc.freezed.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseServices repo;
  AuthBloc(this.repo) : super(const AuthState()) {
    on<SignupPressed>(signup);
    on<LoginPressed>(login);
    on<GoogleSignIn>(_onGoogleSignIn);
    on<Logout>(_onLogout);
  }

  String _mapAuthError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'invalid-credential':
        case 'wrong-password':
          return 'Invalid email or password. Please verify your details and try again.';
        case 'user-not-found':
          return 'No account found with this email. Please check the spelling or sign up.';
        case 'email-already-in-use':
          return 'An account with this email already exists. Please log in instead.';
        case 'weak-password':
          return 'Password is too weak. Please choose a password with at least 6 characters.';
        case 'invalid-email':
          return 'The email address format is invalid. Please enter a valid email.';
        case 'network-request-failed':
          return 'No internet connection. Please check your network and try again.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please wait a few moments before trying again.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled in Firebase Console.';
        default:
          return e.message ?? 'Authentication failed. Please try again.';
      }
    }

    final raw = e.toString().replaceFirst('Exception: ', '').trim();

    if (raw.contains('invalid-credential') ||
        raw.contains('credential is incorrect') ||
        raw.contains('wrong-password')) {
      return 'Invalid email or password. Please verify your details and try again.';
    }
    if (raw.contains('email-already-in-use') ||
        raw.contains('already in use') ||
        raw.contains('already exists')) {
      return 'An account with this email already exists. Please log in instead.';
    }
    if (raw.contains('network-request-failed') ||
        raw.contains('No internet connection') ||
        raw.contains('SocketException')) {
      return 'No internet connection. Please check your network and try again.';
    }
    if (raw.contains('permission-denied') ||
        raw.contains('PERMISSION_DENIED') ||
        raw.contains('Missing or insufficient permissions')) {
      return 'Database permission issue. Please check Firestore security rules in Firebase Console.';
    }
    if (raw.contains('ApiException 10') ||
        raw.contains('ApiException: 10') ||
        raw.contains('sign_in_failed')) {
      return 'Google Sign-In configuration error (ApiException 10). The SHA-1 fingerprint is missing in Firebase Console.';
    }
    return raw;
  }

  Future<void> signup(SignupPressed event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(
        authtype: Authtype.signup,
        loadingStatus: AuthLoadingStatus.loading,
      ),
    );
    try {
      await repo.createUser(event.email, event.password, event.displayname);
      emit(
        state.copyWith(
          authtype: Authtype.signup,
          loadingStatus: AuthLoadingStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          authtype: Authtype.signup,
          loadingStatus: AuthLoadingStatus.error,
          msg: _mapAuthError(e),
        ),
      );
    }
  }

  Future<void> login(LoginPressed event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(
        authtype: Authtype.login,
        loadingStatus: AuthLoadingStatus.loading,
      ),
    );
    try {
      await repo.loginUser(event.email, event.password);
      emit(
        state.copyWith(
          authtype: Authtype.login,
          loadingStatus: AuthLoadingStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          authtype: Authtype.login,
          loadingStatus: AuthLoadingStatus.error,
          msg: _mapAuthError(e),
        ),
      );
    }
  }

  Future<void> _onGoogleSignIn(
    GoogleSignIn event,
    Emitter<AuthState> emit,
  ) async {
    emit(
      state.copyWith(
        authtype: Authtype.google,
        loadingStatus: AuthLoadingStatus.loading,
      ),
    );
    try {
      final userCred = await repo.signInWithGoogle();
      if (userCred == null) {
        emit(
          state.copyWith(
            authtype: Authtype.google,
            loadingStatus: AuthLoadingStatus.none,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          authtype: Authtype.google,
          loadingStatus: AuthLoadingStatus.success,
          msg: 'Signed in with Google successfully!',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          authtype: Authtype.google,
          loadingStatus: AuthLoadingStatus.error,
          msg: _mapAuthError(e),
        ),
      );
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(
      state.copyWith(
        authtype: Authtype.logout,
        loadingStatus: AuthLoadingStatus.loading,
      ),
    );
    try {
      await repo.signOut();
      emit(
        state.copyWith(
          authtype: Authtype.logout,
          loadingStatus: AuthLoadingStatus.success,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          authtype: Authtype.logout,
          loadingStatus: AuthLoadingStatus.error,
          msg: _mapAuthError(e),
        ),
      );
    }
  }
}

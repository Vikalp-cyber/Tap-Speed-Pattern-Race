import 'dart:async';

import '../domain/entities/auth_session.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<AuthSession?> currentSession() async => null;

  @override
  Future<AuthSession> signInAsGuest() async {
    await Future<void>.delayed(const Duration(milliseconds: 320));
    return const AuthSession(
      displayName: 'Player_X1',
      providerType: AuthProviderType.guest,
    );
  }

  @override
  Future<AuthSession> signInWithGoogle() async {
    await Future<void>.delayed(const Duration(milliseconds: 480));
    return const AuthSession(
      displayName: 'Player_X1',
      providerType: AuthProviderType.google,
    );
  }
}

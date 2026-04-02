import 'entities/auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession?> currentSession();
  Future<AuthSession> signInAsGuest();
  Future<AuthSession> signInWithGoogle();
}

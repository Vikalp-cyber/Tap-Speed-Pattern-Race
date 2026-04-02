import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/analytics_service.dart';
import '../../../../shared/providers/app_providers.dart';
import '../../domain/auth_repository.dart';
import '../../domain/entities/auth_session.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthState {
  const AuthState({required this.status, this.session});

  const AuthState.unauthenticated()
    : status = AuthStatus.unauthenticated,
      session = null;

  final AuthStatus status;
  final AuthSession? session;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isBusy => status == AuthStatus.authenticating;

  AuthState copyWith({
    AuthStatus? status,
    AuthSession? session,
    bool clearSession = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      session: clearSession ? null : (session ?? this.session),
    );
  }
}

final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

class AuthController extends Notifier<AuthState> {
  late final AuthRepository _authRepository;
  late final AnalyticsService _analyticsService;

  @override
  AuthState build() {
    _authRepository = ref.read(authRepositoryProvider);
    _analyticsService = ref.read(analyticsServiceProvider);
    _restoreSession();
    return const AuthState.unauthenticated();
  }

  Future<void> signInAsGuest() async {
    if (state.isBusy) {
      return;
    }

    state = state.copyWith(status: AuthStatus.authenticating);
    final AuthSession session = await _authRepository.signInAsGuest();
    state = state.copyWith(status: AuthStatus.authenticated, session: session);
    await _analyticsService.trackEvent(
      'auth_guest_entered',
      parameters: <String, Object?>{'provider': session.providerLabel},
    );
  }

  Future<void> signInWithGoogle() async {
    if (state.isBusy) {
      return;
    }

    state = state.copyWith(status: AuthStatus.authenticating);
    final AuthSession session = await _authRepository.signInWithGoogle();
    state = state.copyWith(status: AuthStatus.authenticated, session: session);
    await _analyticsService.trackEvent(
      'auth_google_entered',
      parameters: <String, Object?>{'provider': session.providerLabel},
    );
  }

  Future<void> signOut() async {
    state = const AuthState.unauthenticated();
    await _analyticsService.trackEvent('auth_signed_out');
  }

  Future<void> _restoreSession() async {
    final AuthSession? session = await _authRepository.currentSession();
    if (session == null) {
      return;
    }

    state = state.copyWith(status: AuthStatus.authenticated, session: session);
  }
}

enum AuthProviderType { guest, google }

class AuthSession {
  const AuthSession({required this.displayName, required this.providerType});

  final String displayName;
  final AuthProviderType providerType;

  bool get isGuest => providerType == AuthProviderType.guest;

  String get providerLabel => switch (providerType) {
    AuthProviderType.guest => 'Guest Access',
    AuthProviderType.google => 'Google Sign-In',
  };
}

final class AuthUser {
  const AuthUser({required this.id, required this.email});

  final String id;
  final String? email;
}

final class AuthSignUpResult {
  const AuthSignUpResult({required this.user, required this.requiresEmailConfirmation});

  final AuthUser user;
  final bool requiresEmailConfirmation;
}

final class AuthFailure implements Exception {
  const AuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

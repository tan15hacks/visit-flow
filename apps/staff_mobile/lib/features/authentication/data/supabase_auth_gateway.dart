import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import 'package:visitflow_staff/features/authentication/domain/auth_gateway.dart';
import 'package:visitflow_staff/features/authentication/domain/auth_user.dart';

final class SupabaseAuthGateway implements AuthGateway {
  const SupabaseAuthGateway(this._client);

  final SupabaseClient _client;

  @override
  Stream<AuthUser?> get authStateChanges => _client.auth.onAuthStateChange.map(
    (data) => _mapUser(data.session?.user),
  );

  @override
  AuthUser? get currentUser => _mapUser(_client.auth.currentUser);

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = _mapUser(response.user);
      if (user == null || response.session == null) {
        throw const AuthFailure('VisitFlow could not start a secure session.');
      }
      return user;
    } on AuthException catch (error) {
      throw AuthFailure(_friendlyMessage(error));
    }
  }

  @override
  Future<AuthSignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final user = _mapUser(response.user);
      if (user == null) {
        throw const AuthFailure('VisitFlow could not create the account.');
      }
      return AuthSignUpResult(
        user: user,
        requiresEmailConfirmation: response.session == null,
      );
    } on AuthException catch (error) {
      throw AuthFailure(_friendlyMessage(error));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException {
      throw const AuthFailure(
        'VisitFlow could not sign out safely. Check your connection and try again.',
      );
    }
  }

  AuthUser? _mapUser(User? user) {
    if (user == null) {
      return null;
    }
    return AuthUser(id: user.id, email: user.email);
  }

  String _friendlyMessage(AuthException error) {
    final message = error.message.toLowerCase();
    if (message.contains('invalid login credentials')) {
      return 'The email or password is incorrect.';
    }
    if (message.contains('email not confirmed')) {
      return 'Confirm your email address before signing in.';
    }
    if (message.contains('already registered')) {
      return 'An account already exists for this email address.';
    }
    if (message.contains('password')) {
      return 'The password does not meet the authentication requirements.';
    }
    if (message.contains('rate limit') || message.contains('too many')) {
      return 'Too many attempts were made. Wait a moment and try again.';
    }
    return 'Authentication could not be completed. Check your details and connection.';
  }
}

import 'package:visitflow_staff/features/authentication/domain/auth_user.dart';

abstract interface class AuthGateway {
  AuthUser? get currentUser;

  Stream<AuthUser?> get authStateChanges;

  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthSignUpResult> signUp({
    required String email,
    required String password,
  });

  Future<void> signOut();
}

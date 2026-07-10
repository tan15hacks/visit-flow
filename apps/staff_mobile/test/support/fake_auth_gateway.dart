import 'dart:async';

import 'package:visitflow_staff/features/authentication/domain/auth_gateway.dart';
import 'package:visitflow_staff/features/authentication/domain/auth_user.dart';

final class FakeAuthGateway implements AuthGateway {
  FakeAuthGateway({AuthUser? currentUser}) : _currentUser = currentUser;

  final StreamController<AuthUser?> _authChanges =
      StreamController<AuthUser?>.broadcast(sync: true);
  AuthUser? _currentUser;

  AuthFailure? signInFailure;
  AuthFailure? signUpFailure;
  AuthFailure? signOutFailure;
  bool requiresEmailConfirmation = false;

  @override
  Stream<AuthUser?> get authStateChanges => _authChanges.stream;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final failure = signInFailure;
    if (failure != null) {
      throw failure;
    }
    final user = AuthUser(id: 'test-user', email: email);
    _currentUser = user;
    _authChanges.add(user);
    return user;
  }

  @override
  Future<AuthSignUpResult> signUp({
    required String email,
    required String password,
  }) async {
    final failure = signUpFailure;
    if (failure != null) {
      throw failure;
    }
    final user = AuthUser(id: 'new-user', email: email);
    if (!requiresEmailConfirmation) {
      _currentUser = user;
      _authChanges.add(user);
    }
    return AuthSignUpResult(
      user: user,
      requiresEmailConfirmation: requiresEmailConfirmation,
    );
  }

  @override
  Future<void> signOut() async {
    final failure = signOutFailure;
    if (failure != null) {
      throw failure;
    }
    _currentUser = null;
    _authChanges.add(null);
  }

  Future<void> dispose() => _authChanges.close();
}

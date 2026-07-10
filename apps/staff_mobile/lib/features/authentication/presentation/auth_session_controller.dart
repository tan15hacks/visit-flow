import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:visitflow_staff/features/authentication/domain/auth_gateway.dart';
import 'package:visitflow_staff/features/authentication/domain/auth_user.dart';

enum AuthSessionStatus { preview, signedOut, signedIn }

final class AuthSessionController extends ChangeNotifier {
  AuthSessionController.preview()
      : _gateway = null,
        _status = AuthSessionStatus.preview;

  AuthSessionController({required AuthGateway gateway})
      : _gateway = gateway,
        _status = gateway.currentUser == null
            ? AuthSessionStatus.signedOut
            : AuthSessionStatus.signedIn,
        _user = gateway.currentUser {
    _subscription = gateway.authStateChanges.listen(_handleAuthUserChanged);
  }

  final AuthGateway? _gateway;
  StreamSubscription<AuthUser?>? _subscription;
  AuthSessionStatus _status;
  AuthUser? _user;
  bool _isBusy = false;
  String? _errorMessage;
  String? _noticeMessage;

  AuthSessionStatus get status => _status;
  AuthUser? get user => _user;
  bool get isBusy => _isBusy;
  String? get errorMessage => _errorMessage;
  String? get noticeMessage => _noticeMessage;
  bool get isPreview => _status == AuthSessionStatus.preview;
  bool get isSignedIn => _status == AuthSessionStatus.signedIn;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final gateway = _requireGateway();
    _beginOperation();
    try {
      _user = await gateway.signIn(email: email.trim(), password: password);
      _status = AuthSessionStatus.signedIn;
      _noticeMessage = null;
    } on AuthFailure catch (error) {
      _errorMessage = error.message;
    } on Object {
      _errorMessage = 'Sign in failed unexpectedly. Try again.';
    } finally {
      _finishOperation();
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    final gateway = _requireGateway();
    _beginOperation();
    try {
      final result = await gateway.signUp(
        email: email.trim(),
        password: password,
      );
      _user = result.requiresEmailConfirmation ? null : result.user;
      _status = result.requiresEmailConfirmation
          ? AuthSessionStatus.signedOut
          : AuthSessionStatus.signedIn;
      _noticeMessage = result.requiresEmailConfirmation
          ? 'Account created. Check your email to confirm the account, then sign in.'
          : null;
    } on AuthFailure catch (error) {
      _errorMessage = error.message;
    } on Object {
      _errorMessage = 'Account creation failed unexpectedly. Try again.';
    } finally {
      _finishOperation();
    }
  }

  Future<void> signOut() async {
    final gateway = _requireGateway();
    _beginOperation();
    try {
      await gateway.signOut();
      _user = null;
      _status = AuthSessionStatus.signedOut;
      _noticeMessage = null;
    } on AuthFailure catch (error) {
      _errorMessage = error.message;
    } on Object {
      _errorMessage = 'Sign out failed unexpectedly. Try again.';
    } finally {
      _finishOperation();
    }
  }

  void clearMessages() {
    if (_errorMessage == null && _noticeMessage == null) {
      return;
    }
    _errorMessage = null;
    _noticeMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    final subscription = _subscription;
    if (subscription != null) {
      unawaited(subscription.cancel());
    }
    super.dispose();
  }

  void _handleAuthUserChanged(AuthUser? user) {
    if (isPreview) {
      return;
    }
    _user = user;
    _status = user == null
        ? AuthSessionStatus.signedOut
        : AuthSessionStatus.signedIn;
    notifyListeners();
  }

  AuthGateway _requireGateway() {
    final gateway = _gateway;
    if (gateway == null) {
      throw const AuthFailure(
        'Authentication is unavailable until Supabase is configured.',
      );
    }
    return gateway;
  }

  void _beginOperation() {
    _isBusy = true;
    _errorMessage = null;
    notifyListeners();
  }

  void _finishOperation() {
    _isBusy = false;
    notifyListeners();
  }
}

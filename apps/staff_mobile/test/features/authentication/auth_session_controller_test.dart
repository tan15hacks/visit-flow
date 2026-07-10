import 'package:flutter_test/flutter_test.dart';
import 'package:visitflow_staff/features/authentication/domain/auth_user.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';

import '../../support/fake_auth_gateway.dart';

void main() {
  test('preview controller keeps authentication disabled', () {
    final controller = AuthSessionController.preview();
    addTearDown(controller.dispose);

    expect(controller.status, AuthSessionStatus.preview);
    expect(controller.isPreview, isTrue);
    expect(controller.isSignedIn, isFalse);
  });

  test('restores an existing gateway user', () async {
    final gateway = FakeAuthGateway(
      currentUser: const AuthUser(id: 'existing-user', email: 'staff@example.com'),
    );
    final controller = AuthSessionController(gateway: gateway);
    addTearDown(() async {
      controller.dispose();
      await gateway.dispose();
    });

    expect(controller.status, AuthSessionStatus.signedIn);
    expect(controller.user?.email, 'staff@example.com');
  });

  test('sign in transitions to signed in', () async {
    final gateway = FakeAuthGateway();
    final controller = AuthSessionController(gateway: gateway);
    addTearDown(() async {
      controller.dispose();
      await gateway.dispose();
    });

    await controller.signIn(
      email: 'staff@example.com',
      password: 'password1',
    );

    expect(controller.status, AuthSessionStatus.signedIn);
    expect(controller.user?.email, 'staff@example.com');
    expect(controller.errorMessage, isNull);
  });

  test('confirmation-required sign up stays signed out', () async {
    final gateway = FakeAuthGateway()..requiresEmailConfirmation = true;
    final controller = AuthSessionController(gateway: gateway);
    addTearDown(() async {
      controller.dispose();
      await gateway.dispose();
    });

    await controller.signUp(
      email: 'new@example.com',
      password: 'password1',
    );

    expect(controller.status, AuthSessionStatus.signedOut);
    expect(controller.user, isNull);
    expect(controller.noticeMessage, contains('Check your email'));
  });

  test('sign out clears the active session', () async {
    final gateway = FakeAuthGateway(
      currentUser: const AuthUser(id: 'existing-user', email: 'staff@example.com'),
    );
    final controller = AuthSessionController(gateway: gateway);
    addTearDown(() async {
      controller.dispose();
      await gateway.dispose();
    });

    await controller.signOut();

    expect(controller.status, AuthSessionStatus.signedOut);
    expect(controller.user, isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitflow_staff/app/app.dart';
import 'package:visitflow_staff/app/bootstrap.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/core/config/app_environment.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';

import 'support/fake_auth_gateway.dart';

void main() {
  const bootstrapResult = AppBootstrapResult(
    environment: AppEnvironment(
      supabaseUrl: 'http://127.0.0.1:54321',
      supabasePublishableKey: 'test-publishable-key',
    ),
    supabaseInitialized: true,
  );

  testWidgets('redirects signed-out users away from protected routes', (
    tester,
  ) async {
    final gateway = FakeAuthGateway();
    final authController = AuthSessionController(gateway: gateway);
    final router = createAppRouter(
      bootstrapResult: bootstrapResult,
      authController: authController,
    );
    addTearDown(() async {
      router.dispose();
      authController.dispose();
      await gateway.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionControllerProvider.overrideWithValue(authController),
        ],
        child: VisitFlowApp(bootstrapResult: bootstrapResult, router: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOne);

    router.go(AppRoutes.dashboard);
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOne);
    expect(find.text('Currently inside'), findsNothing);
  });

  testWidgets('signing in opens the protected application shell', (
    tester,
  ) async {
    final gateway = FakeAuthGateway();
    final authController = AuthSessionController(gateway: gateway);
    final router = createAppRouter(
      bootstrapResult: bootstrapResult,
      authController: authController,
    );
    addTearDown(() async {
      router.dispose();
      authController.dispose();
      await gateway.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionControllerProvider.overrideWithValue(authController),
        ],
        child: VisitFlowApp(bootstrapResult: bootstrapResult, router: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'staff@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password1');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Currently inside'), findsOne);
    expect(find.text('Welcome back'), findsNothing);
  });
}

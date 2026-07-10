import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitflow_staff/app/app.dart';
import 'package:visitflow_staff/app/bootstrap.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/core/config/app_environment.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_access_controller.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_providers.dart';

import 'support/fake_auth_gateway.dart';
import 'support/fake_organization_gateway.dart';

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
    final authGateway = FakeAuthGateway();
    final authController = AuthSessionController(gateway: authGateway);
    final organizationGateway = FakeOrganizationGateway();
    final organizationController = OrganizationAccessController(
      gateway: organizationGateway,
      authController: authController,
    );
    final router = createAppRouter(
      bootstrapResult: bootstrapResult,
      authController: authController,
      organizationController: organizationController,
    );
    addTearDown(() async {
      router.dispose();
      organizationController.dispose();
      authController.dispose();
      await authGateway.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionControllerProvider.overrideWithValue(authController),
          organizationAccessControllerProvider.overrideWithValue(
            organizationController,
          ),
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

  testWidgets('signed-in users without memberships must onboard', (
    tester,
  ) async {
    final authGateway = FakeAuthGateway();
    final authController = AuthSessionController(gateway: authGateway);
    final organizationGateway = FakeOrganizationGateway();
    final organizationController = OrganizationAccessController(
      gateway: organizationGateway,
      authController: authController,
    );
    final router = createAppRouter(
      bootstrapResult: bootstrapResult,
      authController: authController,
      organizationController: organizationController,
    );
    addTearDown(() async {
      router.dispose();
      organizationController.dispose();
      authController.dispose();
      await authGateway.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionControllerProvider.overrideWithValue(authController),
          organizationAccessControllerProvider.overrideWithValue(
            organizationController,
          ),
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

    expect(find.text('Set up VisitFlow'), findsOne);
    expect(find.text('Create your organization'), findsOne);
    expect(find.text('Currently inside'), findsNothing);
  });

  testWidgets('creating an organization opens the workspace dashboard', (
    tester,
  ) async {
    final authGateway = FakeAuthGateway();
    final authController = AuthSessionController(gateway: authGateway);
    final organizationGateway = FakeOrganizationGateway();
    final organizationController = OrganizationAccessController(
      gateway: organizationGateway,
      authController: authController,
    );
    final router = createAppRouter(
      bootstrapResult: bootstrapResult,
      authController: authController,
      organizationController: organizationController,
    );
    addTearDown(() async {
      router.dispose();
      organizationController.dispose();
      authController.dispose();
      await authGateway.dispose();
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionControllerProvider.overrideWithValue(authController),
          organizationAccessControllerProvider.overrideWithValue(
            organizationController,
          ),
        ],
        child: VisitFlowApp(bootstrapResult: bootstrapResult, router: router),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'owner@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'password1');
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Organization name'),
      'Acme Main Office',
    );
    await tester.tap(
      find.widgetWithText(FilledButton, 'Create organization'),
    );
    await tester.pumpAndSettle();

    expect(find.text('Acme Main Office'), findsWidgets);
    expect(find.text('Currently inside'), findsOne);
    expect(find.text('Create your organization'), findsNothing);
    expect(organizationGateway.lastCreatedSlug, 'acme-main-office');
    expect(organizationGateway.lastCreatedTimezone, 'Asia/Manila');
  });
}

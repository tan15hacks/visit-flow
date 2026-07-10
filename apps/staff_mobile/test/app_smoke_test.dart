import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitflow_staff/app/app.dart';
import 'package:visitflow_staff/app/bootstrap.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/core/config/app_environment.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';

void main() {
  testWidgets('renders and navigates through the preview shell', (
    tester,
  ) async {
    const bootstrapResult = AppBootstrapResult(
      environment: AppEnvironment(supabaseUrl: '', supabasePublishableKey: ''),
      supabaseInitialized: false,
    );
    final authController = AuthSessionController.preview();
    final router = createAppRouter(
      bootstrapResult: bootstrapResult,
      authController: authController,
    );

    addTearDown(() {
      router.dispose();
      authController.dispose();
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

    expect(
      find.text('Preview mode: Supabase is not configured yet.'),
      findsOne,
    );
    expect(find.text('Currently inside'), findsOne);

    await tester.tap(find.byIcon(Icons.groups_outlined));
    await tester.pumpAndSettle();

    expect(find.text('No visitor records yet'), findsOne);
  });
}

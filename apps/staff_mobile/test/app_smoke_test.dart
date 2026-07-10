import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visitflow_staff/app/app.dart';
import 'package:visitflow_staff/app/bootstrap.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/core/config/app_environment.dart';

void main() {
  testWidgets('renders and navigates through the preview shell', (tester) async {
    const bootstrapResult = AppBootstrapResult(
      environment: AppEnvironment(
        supabaseUrl: '',
        supabasePublishableKey: '',
      ),
      supabaseInitialized: false,
    );
    final router = createAppRouter(bootstrapResult: bootstrapResult);

    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(
        child: VisitFlowApp(
          bootstrapResult: bootstrapResult,
          router: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Preview mode: Supabase is not configured yet.'), findsOne);
    expect(find.text('Flutter foundation ready for verification'), findsOne);

    await tester.tap(find.byIcon(Icons.groups_outlined));
    await tester.pumpAndSettle();

    expect(find.text('No visitor records yet'), findsOne);
  });
}

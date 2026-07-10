import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visitflow_staff/app/app.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/core/config/app_environment.dart';
import 'package:visitflow_staff/features/authentication/data/supabase_auth_gateway.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';

final class AppBootstrapResult {
  const AppBootstrapResult({
    required this.environment,
    required this.supabaseInitialized,
    this.initializationError,
  });

  final AppEnvironment environment;
  final bool supabaseInitialized;
  final Object? initializationError;

  bool get isPreviewMode => !environment.hasSupabaseConfiguration;
  bool get hasInitializationError => initializationError != null;
}

Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = AppEnvironment.fromDartDefines();
  final result = await _initializeServices(environment);
  final authController = _createAuthController(result);
  final router = createAppRouter(
    bootstrapResult: result,
    authController: authController,
  );

  runApp(
    ProviderScope(
      overrides: [
        authSessionControllerProvider.overrideWithValue(authController),
      ],
      child: VisitFlowApp(bootstrapResult: result, router: router),
    ),
  );
}

AuthSessionController _createAuthController(AppBootstrapResult result) {
  if (!result.supabaseInitialized) {
    return AuthSessionController.preview();
  }
  return AuthSessionController(
    gateway: SupabaseAuthGateway(Supabase.instance.client),
  );
}

Future<AppBootstrapResult> _initializeServices(
  AppEnvironment environment,
) async {
  if (!environment.hasSupabaseConfiguration) {
    return AppBootstrapResult(
      environment: environment,
      supabaseInitialized: false,
    );
  }

  try {
    await Supabase.initialize(
      url: environment.supabaseUrl,
      publishableKey: environment.supabasePublishableKey,
    );

    return AppBootstrapResult(
      environment: environment,
      supabaseInitialized: true,
    );
  } on Object catch (error) {
    return AppBootstrapResult(
      environment: environment,
      supabaseInitialized: false,
      initializationError: error,
    );
  }
}

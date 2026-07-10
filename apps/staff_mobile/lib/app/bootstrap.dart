import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visitflow_staff/app/app.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/core/config/app_environment.dart';
import 'package:visitflow_staff/features/authentication/data/supabase_auth_gateway.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';
import 'package:visitflow_staff/features/organizations/data/supabase_organization_gateway.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_access_controller.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_providers.dart';

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
  final organizationController = _createOrganizationController(
    result,
    authController,
  );
  final router = createAppRouter(
    bootstrapResult: result,
    authController: authController,
    organizationController: organizationController,
  );

  runApp(
    ProviderScope(
      overrides: [
        authSessionControllerProvider.overrideWithValue(authController),
        organizationAccessControllerProvider.overrideWithValue(
          organizationController,
        ),
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

OrganizationAccessController _createOrganizationController(
  AppBootstrapResult result,
  AuthSessionController authController,
) {
  if (!result.supabaseInitialized) {
    return OrganizationAccessController.preview();
  }
  return OrganizationAccessController(
    gateway: SupabaseOrganizationGateway(Supabase.instance.client),
    authController: authController,
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

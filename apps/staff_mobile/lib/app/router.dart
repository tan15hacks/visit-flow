import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visitflow_staff/app/bootstrap.dart';
import 'package:visitflow_staff/core/widgets/app_shell.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';
import 'package:visitflow_staff/features/authentication/presentation/sign_in_screen.dart';
import 'package:visitflow_staff/features/authentication/presentation/sign_up_screen.dart';
import 'package:visitflow_staff/features/dashboard/presentation/dashboard_screen.dart';
import 'package:visitflow_staff/features/invitations/presentation/invitations_screen.dart';
import 'package:visitflow_staff/features/more/presentation/more_screen.dart';
import 'package:visitflow_staff/features/scan/presentation/scan_screen.dart';
import 'package:visitflow_staff/features/visitors/presentation/visitors_screen.dart';

abstract final class AppRoutes {
  static const signIn = '/auth/sign-in';
  static const signUp = '/auth/sign-up';
  static const dashboard = '/app/dashboard';
  static const visitors = '/app/visitors';
  static const scan = '/app/scan';
  static const invitations = '/app/invitations';
  static const more = '/app/more';
}

GoRouter createAppRouter({
  required AppBootstrapResult bootstrapResult,
  required AuthSessionController authController,
}) {
  return GoRouter(
    initialLocation: authController.status == AuthSessionStatus.signedOut
        ? AppRoutes.signIn
        : AppRoutes.dashboard,
    refreshListenable: authController,
    redirect: (context, state) {
      final path = state.uri.path;
      final isAuthRoute = path == AppRoutes.signIn || path == AppRoutes.signUp;

      if (authController.isPreview) {
        return isAuthRoute ? AppRoutes.dashboard : null;
      }
      if (!authController.isSignedIn) {
        return isAuthRoute ? null : AppRoutes.signIn;
      }
      return isAuthRoute ? AppRoutes.dashboard : null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => AppRoutes.dashboard),
      GoRoute(
        path: AppRoutes.signIn,
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        builder: (context, state) => const SignUpScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(
            bootstrapResult: bootstrapResult,
            currentLocation: state.uri.path,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: AppRoutes.visitors,
            builder: (context, state) => const VisitorsScreen(),
          ),
          GoRoute(
            path: AppRoutes.scan,
            builder: (context, state) => const ScanScreen(),
          ),
          GoRoute(
            path: AppRoutes.invitations,
            builder: (context, state) => const InvitationsScreen(),
          ),
          GoRoute(
            path: AppRoutes.more,
            builder: (context, state) => const MoreScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) {
      final destination = authController.isSignedIn || authController.isPreview
          ? AppRoutes.dashboard
          : AppRoutes.signIn;
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.route_outlined, size: 48),
                const SizedBox(height: 16),
                Text(
                  'Page not found',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                const Text(
                  'The requested VisitFlow page is not available.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go(destination),
                  child: Text(
                    destination == AppRoutes.signIn
                        ? 'Return to sign in'
                        : 'Return to dashboard',
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

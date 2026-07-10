import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visitflow_staff/app/bootstrap.dart';
import 'package:visitflow_staff/core/widgets/app_shell.dart';
import 'package:visitflow_staff/features/dashboard/presentation/dashboard_screen.dart';
import 'package:visitflow_staff/features/invitations/presentation/invitations_screen.dart';
import 'package:visitflow_staff/features/more/presentation/more_screen.dart';
import 'package:visitflow_staff/features/scan/presentation/scan_screen.dart';
import 'package:visitflow_staff/features/visitors/presentation/visitors_screen.dart';

abstract final class AppRoutes {
  static const dashboard = '/app/dashboard';
  static const visitors = '/app/visitors';
  static const scan = '/app/scan';
  static const invitations = '/app/invitations';
  static const more = '/app/more';
}

GoRouter createAppRouter({required AppBootstrapResult bootstrapResult}) {
  return GoRouter(
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(path: '/', redirect: (context, state) => AppRoutes.dashboard),
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
                Text(
                  state.uri.toString(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: () => context.go(AppRoutes.dashboard),
                  child: const Text('Return to dashboard'),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

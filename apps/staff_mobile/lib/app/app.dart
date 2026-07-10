import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visitflow_staff/app/bootstrap.dart';
import 'package:visitflow_staff/core/theme/app_theme.dart';

final class VisitFlowApp extends StatelessWidget {
  const VisitFlowApp({
    required this.bootstrapResult,
    required this.router,
    super.key,
  });

  final AppBootstrapResult bootstrapResult;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'VisitFlow',
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) {
        return _AppErrorBoundary(
          bootstrapResult: bootstrapResult,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

final class _AppErrorBoundary extends StatelessWidget {
  const _AppErrorBoundary({required this.bootstrapResult, required this.child});

  final AppBootstrapResult bootstrapResult;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!bootstrapResult.hasInitializationError) {
      return child;
    }

    return Directionality(
      textDirection: TextDirection.ltr,
      child: ColoredBox(
        color: Theme.of(context).colorScheme.surface,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.cloud_off_rounded,
                        size: 40,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'VisitFlow could not connect to its backend.',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Check the public Supabase configuration and restart '
                        'the app. No secret or service-role key should be '
                        'placed in the mobile application.',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

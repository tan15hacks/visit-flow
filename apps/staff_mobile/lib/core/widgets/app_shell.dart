import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:visitflow_staff/app/bootstrap.dart';

final class AppShell extends StatelessWidget {
  const AppShell({
    required this.bootstrapResult,
    required this.currentLocation,
    required this.child,
    super.key,
  });

  static const _destinations = <_AppDestination>[
    _AppDestination(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard_rounded,
      path: '/app/dashboard',
    ),
    _AppDestination(
      label: 'Visitors',
      icon: Icons.groups_outlined,
      selectedIcon: Icons.groups_rounded,
      path: '/app/visitors',
    ),
    _AppDestination(
      label: 'Scan',
      icon: Icons.qr_code_scanner_outlined,
      selectedIcon: Icons.qr_code_scanner_rounded,
      path: '/app/scan',
    ),
    _AppDestination(
      label: 'Invitations',
      icon: Icons.mark_email_unread_outlined,
      selectedIcon: Icons.mark_email_unread_rounded,
      path: '/app/invitations',
    ),
    _AppDestination(
      label: 'More',
      icon: Icons.more_horiz_rounded,
      selectedIcon: Icons.more_rounded,
      path: '/app/more',
    ),
  ];

  final AppBootstrapResult bootstrapResult;
  final String currentLocation;
  final Widget child;

  int get _selectedIndex {
    final index = _destinations.indexWhere(
      (destination) => currentLocation.startsWith(destination.path),
    );
    return index < 0 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useRail = constraints.maxWidth >= 840;

        if (useRail) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    extended: constraints.maxWidth >= 1120,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: (index) =>
                        context.go(_destinations[index].path),
                    leading: const Padding(
                      padding: EdgeInsets.fromLTRB(12, 8, 12, 24),
                      child: _BrandMark(),
                    ),
                    destinations: [
                      for (final destination in _destinations)
                        NavigationRailDestination(
                          icon: Icon(destination.icon),
                          selectedIcon: Icon(destination.selectedIcon),
                          label: Text(destination.label),
                        ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: Column(
                      children: [
                        _EnvironmentBanner(
                          bootstrapResult: bootstrapResult,
                        ),
                        Expanded(child: child),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 16,
            title: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _BrandMark(compact: true),
                SizedBox(width: 10),
                Text('VisitFlow'),
              ],
            ),
          ),
          body: SafeArea(
            top: false,
            child: Column(
              children: [
                _EnvironmentBanner(bootstrapResult: bootstrapResult),
                Expanded(child: child),
              ],
            ),
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                context.go(_destinations[index].path),
            destinations: [
              for (final destination in _destinations)
                NavigationDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: destination.label,
                ),
            ],
          ),
        );
      },
    );
  }
}

final class _EnvironmentBanner extends StatelessWidget {
  const _EnvironmentBanner({required this.bootstrapResult});

  final AppBootstrapResult bootstrapResult;

  @override
  Widget build(BuildContext context) {
    if (!bootstrapResult.isPreviewMode) {
      return const SizedBox.shrink();
    }

    final colorScheme = Theme.of(context).colorScheme;
    return ColoredBox(
      color: colorScheme.tertiaryContainer,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Icon(
              Icons.visibility_outlined,
              size: 18,
              color: colorScheme.onTertiaryContainer,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Preview mode: Supabase is not configured yet.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _BrandMark extends StatelessWidget {
  const _BrandMark({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: compact ? 34 : 48,
      height: compact ? 34 : 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(compact ? 10 : 16),
      ),
      alignment: Alignment.center,
      child: Icon(
        Icons.how_to_reg_rounded,
        color: Theme.of(context).colorScheme.onPrimary,
        size: compact ? 20 : 28,
      ),
    );
  }
}

final class _AppDestination {
  const _AppDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    required this.path,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final String path;
}

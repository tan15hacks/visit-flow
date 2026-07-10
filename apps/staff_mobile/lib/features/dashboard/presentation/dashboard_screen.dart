import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visitflow_staff/core/widgets/foundation_page.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_membership.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_providers.dart';

final class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final organizationController = ref.read(
      organizationAccessControllerProvider,
    );
    return ListenableBuilder(
      listenable: organizationController,
      builder: (context, child) {
        final membership = organizationController.selectedMembership;
        return FoundationPage(
          title: 'Dashboard',
          description: membership == null
              ? 'A focused operational view for receptionists, guards, and organization administrators.'
              : 'Operational overview for ${membership.organization.name}.',
          primaryAction: FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.person_add_alt_1_rounded),
            label: const Text('Register visitor'),
          ),
          children: [
            if (membership != null)
              _OrganizationContextCard(membership: membership),
            const _MetricGrid(),
            const _FoundationNotice(),
          ],
        );
      },
    );
  }
}

final class _OrganizationContextCard extends StatelessWidget {
  const _OrganizationContextCard({required this.membership});

  final OrganizationMembership membership;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final roleLabel = membership.role
        .split('_')
        .map(
          (part) => part.isEmpty
              ? part
              : '${part.substring(0, 1).toUpperCase()}${part.substring(1)}',
        )
        .join(' ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.apartment_rounded,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    membership.organization.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$roleLabel · ${membership.organization.timezone}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    membership.organization.slug,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _MetricGrid extends StatelessWidget {
  const _MetricGrid();

  static const _metrics = <_MetricData>[
    _MetricData(
      label: 'Currently inside',
      value: '0',
      icon: Icons.login_rounded,
    ),
    _MetricData(
      label: 'Expected today',
      value: '0',
      icon: Icons.event_available_rounded,
    ),
    _MetricData(
      label: 'Awaiting approval',
      value: '0',
      icon: Icons.pending_actions_rounded,
    ),
    _MetricData(
      label: 'Completed visits',
      value: '0',
      icon: Icons.task_alt_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = switch (constraints.maxWidth) {
          >= 1000 => 4,
          >= 560 => 2,
          _ => 1,
        };

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: columns == 1 ? 3.2 : 1.8,
          children: [
            for (final metric in _metrics) _MetricCard(metric: metric),
          ],
        );
      },
    );
  }
}

final class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.metric});

  final _MetricData metric;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(14),
              ),
              alignment: Alignment.center,
              child: Icon(metric.icon, color: colorScheme.onPrimaryContainer),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metric.value,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    metric.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _FoundationNotice extends StatelessWidget {
  const _FoundationNotice();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.construction_rounded,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Organization workspace ready',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Authentication and secure organization onboarding are now connected. Visitor records, locations, employees, and QR operations remain intentionally disabled until their focused milestones.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

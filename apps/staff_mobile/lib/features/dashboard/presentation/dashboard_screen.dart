import 'package:flutter/material.dart';
import 'package:visitflow_staff/core/widgets/foundation_page.dart';

final class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FoundationPage(
      title: 'Dashboard',
      description:
          'A focused operational view for receptionists, guards, and '
          'organization administrators.',
      primaryAction: FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Register visitor'),
      ),
      children: const [_MetricGrid(), _FoundationNotice()],
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
                    'Flutter foundation ready for verification',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Authentication and real visitor data are intentionally '
                    'not part of this milestone. The shell, routing, theme, '
                    'configuration, and test foundation are being validated '
                    'first.',
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

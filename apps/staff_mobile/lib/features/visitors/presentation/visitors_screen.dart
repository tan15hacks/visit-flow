import 'package:flutter/material.dart';
import 'package:visitflow_staff/core/widgets/foundation_page.dart';

final class VisitorsScreen extends StatelessWidget {
  const VisitorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FoundationPage(
      title: 'Visitors',
      description:
          'Search and manage expected, pending, checked-in, and completed '
          'visits from one operational list.',
      primaryAction: FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('New visitor'),
      ),
      children: const [_VisitorFilters(), _EmptyVisitorsState()],
    );
  }
}

final class _VisitorFilters extends StatelessWidget {
  const _VisitorFilters();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            const SizedBox(
              width: 320,
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search_rounded),
                  hintText: 'Search visitors',
                ),
              ),
            ),
            FilterChip(
              label: const Text('Inside'),
              selected: true,
              onSelected: null,
            ),
            FilterChip(
              label: const Text('Expected'),
              selected: false,
              onSelected: null,
            ),
            FilterChip(
              label: const Text('Pending'),
              selected: false,
              onSelected: null,
            ),
            FilterChip(
              label: const Text('Completed'),
              selected: false,
              onSelected: null,
            ),
          ],
        ),
      ),
    );
  }
}

final class _EmptyVisitorsState extends StatelessWidget {
  const _EmptyVisitorsState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              children: [
                Icon(
                  Icons.groups_2_outlined,
                  size: 52,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),
                Text(
                  'No visitor records yet',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Text(
                  'Visitor data will appear here after authentication, '
                  'organization onboarding, and the visit workflow are added.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

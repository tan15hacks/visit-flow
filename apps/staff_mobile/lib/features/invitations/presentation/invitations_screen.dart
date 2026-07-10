import 'package:flutter/material.dart';
import 'package:visitflow_staff/core/widgets/foundation_page.dart';

final class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FoundationPage(
      title: 'Invitations',
      description:
          'Employees will create time-limited visitor invitations and monitor '
          'their status from this workspace.',
      primaryAction: FilledButton.icon(
        onPressed: null,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create invitation'),
      ),
      children: const [_InvitationSummary(), _EmptyInvitationsState()],
    );
  }
}

final class _InvitationSummary extends StatelessWidget {
  const _InvitationSummary();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Wrap(
          spacing: 28,
          runSpacing: 16,
          children: const [
            _SummaryValue(label: 'Today', value: '0'),
            _SummaryValue(label: 'Upcoming', value: '0'),
            _SummaryValue(label: 'Expired', value: '0'),
            _SummaryValue(label: 'Cancelled', value: '0'),
          ],
        ),
      ),
    );
  }
}

final class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

final class _EmptyInvitationsState extends StatelessWidget {
  const _EmptyInvitationsState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
        child: Center(
          child: Column(
            children: [
              Icon(
                Icons.mail_outline_rounded,
                size: 52,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'No invitations have been created',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Invitation creation will be enabled after employee accounts '
                'and organization membership are secured.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

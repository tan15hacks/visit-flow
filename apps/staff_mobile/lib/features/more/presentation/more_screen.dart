import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visitflow_staff/core/widgets/foundation_page.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_page_frame.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';

final class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authController = ref.read(authSessionControllerProvider);
    return FoundationPage(
      title: 'More',
      description:
          'Administrative tools are exposed according to the signed-in user’s organization role.',
      children: [
        ListenableBuilder(
          listenable: authController,
          builder: (context, child) {
            return _AccountCard(
              email: authController.user?.email,
              isPreview: authController.isPreview,
              isBusy: authController.isBusy,
              errorMessage: authController.errorMessage,
              onSignOut: authController.isPreview || authController.isBusy
                  ? null
                  : authController.signOut,
            );
          },
        ),
        const SizedBox(height: 16),
        const _SettingsCard(),
      ],
    );
  }
}

final class _AccountCard extends StatelessWidget {
  const _AccountCard({
    required this.email,
    required this.isPreview,
    required this.isBusy,
    required this.errorMessage,
    required this.onSignOut,
  });

  final String? email;
  final bool isPreview;
  final bool isBusy;
  final String? errorMessage;
  final Future<void> Function()? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(
                    isPreview
                        ? Icons.visibility_outlined
                        : Icons.person_outline_rounded,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPreview ? 'Preview session' : 'Signed-in account',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isPreview
                            ? 'Configure Supabase to enable staff authentication.'
                            : email ?? 'Authenticated staff member',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              AuthMessageBanner(message: errorMessage!, isError: true),
            ],
            if (!isPreview) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onSignOut,
                icon: isBusy
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.logout_rounded),
                label: Text(isBusy ? 'Signing out…' : 'Sign out'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _SettingsCard extends StatelessWidget {
  const _SettingsCard();

  static const _items = <_SettingsItem>[
    _SettingsItem(
      title: 'Organization',
      subtitle: 'Profile, locations, entrances, and departments',
      icon: Icons.apartment_rounded,
    ),
    _SettingsItem(
      title: 'Employees and roles',
      subtitle: 'Owners, administrators, guards, and hosts',
      icon: Icons.badge_outlined,
    ),
    _SettingsItem(
      title: 'Reports',
      subtitle: 'Visitor history, filters, and CSV exports',
      icon: Icons.analytics_outlined,
    ),
    _SettingsItem(
      title: 'Privacy and retention',
      subtitle: 'Consent, data retention, and deletion controls',
      icon: Icons.privacy_tip_outlined,
    ),
    _SettingsItem(
      title: 'Application settings',
      subtitle: 'Notifications, theme, and device preferences',
      icon: Icons.settings_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var index = 0; index < _items.length; index++) ...[
            ListTile(
              enabled: false,
              leading: Icon(_items[index].icon),
              title: Text(_items[index].title),
              subtitle: Text(_items[index].subtitle),
              trailing: const Icon(Icons.chevron_right_rounded),
            ),
            if (index != _items.length - 1) const Divider(height: 1),
          ],
        ],
      ),
    );
  }
}

final class _SettingsItem {
  const _SettingsItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;
}

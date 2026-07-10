import 'package:flutter/material.dart';
import 'package:visitflow_staff/core/widgets/foundation_page.dart';

final class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FoundationPage(
      title: 'More',
      description:
          'Administrative tools will be exposed here according to the signed-in '
          'user’s organization role.',
      children: const [_SettingsCard()],
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

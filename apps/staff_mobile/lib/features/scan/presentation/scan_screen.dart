import 'package:flutter/material.dart';
import 'package:visitflow_staff/core/widgets/foundation_page.dart';

final class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FoundationPage(
      title: 'Scan visitor pass',
      description:
          'This screen will verify secure, opaque visitor tokens before any '
          'check-in or check-out transition is accepted.',
      children: const [_ScannerPlaceholder()],
    );
  }
}

final class _ScannerPlaceholder extends StatelessWidget {
  const _ScannerPlaceholder();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              children: [
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 96,
                    color: colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Camera scanning is intentionally disabled',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'The scanner package and camera permissions will be added '
                  'with the secure QR verification milestone, after backend '
                  'token validation is implemented.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: null,
                  icon: const Icon(Icons.camera_alt_outlined),
                  label: const Text('Open scanner'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

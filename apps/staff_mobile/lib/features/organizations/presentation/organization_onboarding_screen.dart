import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_access_controller.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_providers.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_validators.dart';

final class OrganizationOnboardingScreen extends ConsumerStatefulWidget {
  const OrganizationOnboardingScreen({super.key});

  @override
  ConsumerState<OrganizationOnboardingScreen> createState() =>
      _OrganizationOnboardingScreenState();
}

final class _OrganizationOnboardingScreenState
    extends ConsumerState<OrganizationOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _slugController = TextEditingController();
  final _timezoneController = TextEditingController(text: 'Asia/Manila');
  bool _slugEdited = false;

  @override
  void dispose() {
    _nameController.dispose();
    _slugController.dispose();
    _timezoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(organizationAccessControllerProvider);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 620),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _OnboardingHeader(),
                      const SizedBox(height: 28),
                      ListenableBuilder(
                        listenable: controller,
                        builder: (context, child) {
                          return switch (controller.status) {
                            OrganizationAccessStatus.loading =>
                              const _LoadingPanel(
                                message: 'Checking your organization access…',
                              ),
                            OrganizationAccessStatus.failure => _FailurePanel(
                              message:
                                  controller.errorMessage ??
                                  'Organization access could not be loaded.',
                              onRetry: controller.isLoading
                                  ? null
                                  : controller.refresh,
                              onSignOut: _signOut,
                            ),
                            OrganizationAccessStatus.needsOrganization =>
                              _buildForm(controller),
                            OrganizationAccessStatus.ready =>
                              const _LoadingPanel(
                                message: 'Opening your organization workspace…',
                              ),
                            OrganizationAccessStatus.signedOut =>
                              const _LoadingPanel(
                                message: 'Returning to sign in…',
                              ),
                            OrganizationAccessStatus.preview =>
                              const _LoadingPanel(
                                message:
                                    'Organization onboarding requires Supabase configuration.',
                              ),
                          };
                        },
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

  Widget _buildForm(OrganizationAccessController controller) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (controller.errorMessage != null) ...[
            _MessageBanner(message: controller.errorMessage!),
            const SizedBox(height: 18),
          ],
          Text(
            'Create your organization',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This creates a private VisitFlow workspace and makes your account its owner.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 22),
          TextFormField(
            controller: _nameController,
            enabled: !controller.isCreating,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: 'Organization name',
              hintText: 'Example: Acme Main Office',
              prefixIcon: Icon(Icons.apartment_rounded),
            ),
            validator: OrganizationValidators.name,
            onChanged: _updateGeneratedSlug,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _slugController,
            enabled: !controller.isCreating,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              labelText: 'Workspace address',
              hintText: 'acme-main-office',
              prefixIcon: const Icon(Icons.link_rounded),
              helperText: 'Lowercase letters, numbers, and hyphens only.',
              suffixIcon: IconButton(
                tooltip: 'Generate from organization name',
                onPressed: controller.isCreating ? null : _regenerateSlug,
                icon: const Icon(Icons.auto_fix_high_rounded),
              ),
            ),
            validator: OrganizationValidators.slug,
            onChanged: (_) {
              _slugEdited = true;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _timezoneController,
            enabled: !controller.isCreating,
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(
              labelText: 'Timezone',
              hintText: 'Asia/Manila',
              prefixIcon: Icon(Icons.schedule_rounded),
              helperText: 'Used for visit schedules and reports.',
            ),
            validator: OrganizationValidators.timezone,
            onFieldSubmitted: (_) => _submit(controller),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: controller.isCreating
                ? null
                : () => _submit(controller),
            icon: controller.isCreating
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.add_business_rounded),
            label: Text(
              controller.isCreating
                  ? 'Creating organization…'
                  : 'Create organization',
            ),
          ),
          const SizedBox(height: 12),
          TextButton.icon(
            onPressed: controller.isCreating ? null : _signOut,
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Sign out and use another account'),
          ),
        ],
      ),
    );
  }

  void _updateGeneratedSlug(String value) {
    if (_slugEdited) {
      return;
    }
    _setSlug(OrganizationValidators.slugFromName(value));
  }

  void _regenerateSlug() {
    _slugEdited = false;
    _setSlug(OrganizationValidators.slugFromName(_nameController.text));
  }

  void _setSlug(String value) {
    _slugController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  Future<void> _submit(OrganizationAccessController controller) async {
    FocusScope.of(context).unfocus();
    controller.clearError();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await controller.createOrganization(
      name: _nameController.text,
      slug: _slugController.text,
      timezone: _timezoneController.text,
    );
  }

  Future<void> _signOut() async {
    await ref.read(authSessionControllerProvider).signOut();
  }
}

final class _OnboardingHeader extends StatelessWidget {
  const _OnboardingHeader();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.how_to_reg_rounded,
            color: colorScheme.onPrimary,
            size: 28,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Set up VisitFlow',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'One secure workspace for your staff and visitor operations.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final class _LoadingPanel extends StatelessWidget {
  const _LoadingPanel({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 18),
          Text(message, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

final class _FailurePanel extends StatelessWidget {
  const _FailurePanel({
    required this.message,
    required this.onRetry,
    required this.onSignOut,
  });

  final String message;
  final VoidCallback? onRetry;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Icon(
          Icons.cloud_off_rounded,
          size: 44,
          color: Theme.of(context).colorScheme.error,
        ),
        const SizedBox(height: 16),
        Text(
          'We could not load your workspace',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: 22),
        FilledButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Try again'),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: onSignOut,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Sign out'),
        ),
      ],
    );
  }
}

final class _MessageBanner extends StatelessWidget {
  const _MessageBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, color: colorScheme.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

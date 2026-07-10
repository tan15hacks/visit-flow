import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_page_frame.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_validators.dart';

final class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

final class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmation = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authSessionControllerProvider);
    return AuthPageFrame(
      title: 'Create your account',
      description:
          'Create a staff account first. Organization setup starts after authentication.',
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, child) {
          return AutofillGroup(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (controller.errorMessage != null) ...[
                    AuthMessageBanner(
                      message: controller.errorMessage!,
                      isError: true,
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (controller.noticeMessage != null) ...[
                    AuthMessageBanner(
                      message: controller.noticeMessage!,
                      isError: false,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _emailController,
                    autofillHints: const [AutofillHints.email],
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    enabled: !controller.isBusy,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: AuthValidators.email,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    autofillHints: const [AutofillHints.newPassword],
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.next,
                    enabled: !controller.isBusy,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      helperText:
                          'At least 8 characters, including a letter and number.',
                      prefixIcon: const Icon(Icons.lock_outline_rounded),
                      suffixIcon: IconButton(
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        onPressed: controller.isBusy
                            ? null
                            : () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: AuthValidators.newPassword,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _confirmPasswordController,
                    autofillHints: const [AutofillHints.newPassword],
                    obscureText: _obscureConfirmation,
                    textInputAction: TextInputAction.done,
                    enabled: !controller.isBusy,
                    decoration: InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: const Icon(Icons.lock_reset_rounded),
                      suffixIcon: IconButton(
                        tooltip: _obscureConfirmation
                            ? 'Show confirmation'
                            : 'Hide confirmation',
                        onPressed: controller.isBusy
                            ? null
                            : () {
                                setState(() {
                                  _obscureConfirmation = !_obscureConfirmation;
                                });
                              },
                        icon: Icon(
                          _obscureConfirmation
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: controller.isBusy ? null : _submit,
                    icon: controller.isBusy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.person_add_alt_1_rounded),
                    label: Text(
                      controller.isBusy
                          ? 'Creating account…'
                          : 'Create account',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: controller.isBusy
                        ? null
                        : () {
                            controller.clearMessages();
                            context.go(AppRoutes.signIn);
                          },
                    child: const Text('I already have an account'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    await ref
        .read(authSessionControllerProvider)
        .signUp(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }
}

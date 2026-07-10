import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:visitflow_staff/app/router.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_page_frame.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_providers.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_validators.dart';

final class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

final class _SignInScreenState extends ConsumerState<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(authSessionControllerProvider);
    return AuthPageFrame(
      title: 'Welcome back',
      description:
          'Sign in to manage visitors, approvals, invitations, and check-ins.',
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
                    autofillHints: const [AutofillHints.password],
                    obscureText: _obscurePassword,
                    textInputAction: TextInputAction.done,
                    enabled: !controller.isBusy,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                    validator: AuthValidators.signInPassword,
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
                        : const Icon(Icons.login_rounded),
                    label: Text(controller.isBusy ? 'Signing in…' : 'Sign in'),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: controller.isBusy
                        ? null
                        : () {
                            controller.clearMessages();
                            context.go(AppRoutes.signUp);
                          },
                    child: const Text('Create a VisitFlow account'),
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
        .signIn(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }
}

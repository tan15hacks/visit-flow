import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';

final authSessionControllerProvider = Provider<AuthSessionController>((ref) {
  throw StateError(
    'AuthSessionController must be overridden during bootstrap.',
  );
});

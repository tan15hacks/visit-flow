import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_access_controller.dart';

final organizationAccessControllerProvider =
    Provider<OrganizationAccessController>((ref) {
      throw StateError(
        'OrganizationAccessController must be overridden during bootstrap.',
      );
    });

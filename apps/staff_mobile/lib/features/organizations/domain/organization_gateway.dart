import 'package:visitflow_staff/features/organizations/domain/organization_membership.dart';

abstract interface class OrganizationGateway {
  Future<List<OrganizationMembership>> loadActiveMemberships();

  Future<String> createOrganization({
    required String name,
    required String slug,
    required String timezone,
  });
}

final class OrganizationFailure implements Exception {
  const OrganizationFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

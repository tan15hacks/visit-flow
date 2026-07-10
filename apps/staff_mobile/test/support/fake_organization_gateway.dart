import 'package:visitflow_staff/features/organizations/domain/organization_gateway.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_membership.dart';

final class FakeOrganizationGateway implements OrganizationGateway {
  FakeOrganizationGateway({
    List<OrganizationMembership> memberships = const [],
  }) : _memberships = List.of(memberships);

  List<OrganizationMembership> _memberships;

  OrganizationFailure? loadFailure;
  OrganizationFailure? createFailure;
  int loadCalls = 0;
  int createCalls = 0;
  String? lastCreatedName;
  String? lastCreatedSlug;
  String? lastCreatedTimezone;

  @override
  Future<List<OrganizationMembership>> loadActiveMemberships() async {
    loadCalls++;
    final failure = loadFailure;
    if (failure != null) {
      throw failure;
    }
    return List.unmodifiable(_memberships);
  }

  @override
  Future<String> createOrganization({
    required String name,
    required String slug,
    required String timezone,
  }) async {
    createCalls++;
    lastCreatedName = name;
    lastCreatedSlug = slug;
    lastCreatedTimezone = timezone;
    final failure = createFailure;
    if (failure != null) {
      throw failure;
    }

    const organizationId = 'organization-1';
    _memberships = [
      OrganizationMembership(
        id: 'membership-1',
        role: 'owner',
        organization: OrganizationSummary(
          id: organizationId,
          name: name,
          slug: slug,
          timezone: timezone,
        ),
      ),
    ];
    return organizationId;
  }
}

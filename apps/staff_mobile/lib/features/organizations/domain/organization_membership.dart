final class OrganizationSummary {
  const OrganizationSummary({
    required this.id,
    required this.name,
    required this.slug,
    required this.timezone,
  });

  final String id;
  final String name;
  final String slug;
  final String timezone;
}

final class OrganizationMembership {
  const OrganizationMembership({
    required this.id,
    required this.role,
    required this.organization,
  });

  final String id;
  final String role;
  final OrganizationSummary organization;
}

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_gateway.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_membership.dart';

final class SupabaseOrganizationGateway implements OrganizationGateway {
  const SupabaseOrganizationGateway(this._client);

  final SupabaseClient _client;

  @override
  Future<List<OrganizationMembership>> loadActiveMemberships() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) {
      throw const OrganizationFailure(
        'Your session expired. Sign in again before continuing.',
      );
    }

    try {
      final List<Map<String, dynamic>> membershipRows = await _client
          .from('organization_members')
          .select('id, organization_id, role')
          .eq('user_id', userId)
          .eq('status', 'active')
          .order('created_at');

      if (membershipRows.isEmpty) {
        return const [];
      }

      final organizationIds = <String>{
        for (final row in membershipRows)
          _readRequiredString(row, 'organization_id'),
      }.toList(growable: false);

      final List<Map<String, dynamic>> organizationRows = await _client
          .from('organizations')
          .select('id, name, slug, timezone')
          .inFilter('id', organizationIds);

      final organizationsById = <String, OrganizationSummary>{
        for (final row in organizationRows)
          _readRequiredString(row, 'id'): OrganizationSummary(
            id: _readRequiredString(row, 'id'),
            name: _readRequiredString(row, 'name'),
            slug: _readRequiredString(row, 'slug'),
            timezone: _readRequiredString(row, 'timezone'),
          ),
      };

      final memberships = <OrganizationMembership>[];
      for (final row in membershipRows) {
        final organizationId = _readRequiredString(row, 'organization_id');
        final organization = organizationsById[organizationId];
        if (organization == null) {
          throw const OrganizationFailure(
            'An organization membership could not be resolved safely.',
          );
        }
        memberships.add(
          OrganizationMembership(
            id: _readRequiredString(row, 'id'),
            role: _readRequiredString(row, 'role'),
            organization: organization,
          ),
        );
      }
      return memberships;
    } on PostgrestException catch (error) {
      throw OrganizationFailure(_friendlyMessage(error));
    }
  }

  @override
  Future<String> createOrganization({
    required String name,
    required String slug,
    required String timezone,
  }) async {
    if (_client.auth.currentUser == null) {
      throw const OrganizationFailure(
        'Your session expired. Sign in again before continuing.',
      );
    }

    try {
      final Object? response = await _client.rpc(
        'create_organization',
        params: {'p_name': name, 'p_slug': slug, 'p_timezone': timezone},
      );
      if (response is! String || response.isEmpty) {
        throw const OrganizationFailure(
          'VisitFlow could not confirm the new organization.',
        );
      }
      return response;
    } on PostgrestException catch (error) {
      throw OrganizationFailure(_friendlyMessage(error));
    }
  }

  String _readRequiredString(Map<String, dynamic> row, String key) {
    final Object? value = row[key];
    if (value is! String || value.isEmpty) {
      throw const OrganizationFailure(
        'VisitFlow received incomplete organization data.',
      );
    }
    return value;
  }

  String _friendlyMessage(PostgrestException error) {
    final message = error.message.toLowerCase();
    if (error.code == '23505' || message.contains('slug already exists')) {
      return 'That workspace address is already in use.';
    }
    if (message.contains('organization name')) {
      return 'Enter an organization name between 2 and 120 characters.';
    }
    if (message.contains('organization slug')) {
      return 'Use a workspace address with lowercase letters, numbers, and hyphens.';
    }
    if (message.contains('organization timezone')) {
      return 'Enter a valid timezone such as Asia/Manila.';
    }
    if (error.code == '42501' || message.contains('authentication required')) {
      return 'Your session expired. Sign in again before continuing.';
    }
    return 'Organization setup could not be completed. Check your connection and try again.';
  }
}

import 'package:flutter_test/flutter_test.dart';
import 'package:visitflow_staff/features/authentication/domain/auth_user.dart';
import 'package:visitflow_staff/features/authentication/presentation/auth_session_controller.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_gateway.dart';
import 'package:visitflow_staff/features/organizations/domain/organization_membership.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_access_controller.dart';

import '../../support/fake_auth_gateway.dart';
import '../../support/fake_organization_gateway.dart';

void main() {
  test('signed-in user without memberships needs an organization', () async {
    final authGateway = FakeAuthGateway(
      currentUser: const AuthUser(id: 'user-1', email: 'owner@example.com'),
    );
    final authController = AuthSessionController(gateway: authGateway);
    final organizationGateway = FakeOrganizationGateway();
    final controller = OrganizationAccessController(
      gateway: organizationGateway,
      authController: authController,
    );
    addTearDown(() async {
      controller.dispose();
      authController.dispose();
      await authGateway.dispose();
    });

    await _settleController();

    expect(controller.status, OrganizationAccessStatus.needsOrganization);
    expect(controller.memberships, isEmpty);
    expect(organizationGateway.loadCalls, 1);
  });

  test('organization creation refreshes membership and opens workspace', () async {
    final authGateway = FakeAuthGateway(
      currentUser: const AuthUser(id: 'user-1', email: 'owner@example.com'),
    );
    final authController = AuthSessionController(gateway: authGateway);
    final organizationGateway = FakeOrganizationGateway();
    final controller = OrganizationAccessController(
      gateway: organizationGateway,
      authController: authController,
    );
    addTearDown(() async {
      controller.dispose();
      authController.dispose();
      await authGateway.dispose();
    });

    await _settleController();
    await controller.createOrganization(
      name: 'Acme Office',
      slug: 'acme-office',
      timezone: 'Asia/Manila',
    );

    expect(controller.status, OrganizationAccessStatus.ready);
    expect(controller.selectedMembership?.role, 'owner');
    expect(controller.selectedMembership?.organization.name, 'Acme Office');
    expect(organizationGateway.createCalls, 1);
    expect(organizationGateway.loadCalls, 2);
  });

  test('repository failure is recoverable through refresh', () async {
    final authGateway = FakeAuthGateway(
      currentUser: const AuthUser(id: 'user-1', email: 'owner@example.com'),
    );
    final authController = AuthSessionController(gateway: authGateway);
    final organizationGateway = FakeOrganizationGateway()
      ..loadFailure = const OrganizationFailure('Temporary failure.');
    final controller = OrganizationAccessController(
      gateway: organizationGateway,
      authController: authController,
    );
    addTearDown(() async {
      controller.dispose();
      authController.dispose();
      await authGateway.dispose();
    });

    await _settleController();

    expect(controller.status, OrganizationAccessStatus.failure);
    expect(controller.errorMessage, 'Temporary failure.');

    organizationGateway.loadFailure = null;
    await controller.refresh();

    expect(controller.status, OrganizationAccessStatus.needsOrganization);
    expect(controller.errorMessage, isNull);
  });

  test('signing out clears organization access', () async {
    final authGateway = FakeAuthGateway(
      currentUser: const AuthUser(id: 'user-1', email: 'owner@example.com'),
    );
    final authController = AuthSessionController(gateway: authGateway);
    final organizationGateway = FakeOrganizationGateway(
      memberships: const [
        OrganizationMembership(
          id: 'membership-1',
          role: 'owner',
          organization: OrganizationSummary(
            id: 'organization-1',
            name: 'Acme Office',
            slug: 'acme-office',
            timezone: 'Asia/Manila',
          ),
        ),
      ],
    );
    final controller = OrganizationAccessController(
      gateway: organizationGateway,
      authController: authController,
    );
    addTearDown(() async {
      controller.dispose();
      authController.dispose();
      await authGateway.dispose();
    });

    await _settleController();
    expect(controller.status, OrganizationAccessStatus.ready);

    await authController.signOut();

    expect(controller.status, OrganizationAccessStatus.signedOut);
    expect(controller.memberships, isEmpty);
    expect(controller.selectedMembership, isNull);
  });
}

Future<void> _settleController() async {
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:visitflow_staff/features/organizations/presentation/organization_validators.dart';

void main() {
  test('generates a normalized workspace slug from the organization name', () {
    expect(
      OrganizationValidators.slugFromName('  Acme Main Office!  '),
      'acme-main-office',
    );
  });

  test('validates organization fields before submission', () {
    expect(OrganizationValidators.name('A'), isNotNull);
    expect(OrganizationValidators.name('Acme Office'), isNull);
    expect(OrganizationValidators.slug('Acme Office'), isNotNull);
    expect(OrganizationValidators.slug('acme-office'), isNull);
    expect(OrganizationValidators.timezone('Manila'), isNotNull);
    expect(OrganizationValidators.timezone('Asia/Manila'), isNull);
  });
}

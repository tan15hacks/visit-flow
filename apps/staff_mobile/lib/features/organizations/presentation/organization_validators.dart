abstract final class OrganizationValidators {
  static final RegExp _slugPattern = RegExp(
    r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
  );
  static final RegExp _timezonePattern = RegExp(
    r'^(?:UTC|[A-Za-z0-9_+.-]+(?:/[A-Za-z0-9_+.-]+)+)$',
  );

  static String slugFromName(String value) {
    final normalized = value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    if (normalized.length <= 63) {
      return normalized;
    }
    return normalized.substring(0, 63).replaceFirst(RegExp(r'-+$'), '');
  }

  static String? name(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.length < 2) {
      return 'Enter at least 2 characters.';
    }
    if (normalized.length > 120) {
      return 'Use no more than 120 characters.';
    }
    return null;
  }

  static String? slug(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.length < 3 || normalized.length > 63) {
      return 'Use between 3 and 63 characters.';
    }
    if (!_slugPattern.hasMatch(normalized)) {
      return 'Use lowercase letters, numbers, and single hyphens only.';
    }
    return null;
  }

  static String? timezone(String? value) {
    final normalized = value?.trim() ?? '';
    if (normalized.isEmpty) {
      return 'Enter your organization timezone.';
    }
    if (normalized.length > 100 || !_timezonePattern.hasMatch(normalized)) {
      return 'Use a timezone such as Asia/Manila.';
    }
    return null;
  }
}

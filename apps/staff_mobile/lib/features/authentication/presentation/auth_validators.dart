abstract final class AuthValidators {
  static String? email(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) {
      return 'Enter your email address.';
    }
    final parts = email.split('@');
    if (parts.length != 2 ||
        parts.first.isEmpty ||
        !parts.last.contains('.') ||
        parts.last.endsWith('.')) {
      return 'Enter a valid email address.';
    }
    return null;
  }

  static String? signInPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password.';
    }
    return null;
  }

  static String? newPassword(String? value) {
    final password = value ?? '';
    if (password.length < 8) {
      return 'Use at least 8 characters.';
    }
    if (!RegExp('[A-Za-z]').hasMatch(password) ||
        !RegExp('[0-9]').hasMatch(password)) {
      return 'Include at least one letter and one number.';
    }
    return null;
  }
}

class Validator {
  // Email Validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password Validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    // String pattern =
    //     r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$';
    // RegExp regExp = RegExp(pattern);
    // if (!regExp.hasMatch(value)) {
    //   return 'Password must contain at least one letter, one number, and one special character';
    // }
    return null;
  }

  static String? validateOldPassword(String? value, String storedOldPassword) {
    if (value == null || value.isEmpty) {
      return 'Please enter the old password';
    }
    if (value != storedOldPassword) {
      return 'Old password is incorrect';
    }
    return null;
  }

  static String? validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    String pattern =
        r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regExp = RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return 'Password must contain at least one letter, one number, and one special character';
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String newPassword) {
    if (value != newPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}

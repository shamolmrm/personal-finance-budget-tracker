class Validators {
  static String? email(String? v) {
    if (v == null || v.isEmpty) return 'Email is required';
    final r = RegExp(r"^[^@\s]+@[^@\s]+\.[^@\s]+$");
    if (!r.hasMatch(v)) return 'Invalid email';
    return null;
  }

  static String? password(String? v) {
    if (v == null || v.length < 8) return 'Password must be at least 8 characters';
    return null;
  }
}

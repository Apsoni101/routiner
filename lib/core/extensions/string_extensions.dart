extension EmailValidator on String {
  bool get isValidEmail {
    final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(this);
  }
}

extension PasswordValidator on String {
  bool get isValidPassword {
    final RegExp passwordRegex = RegExp(r'^.{6,}$');
    return passwordRegex.hasMatch(this);
  }
}
extension SafeIntParsing on String? {
  /// Safely parses a string into int. Returns null if invalid.
  int? toSafeInt() {
    if (this == null) return null;
    try {
      return int.parse(this!);
    } catch (_) {
      return null;
    }
  }
}

extension SafeIntParsingFromDynamic on dynamic {
  /// Converts dynamic to int safely.
  int? toIntSafe() {
    if (this == null) return null;
    if (this is int) return this as int;
    return this.toString().toSafeInt();
  }
}

extension FirestoreDocIdExtension on String {
  String toDocId() {
    return trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  }
}

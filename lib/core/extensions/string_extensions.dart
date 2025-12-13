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

class Utils {
  static final RegExp _emailRegX =
  RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static bool isEmailValid(String email) {
    return _emailRegX.hasMatch(email);
  }

  static final _passwordRegex =
  RegExp(r"(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[@%!#*?&])(?=.*\W)");

  static bool isPasswordValid(String password) {
    return _passwordRegex.hasMatch(password);
  }

  static bool isValidContact(String contact) {
    return contact.length == 10;
  }
}

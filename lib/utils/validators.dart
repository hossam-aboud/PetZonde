class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );
  static final RegExp _passwordRegExp = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$'
  );

  static final RegExp _phoneRegExpregex = RegExp(r'^.?[0-9]{10}$');

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidPasswordConfirm(String pass, String passConfirm) {
    if (pass ==
        passConfirm) {
      return true;
    }
    return false;

  }

  static isValidPhone(String phone) {
    return _phoneRegExpregex.hasMatch(phone);
  }

}
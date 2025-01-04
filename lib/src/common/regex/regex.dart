class Regexes {
  static const mobileNumberRegex =
      r'^((\+820?|\+82|\+1|\+855|\+880|\+84| 0?|0)(((1[16789]{1}|2|50\d{1}|[3-9]{1}\d{1})\d{3,4})|(10\d{4}))|\d{4})\d{4}$';
  static const emailRegex =
      r'^[0-9a-zA-Z][0-9a-zA-Z-_.]*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,4}$';

  static bool isValidMobileNumber(String mobileNumber) {
    return RegExp(mobileNumberRegex).hasMatch(mobileNumber);
  }

  static bool isValidEmail(String email) {
    return RegExp(emailRegex).hasMatch(email);
  }
}

extension StringCheker on String? {
  bool isNullOrEmpty() {
    return this == null || this?.isEmpty == true;
  }

  bool isNotNullNotEmpty() {
    return this?.isNotEmpty ?? false;
  }
}

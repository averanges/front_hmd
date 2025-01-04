class SignupUserRequest {
  final String name;
  final String phoneNum;
  final String email;

  SignupUserRequest({
    required this.name,
    required this.phoneNum,
    required this.email,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone_num': phoneNum,
      'email': email,
    };
  }
}

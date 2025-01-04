import 'package:haimdall/src/common/alias/alias.dart';
import 'package:haimdall/src/domain/model/signup/project/project_info.dart';
import 'package:haimdall/src/domain/model/signup/user/signed_up_user_info.dart';

abstract class SignupRepository {
  Future<Result<void>> signupUser(String name, String phoneNum, String email);

  Future<Result<List<ProjectInfo>>> getProjectList();

  Future<Result<void>> selectProject(int projectId);

  Future<Result<SignedUpUserInfo>> getUserInfo();

  Future<Result<void>> completeTutorial();

  Future<Result<String>> getPrivacyPolicyTermsUrl();

  Future<Result<String>> getServiceTermsUrl();
}

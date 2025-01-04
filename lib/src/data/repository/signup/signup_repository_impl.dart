import 'package:haimdall/src/common/alias/alias.dart';
import 'package:haimdall/src/common/either/either.dart';
import 'package:haimdall/src/data/network/model/request/signup/signup_user_request.dart';
import 'package:haimdall/src/data/network/network.dart';
import 'package:haimdall/src/domain/model/signup/project/project_info.dart';
import 'package:haimdall/src/domain/model/signup/user/signed_up_user_info.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';

class SignupRepositoryImpl extends SignupRepository {
  final SignupApi _api;

  SignupRepositoryImpl(this._api);

  @override
  Future<Result<void>> signupUser(
    String name,
    String phoneNum,
    String email,
  ) async {
    final result = await _api.patchUser(
      SignupUserRequest(
        name: name,
        phoneNum: phoneNum,
        email: email,
      ),
    );

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<List<ProjectInfo>>> getProjectList() async {
    final result = await _api.getProjectList();

    if (result.isSuccess()) {
      final data = (result as Success).value;
      final projectList = data['project_list']
          .map<ProjectInfo>(
              (e) => ProjectInfo.fromJson(e as Map<String, dynamic>))
          .toList();

      return Right(projectList);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> selectProject(int projectId) async {
    final result = await _api.selectProject(projectId);

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<SignedUpUserInfo>> getUserInfo() async {
    final result = await _api.getUserInfo();

    if (result.isSuccess()) {
      final data = (result as Success).value as Map<String, dynamic>;
      final userInfo = SignedUpUserInfo.fromJson(data);

      return Right(userInfo);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<void>> completeTutorial() async {
    final result = await _api.patchTutorialStatus();

    if (result.isSuccess()) {
      return const Right(null);
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<String>> getPrivacyPolicyTermsUrl() async {
    final result = await _api.getTermsUrl('PRIVACY_POLICY');

    if (result.isSuccess()) {
      final data = (result as Success).value;
      return Right(data['url'] ?? '');
    } else {
      return Left((result as Failure).exception);
    }
  }

  @override
  Future<Result<String>> getServiceTermsUrl() async {
    final result = await _api.getTermsUrl('TERMS_OF_USE');

    if (result.isSuccess()) {
      final data = (result as Success).value;
      return Right(data['url'] ?? '');
    } else {
      return Left((result as Failure).exception);
    }
  }
}

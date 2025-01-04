part of '../network.dart';

class SignupApi {
  final _client = NetworkClient.getApiClient();

  // https://www.zerostudiobackend.site/haimdall/docs#/User/UserController_updateUserInfo
  // [PATCH] User 정보 업데이트 api
  Future<NetworkResult> patchUser(SignupUserRequest request) {
    return _client.patch(
      uri: NetworkConstants.uriUser,
      body: request.toJson(),
    );
  }

  // https://www.zerostudiobackend.site/haimdall/docs#/Project/ProjectController_getProjectList
  // [GET] 프로젝트 리스트 조회 api
  Future<NetworkResult> getProjectList() {
    return _client.get(uri: NetworkConstants.uriProjectList);
  }

  // https://www.zerostudiobackend.site/haimdall/docs#/User/UserController_updateUserProject
  // [PATCH] 유저 프로젝트 선택 api
  Future<NetworkResult> selectProject(int projectId) {
    return _client.patch(
      uri: NetworkConstants.uriUpdateCurrentProject,
      body: {'cur_project_id': projectId},
    );
  }

  // https://www.zerostudiobackend.site/haimdall/docs#/User/UserController_getUserInfo
  // [GET] User 정보 조회 api
  Future<NetworkResult> getUserInfo() {
    return _client.get(uri: NetworkConstants.uriUser);
  }

  // [PATCH] 튜토리얼 완료 api
  Future<NetworkResult> patchTutorialStatus() {
    return _client.patch(
      uri: NetworkConstants.uriUpdateTutorialStatus,
      body: {'status': true},
    );
  }

  // [GET] 약관 pdf url
  Future<NetworkResult> getTermsUrl(String type) {
    return _client.get(uri: '${NetworkConstants.uriUserTermsUrl}?type=$type');
  }
}

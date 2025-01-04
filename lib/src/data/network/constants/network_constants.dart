part of '../network.dart';

class NetworkConstants {
  NetworkConstants._();

  // Auth
  static const String uriAuthGoogle = 'auth/google';
  static const String uriAuthApple = 'auth/apple';
  static const String uriAuthUser = 'auth/user';

  // User
  static const String uriApprovalStatus =
      'user/approval_status'; // 유저 승인 상태 업데이트
  static const String uriUserList = 'user/list'; // 유저 리스트 조회
  static const String uriUser = 'user'; // GET / PATCH
  static const String uriUpdateCurrentProject =
      'user/project'; // 유저 프로젝트 업데이트
  static const String uriUpdateTutorialStatus =
      'user/tutorial_status'; // 튜토리얼 상태 업데이트
  static const String uriUserTermsUrl = 'user/terms_url'; // GET 약관 URL 조회
  static const String uriFCMToken = 'user/fcm_token'; // PATCH FCM 토큰 등록
  static const String uriUserAlarmControl =
      'user/alarm_control'; // PATCH 알람 제어

  // Project
  static const String uriProjectList = 'project/list'; // 프로젝트 리스트 조회
  static const String uriProject = 'project'; // POST 프로젝트 생성
  static const String uriProjectStatus =
      'project/status'; // 프로젝트 상태 변경 api (PATCH)

  // Farmland
  static const String uriFarmlandBasicInfo =
      'farmland/basic_info'; // PATCH 농지 기본 정보 등록
  static const String uriFarmlandPlanting =
      'farmland/planting'; // PATCH 농지 농사 정보 등록
  static const String uriFarmlandWatering =
      'farmland/watering'; // POST 농지 펌프 일지 등록 / PATCH 물빼기 기록 (사진 업로드)
  static const String uriFarmlandDrain = 'farmland/drain'; // PATCH 농지 물빼기 일정 등록
  static const String uriFarmlandWateringCount =
      'farmland/watering_count'; // GET 펌프 횟수
  static const String uriFarmlandDateData =
      'farmland/date_data'; // GET 농지 기본 날짜 정보 GET
  static const String uriFarmlandRecord =
      'farmland/record'; // POST 농사 정보 기록 (비료, 농약) / GET 농지 기록정보 가져오기
  static const String uriFarmlandCompleteProject =
      'farmland/complete_project'; // PATCH 해당 농지의 프로젝트 진행 상태를 완료로 변경
  static const String uriFarmlandList = 'farmland/list'; // GET 유저의 농지 리스트 가져오기
  static const String uriFarmland = 'farmland'; // POST 농지 생성
  static const String uriFarmlandAwdChange =
      'farmland/awd_change'; // POST 물빼기 일정 변경 요청
  static const String uriFarmlandAwdChangeList = 'farmland/awd_change/list'; // GET AWD 스케쥴 변경 요청 이력 조회
  static const String uriFarmlandPumpChange =
      'farmland/pump_change'; // POST 펌프 일정 변경 요청
  static const String uriFarmlandPumpChangeList = 'farmland/pump_change/list'; // GET 펌프 스케쥴 변경 요청 이력 조회
  static const String uriFarmlandPump = 'farmland/pump'; // PATCH 농지 펌프 On/Off
  static const String uriFarmlandAwdStatus =
      'farmland/awd_status'; // GET AWD 진행 상태 조회
}

import 'package:get/get.dart';
import 'package:haimdall/src/presentation/awd/awd_page.dart';
import 'package:haimdall/src/presentation/farming/input_drain_water_planting/input_drain_water_planting_page.dart';
import 'package:haimdall/src/presentation/farming/input_pump_planting/input_pump_planting_page.dart';
import 'package:haimdall/src/presentation/farming/input_rice_planting/input_rice_planting_page.dart';
import 'package:haimdall/src/presentation/farmland/add/binding/farmland_add_binding.dart';
import 'package:haimdall/src/presentation/farmland/add/farmland_add_page.dart';
import 'package:haimdall/src/presentation/farmland/add/photo/farmland_add_photo_page.dart';
import 'package:haimdall/src/presentation/farmland/home/binding/farmland_home_binding.dart';
import 'package:haimdall/src/presentation/farmland/home/farmland_home_page.dart';
import 'package:haimdall/src/presentation/farmland/home/progress/farmland_progress_page.dart';
import 'package:haimdall/src/presentation/farmland/home/record/drain_water/drain_water_record_page.dart';
import 'package:haimdall/src/presentation/farmland/home/record/fertilizer/fertilizer_record_page.dart';
import 'package:haimdall/src/presentation/farmland/home/record/harvest/harvest_record_page.dart';
import 'package:haimdall/src/presentation/farmland/home/record/pesticide/pesticide_record_page.dart';
import 'package:haimdall/src/presentation/farmland/list/binding/farmland_list_binding.dart';
import 'package:haimdall/src/presentation/farmland/list/farmland_list_page.dart';
import 'package:haimdall/src/presentation/history/change/awd/awd_change_request_history_page.dart';
import 'package:haimdall/src/presentation/history/change/pump/pump_change_request_history_page.dart';
import 'package:haimdall/src/presentation/localization/binding/localizaition_binding.dart';
import 'package:haimdall/src/presentation/localization/localization_page.dart';
import 'package:haimdall/src/presentation/login/binding/login_binding.dart';
import 'package:haimdall/src/presentation/login/login_page.dart';
import 'package:haimdall/src/presentation/onbaoarding/binding/onboarding_binding.dart';
import 'package:haimdall/src/presentation/onbaoarding/onboarding_page.dart';
import 'package:haimdall/src/presentation/schedule/drain_water/awd_schedule_change_request_page.dart';
import 'package:haimdall/src/presentation/schedule/pump/pump_schedule_change_request_page.dart';
import 'package:haimdall/src/presentation/signup/binding/signup_binding.dart';
import 'package:haimdall/src/presentation/signup/denied/signup_denied_page.dart';
import 'package:haimdall/src/presentation/signup/project/binding/signup_project_binding.dart';
import 'package:haimdall/src/presentation/signup/project/signup_project_page.dart';
import 'package:haimdall/src/presentation/signup/signup_page.dart';
import 'package:haimdall/src/presentation/signup/waiting/signup_waiting_page.dart';
import 'package:haimdall/src/presentation/splash/binding/spalsh_binding.dart';
import 'package:haimdall/src/presentation/splash/splash_page.dart';
import 'package:haimdall/src/presentation/terms/binding/terms_binding.dart';
import 'package:haimdall/src/presentation/terms/terms_page.dart';
import 'package:haimdall/src/presentation/web/binding/web_binding.dart';
import 'package:haimdall/src/presentation/web/pdf/pdf_page.dart';
import 'package:haimdall/src/presentation/web/web_page.dart';

class AppRoute {
  const AppRoute._();

  static const splashPage = '/';
  static const loginPage = '/login';
  static const localizationPage = '/localization';
  static const termsPage = '/terms';
  static const web = '/web';
  static const pdf = '/pdf';
  static const awd = '/awd';
  static const signup = '/signup';
  static const signupSelectProject = '/signup/select_project';
  static const signupWaiting = '/signup/waiting';
  static const signupRejected = '/signup/rejected';
  static const onboarding = '/onboarding';
  static const farmlandList = '/farmland/list';
  static const farmlandAdd = '/farmland/add';
  static const farmlandAddPhoto = '/farmland/add/photo';
  static const farmlandHome = '/farmland/home';
  static const farmlandProgress = '/farmland/progress';
  static const farmingInfoRicePlanting = '/farming/info/rice_planting';
  static const farmingInfoPumpPlanting = '/farming/info/pump_planting';
  static const farmingInfoDrainWaterPlanting =
      '/farming/info/drain_water_planting';
  static const farmlandRecordPesticide = '/farmland/record/pesticide';
  static const farmlandRecordHarvest = '/farmland/record/harvest';
  static const farmlandRecordFertilizer = '/farmland/record/fertilizer';
  static const farmlandRecordDrainWater = '/farmland/record/drain_water';
  static const awdChangeRequestHistory = '/history/change_request/awd';
  static const pumpChangeRequestHistory = '/history/change_request/pump';
  static const awdScheduleChangeRequest = '/schedule/change_request/awd';
  static const pumpScheduleChangeRequest = '/schedule/change_request/pump';
}

List<GetPage> pages = [
  // Splash
  GetPage(
    name: AppRoute.splashPage,
    page: () => const SplashPage(),
    binding: SplashBinding(),
    transition: Transition.noTransition,
  ),
  // Login
  GetPage(
    name: AppRoute.loginPage,
    page: () => const LoginPage(),
    binding: LoginBinding(),
    transition: Transition.noTransition,
  ),
  // Localization
  GetPage(
    name: AppRoute.localizationPage,
    page: () => const LocalizationPage(),
    binding: LocalizationBinding(),
  ),
  // 개인정보 약관 동의
  GetPage(
    name: AppRoute.termsPage,
    page: () => const TermsPage(),
    binding: TermsBinding(),
  ),
  // Web Page
  GetPage(
    name: AppRoute.web,
    page: () => const WebPage(),
    binding: WebBinding(),
  ),
  // PDF Page
  GetPage(
    name: AppRoute.pdf,
    page: () => const PdfPage(),
  ),
  // AWD 교육 자료 뷰
  GetPage(
    name: AppRoute.awd,
    page: () => const AwdPage(),
  ),
  // 회원가입 (가입 정보 입력)
  GetPage(
    name: AppRoute.signup,
    page: () => const SignupPage(),
    binding: SignupBinding(),
  ),
  // 회원가입 (프로젝트 선택)
  GetPage(
    name: AppRoute.signupSelectProject,
    page: () => const SignupProjectPage(),
    binding: SignupProjectBinding(),
  ),
  // 회원가입 (승인대기)
  GetPage(
    name: AppRoute.signupWaiting,
    page: () => const SignupWaitingPage(),
  ),
  // 회원가입 (승인거절)
  GetPage(
    name: AppRoute.signupRejected,
    page: () => const SignupDeniedPage(),
  ),
  // 온보딩 (튜토리얼)
  GetPage(
    name: AppRoute.onboarding,
    page: () => const OnboardingPage(),
    binding: OnboardingBinding(),
  ),
  // 농지 리스트
  GetPage(
    name: AppRoute.farmlandList,
    page: () => const FarmlandListPage(),
    binding: FarmlandListBinding(),
  ),
  // 농지 추가
  GetPage(
    name: AppRoute.farmlandAdd,
    page: () => const FarmlandAddPage(),
    binding: FarmlandAddBinding(),
  ),
  // 농지 추가 (사진촬영, 위치정보)
  GetPage(
    name: AppRoute.farmlandAddPhoto,
    page: () => const FarmlandAddPhotoPage(),
  ),
  // 농지 메인 화면
  GetPage(
    name: AppRoute.farmlandHome,
    page: () => const FarmlandHomePage(),
    binding: FarmLandHomeBinding(),
  ),
  // AWD 진행 현황
  GetPage(
    name: AppRoute.farmlandProgress,
    page: () => const FarmlandProgressPage(),
  ),
  // 농사 정보 입력 (모내기)
  GetPage(
    name: AppRoute.farmingInfoRicePlanting,
    page: () => const InputRicePlantingPage(),
  ),
  // 펌프 일정 등록
  GetPage(
    name: AppRoute.farmingInfoPumpPlanting,
    page: () => const InputPumpPlantingPage(),
  ),
  // 물 빼기 일정 등록
  GetPage(
    name: AppRoute.farmingInfoDrainWaterPlanting,
    page: () => const InputDrainWaterPlantingPage(),
  ),
  // 농약 기록 화면
  GetPage(
    name: AppRoute.farmlandRecordPesticide,
    page: () => const PesticideRecordPage(),
  ),
  // 수확량 입력 화면
  GetPage(
    name: AppRoute.farmlandRecordHarvest,
    page: () => const HarvestRecordPage(),
  ),
  // 비료 입력 화면
  GetPage(
    name: AppRoute.farmlandRecordFertilizer,
    page: () => const FertilizerRecordPage(),
  ),
  // 물빼기 사진 인증 화면
  GetPage(
    name: AppRoute.farmlandRecordDrainWater,
    page: () => const DrainWaterRecordPage(),
  ),
  // AWD 일정 변경 요청 내역
  GetPage(
    name: AppRoute.awdChangeRequestHistory,
    page: () => const AwdChangeRequestHistoryPage(),
  ),
  // 펌프 일정 변경 요청 내역
  GetPage(
    name: AppRoute.pumpChangeRequestHistory,
    page: () => const PumpChangeRequestHistoryPage(),
  ),
  // AWD 일정 변경 요청
  GetPage(
    name: AppRoute.awdScheduleChangeRequest,
    page: () => const AwdScheduleChangeRequestPage(),
  ),
  // 펌프 일정 변경 요청
  GetPage(
    name: AppRoute.pumpScheduleChangeRequest,
    page: () => const PumpScheduleChangeRequestPage(),
  ),
];

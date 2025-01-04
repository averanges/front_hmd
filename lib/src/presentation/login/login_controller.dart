import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:haimdall/src/common/logger/logger.dart';
import 'package:haimdall/src/common/manager/storage_manager/storage_manager.dart';
import 'package:haimdall/src/data/repository/injection/inject_repositories.dart';
import 'package:haimdall/src/domain/model/signup/user/signed_up_user_info.dart';
import 'package:haimdall/src/domain/repository/auth/auth_repository.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';
import 'package:haimdall/src/presentation/common/dialog/common_dialog.dart';
import 'package:haimdall/src/presentation/route/route.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    injectRepositories();
  }

  @override
  void onReady() {
    super.onReady();

    FirebaseAuth.instance.signOut();
  }

  void onClickedSelectLanguage() {
    // 국가/언어 선택
    Get.toNamed(AppRoute.localizationPage);
  }

  void onClickedGoogleLogin() async {
    // 구글 로그인
    const List<String> scopes = <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ];

    final googleSignIn = GoogleSignIn(scopes: scopes);
    try {
      final credential = await googleSignIn.signIn();

      if (credential != null) {
        final authentication = await credential.authentication;
        final idToken = authentication.idToken;

        final repo = Get.find<AuthRepository>();
        final result = await repo.loginWithGoogle(idToken ?? '');

        var token = '';
        if (result.isLeft) {
          // Error
          showErrorDialog(result.left.message);
          return;
        } else {
          // Success
          token = result.right['custom_token'];
        }

        try {
          final credential =
              await FirebaseAuth.instance.signInWithCustomToken(token);

          _checkUserStatus(credential);
        } on FirebaseAuthException catch (e) {
          Log.e('FirebaseAuthException', e);
          // FIXME: i18n
          showErrorDialog('로그인 실패');
          switch (e.code) {
            case 'invalid-custom-token':
              Log.e(
                'The supplied token is not a Firebase custom auth token.',
                e,
              );
              break;
            case 'custom-token-mismatch':
              Log.e(
                'The supplied token is for a different Firebase project.',
                e,
              );
              break;
            default:
              Log.e('Unkown error.', e);
          }
        }
      } else {
        // Do Nothing
      }
    } catch (error) {
      // 로그인 취소 혹은 기타 에러
      Log.e('UnexpectedError', error);
      showErrorDialog(error.toString());
    }
  }

  void onClickedAppleLogin() async {
    // 애플 로그인
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        // webAuthenticationOptions: WebAuthenticationOptions(
        //   clientId: 'com.thankscarbon.haimdall.signin',
        //   redirectUri: Uri.parse(
        // //       "https://thankscarbon-fb81c.firebaseapp.com/__/auth/handler"),
        // 'thankscarbon-test.firebaseapp.com/__/auth/handler',
        // ),
      );

      final result = await Get.find<AuthRepository>().loginWithApple(
        credential.identityToken ?? '',
        credential.authorizationCode,
      );

      var token = '';
      if (result.isLeft) {
        // Error
        showErrorDialog(result.left.message);
        return;
      } else {
        // Success
        token = result.right['custom_token'];
      }

      try {
        final credential =
            await FirebaseAuth.instance.signInWithCustomToken(token);
        _checkUserStatus(credential);
      } on FirebaseAuthException catch (e) {
        // FIXME: i18n
        showErrorDialog('로그인 실패');
        switch (e.code) {
          case 'invalid-custom-token':
            Log.e('The supplied token is not a Firebase custom auth token.', e);
            break;
          case 'custom-token-mismatch':
            Log.e('The supplied token is for a different Firebase project.', e);
            break;
          default:
            Log.e('Unkown error.', e);
        }
      }
    } catch (error) {
      // 취소하거나 기타 오류 상황 발생시
      if (error is SignInWithAppleAuthorizationException &&
          error.code == AuthorizationErrorCode.canceled) {
        // Do Nothing
      } else {
        showErrorDialog(error.toString());
      }
    }
  }

  void _checkUserStatus(UserCredential credential) async {
    final user = credential.user;
    final storageManager = Get.find<StorageManager>();
    await storageManager.updateUser(user);
    if (user == null) {
      Log.i('User is currently signed out!');
    } else {
      Log.i('User is signed in!: $user');
    }

    final result = await Get.find<SignupRepository>().getUserInfo();

    if (result.isLeft) {
      showErrorDialog(result.left.message).then((value) {
        final userId = storageManager.userId;

        if (userId.contains('google')) {
          GoogleSignIn().signOut();
        }
      });
    } else {
      final fcmToken = await FirebaseMessaging.instance.getToken();
      Log.d('[FCM] token: $fcmToken');
      if (fcmToken != null) {
        await Get.find<AuthRepository>().updateFcmToken(fcmToken);
      }

      switch (result.right.status) {
        case UserStatus.approved:
          if (result.right.completedTutorial) {
            Get.offAllNamed(AppRoute.farmlandList);
          } else {
            Get.offAllNamed(AppRoute.onboarding);
          }
          break;
        case UserStatus.rejected:
          Get.offAllNamed(AppRoute.signupRejected);
          break;
        case UserStatus.pending:
          Get.offAllNamed(AppRoute.signupWaiting);
          break;
        case UserStatus.unrequested:
          Get.offAllNamed(AppRoute.termsPage);
          break;
      }
      injectRepositories();
    }
  }
}

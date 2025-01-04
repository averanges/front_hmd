import 'package:get/get.dart';
import 'package:haimdall/src/data/network/network.dart';
import 'package:haimdall/src/data/repository/auth/auth_repository_impl.dart';
import 'package:haimdall/src/data/repository/farmland/farmland_repository_impl.dart';
import 'package:haimdall/src/data/repository/signup/signup_repository_impl.dart';
import 'package:haimdall/src/domain/repository/auth/auth_repository.dart';
import 'package:haimdall/src/domain/repository/farmland/farmland_repository.dart';
import 'package:haimdall/src/domain/repository/signup/signup_repository.dart';

void injectRepositories() {
  // Initial Repositories
  Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl(authApi: AuthApi()));
  Get.lazyPut<SignupRepository>(() => SignupRepositoryImpl(SignupApi()));
  Get.lazyPut<FarmlandRepository>(() => FarmlandRepositoryImpl(FarmlandApi()));
}

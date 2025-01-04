import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';
import 'package:haimdall/env/resources/strings/strings.dart';
import 'package:haimdall/src/presentation/route/route.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.light,
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        primaryColor: AppColors.mainBlue,
      ),
      debugShowCheckedModeBanner: false,
      translations: Strings(),
      locale: const Locale('ko', 'KR'),
      fallbackLocale: const Locale('ko', 'KR'),
      initialRoute: AppRoute.splashPage,
      getPages: pages,
      builder: (context, child) {
        if (child == null) return Container();

        final data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child,
        );
      },
    );
  }
}

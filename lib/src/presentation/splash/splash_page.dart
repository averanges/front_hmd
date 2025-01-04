import 'package:flutter/material.dart';
import 'package:haimdall/env/resources/resources.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.splashBg,
      child: Center(
        child: AppImages.logo,
      ),
    );
  }
}

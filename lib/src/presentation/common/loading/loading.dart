import 'package:flutter/material.dart';
import 'package:haimdall/env/resources/resources.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({
    super.key,
    required this.isLoading,
    this.backgroundColor = Colors.black26,
  });

  final bool isLoading;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: Container(
        color: backgroundColor,
        alignment: Alignment.center,
        child: const Padding(
          padding: EdgeInsets.all(10.0),
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.enabledButton),
          ),
        ),
      ),
    );
  }
}

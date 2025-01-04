import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:haimdall/env/resources/resources.dart';

class TermsDescriptionWidget extends StatelessWidget {
  const TermsDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    switch (Get.locale) {
      case const Locale('ko_KR'):
        return _korean();
      case const Locale('en_US'):
        return _english();
      case const Locale('vi_VN'):
        return _vietnamese();
      case const Locale('km_KH'):
        return _cambodian();
      case const Locale('bn_BD'):
        return _bengali();
      default:
        return _korean();
    }
  }

  Widget _korean() => Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '저탄소,',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: ' 지구를 지키는 농업',
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: '헤임달',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: '과 함께하세요.',
                ),
              ],
            ),
          ),
        ],
      );

  Widget _english() => Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Low-carbon',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: ', earth-friendly farming',
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Join',
                ),
                TextSpan(
                  text: ' Haimdall',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: '.',
                ),
              ],
            ),
          ),
        ],
      );

  Widget _vietnamese() => Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Nông nghiệp',
                ),
                TextSpan(
                  text: ' phát thải thấp',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: ', bảo vệ trái đất',
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'Hãy đồng hành cùng',
                ),
                TextSpan(
                  text: ' Haimdall',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: '.',
                ),
              ],
            ),
          ),
        ],
      );

  Widget _cambodian() => Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'ការធ្វើកសិកម្មដែលមាន',
                ),
                TextSpan(
                  text: 'កាបូនទាប',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: ' និងការពារផែនដី',
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'ចូលរួមជាមួយ',
                ),
                TextSpan(
                  text: ' Haimdall',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: '។',
                ),
              ],
            ),
          ),
        ],
      );

  Widget _bengali() => Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'নিম্ন কার্বন',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: ', পৃথিবী-বান্ধব কৃষি',
                ),
              ],
            ),
          ),
          const SizedBox(height: 11),
          RichText(
            text: const TextSpan(
              style: TextStyle(
                color: AppColors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'হাইমডালের',
                  style: TextStyle(
                    color: AppColors.enabledButton,
                  ),
                ),
                TextSpan(
                  text: ' সাথে যোগ দিন।',
                ),
              ],
            ),
          ),
        ],
      );
}

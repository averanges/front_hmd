import 'package:flutter/material.dart';
import 'package:haimdall/env/resources/resources.dart';

enum Languages {
  english,
  korean,
  cambodian,
  bangladeshi,
  vietnamese;

  String get locale {
    switch (this) {
      case Languages.english:
        return 'en_US';
      case Languages.korean:
        return 'ko_KR';
      case Languages.cambodian:
        return 'km_KH';
      case Languages.bangladeshi:
        return 'bn_BD';
      case Languages.vietnamese:
        return 'vi_VN';
    }
  }

  String get name {
    switch (this) {
      case Languages.english:
        return 'English';
      case Languages.korean:
        return '한국어';
      case Languages.cambodian:
        return 'Phéasa Khmêr';
      case Languages.bangladeshi:
        return 'বাংলা(Bengali)';
      case Languages.vietnamese:
        return 'Tiếng Việt';
    }
  }

  Widget get icons {
    switch (this) {
      case Languages.english:
        return AppImages.icEnglish;
      case Languages.korean:
        return AppImages.icKorean;
      case Languages.cambodian:
        return AppImages.icCambodian;
      case Languages.bangladeshi:
        return AppImages.icHhangladashi;
      case Languages.vietnamese:
        return AppImages.icVietnam;
    }
  }

  String get phoneCountryCode {
    switch (this) {
      case Languages.english:
        return '+1';
      case Languages.korean:
        return '+82';
      case Languages.cambodian:
        return '+855';
      case Languages.bangladeshi:
        return '+880';
      case Languages.vietnamese:
        return '+84';
    }
  }

  String get faqUrl {
    switch (this) {
      case Languages.english:
        return 'https://thankscarbon.notion.site/FAQ-4f2aaa9c79834b4096dd638251052628';
      case Languages.korean:
        return 'https://thankscarbon.notion.site/FAQ-77f29c8586c244429e373095fee10c4a';
      case Languages.cambodian:
        return 'https://thankscarbon.notion.site/FAQ-a1beb41cd81a4cb28a6df65928a095b8';
      case Languages.bangladeshi:
        return 'https://thankscarbon.notion.site/FAQ-6de426fc45034e4a99b505b5fe670380';
      case Languages.vietnamese:
        return 'https://thankscarbon.notion.site/FAQ-707ba8f50436465c908ade5871ef6c1e';
    }
  }
}

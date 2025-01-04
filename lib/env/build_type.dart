enum BuildType {
  dev,
  production,
}

extension BuildTypeExtension on BuildType {
  String get baseUrl =>
      switch (this) {
        BuildType
            .dev => 'https://www.projecthaimdall.kr/haimdall/', //'https://www.zerostudiobackend.site/haimdall/',
        BuildType.production => 'https://www.projecthaimdall.kr/haimdall/',
      };
}

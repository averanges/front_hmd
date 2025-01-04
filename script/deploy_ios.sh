#! /bin/sh
echo "============= Start iOS Deploy =============";

flutter doctor

echo "=============  Start Build =============";

if flutter build ios --release --no-codesign --flavor production --target lib/env/production.dart; then
  echo "=============  iOS 빌드 성공 =============";
else
  echo "=============  iOS 빌드 실패 =============";
  exit 1;
fi

cd ios || exit

if bundle exec fastlane production; then
  echo "=============  iOS Fastlane 성공 =============";
else
  echo "=============  iOS Fastlane 실패 =============";
  exit 1;
fi

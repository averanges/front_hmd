#! /bin/sh
KEYSTORE_PATH="./android/haimdall-keystore.jks"
buildVariant="Production"
deployFolder="deploy"
bundlePath="build/app/outputs/bundle/productionRelease/"
bundleFileName="app-production-release"

convertBundleToApk() {
  # Check all necessary arguments have been passed
  if [ "$#" -eq 6 ]; then
    echo "============= ${buildVariant} Apk 파일 변환 시작 ============="
  else
    echo "[Error] Make sure you pass in a bundle path, and all 4 keystore values!"
    exit 1
  fi

  if [ -f "${1}${2}.apks" ]; then
    echo "============= ${1}${2}.apks 중복 파일존재 ============="
    rm -rf "${1}${2}.apks"
    echo "============= ${1}${2}.apks 중복 파일제거 ============="
  fi

  if [ -d "${1}unzipped" ]; then
    echo "============= ${1}unzipped 폴더 중복 ============="
    rm -rf "${1}unzipped"
    echo "============= ${1}unzipped 중복제거 ============="
  fi

  # Download bundletool
  if [ ! -f ./bundletool-all-1.14.1.jar ]; then
    curl -O -L "https://github.com/google/bundletool/releases/download/1.14.1/bundletool-all-1.14.1.jar"
  fi

  # Use bundletool to create universal .apks zip
  java -jar bundletool-all-1.14.1.jar build-apks \
    --mode=universal \
    --bundle="${1}${2}.aab" \
    --output="${1}${2}.apks" \
    --ks="${3}" \
    --ks-pass="pass:${4}" \
    --ks-key-alias="${5}" \
    --key-pass="pass:${6}"

  # Unzip .apks zip into /unzipped
  echo "============= Unzip Apk 시작 =================="
  if ! unzip -o "${1}${bundleFileName}".apks -d "${1}unzipped"; then
    echo "============= Unzip Apk 실패 =================="
    exit 1
  fi
  echo "============= Unzip Apk 성공 =================="
  echo "unzipped file: ${1}${bundleFileName}.apks"
}

flutter doctor

echo "=============  Start Build ============="

if ! flutter build appbundle --flavor production -t lib/env/production.dart --release; then
  echo "=============  Android 빌드 실패 ============="
  exit 1
fi

convertBundleToApk ${bundlePath} ${bundleFileName} ${KEYSTORE_PATH} "${keystore_password}" "${keystore_alias}" "${keystore_alias_password}"

cd android || exit

VERSION_NAME=$(./gradlew -q printVersionName)
VERSION_CODE=$(./gradlew -q printVersionCode)
export VERSION_NAME
export VERSION_CODE

cd ..

mkdir -p "${deployFolder}"
if ! cp "${bundlePath}unzipped/universal.apk" "${deployFolder}"/"Haimdall_${VERSION_NAME}"_"${VERSION_CODE}".apk; then
  echo "============= ${buildVariant} Apk 파일 복사 실패 ============="
  exit 1
else
  echo "============= ${buildVariant} Apk 파일 복사 완료 ============="
  ls
  if [ -f "${deployFolder}/Haimdall_${VERSION_NAME}_${VERSION_CODE}.apk" ]; then
    echo "${deployFolder}/Haimdall_${VERSION_NAME}_${VERSION_CODE}.apk file exist"
    export DEPLOY_FILE_PATH="${deployFolder}/${VERSION_NAME}_${VERSION_CODE}.apk"
    export DEPLOY_FILE_NAME="${VERSION_NAME}_${VERSION_CODE}.apk"
  else
    echo "${deployFolder}/${VERSION_NAME}_${VERSION_CODE}.apk file not found"
    exit 1
  fi
fi

# 추후 play store 배포한다면 fastlane 사용
#cd android || exit
#
#echo "=============  Fastlane 시작 ============="
#if bundle exec fastlane android productionAlpha; then
#  echo "=============  fastlane productionAlpha 성공 ============="
##  echo "=============  Tag 생성 및 푸시 ============="
#  cd ..
##
##  tagName="v$VERSION_NAME($VERSION_CODE)"
##  git tag "$tagName"
##  git push origin "$tagName"
#else
#  echo "=============  fastlane productionAlpha 실패 ============="
#  exit 1
#fi

exit 0

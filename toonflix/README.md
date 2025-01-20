# toonflix

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 릴리즈 하는법

- keystore 파일 생성하기 (앱서명 같은거) : keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
- android/app/build.gradle 에서 서명 설정 확인
- flutter clean 후 flutter build apk --release 하면 build\app\outputs\flutter-apk\app-release.apk 과 같은 경로에 apk 파일 빌드됨
- apk 파일을 휴대폰에 배포해서 설치하면됨
- adb가 설치되어 있다면 터미널로 원격 설치를 해주자 : adb install build\app\outputs\flutter-apk\app-release.apk

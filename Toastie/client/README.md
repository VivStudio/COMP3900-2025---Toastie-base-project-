# Toastie

A new Flutter project.

## Getting Started

```
flutter run
```

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# Generate keystore
keytool -genkeypair -v -keystore toastie_android.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias toastie_android

# Generate entity classes
Run `dart run build_runner build` in the package directory (client/).

# Lint
dart fix --apply
dart fix --apply --code=require_trailing_commas; dart format -l 80 .
dart fix --apply --code=sort_constructors_first; dart format -l 80 .

## Generating launcher and notification icons

flutter pub run flutter_launcher_icons:main
flutter clean
flutter pub get

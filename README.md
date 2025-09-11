# 🧐 Run to generated code with buiild_runner and freezed 
- You setup build environment for the first time.
- You modified any code with the annotation `@freezed`.

```
flutter pub run build_runner build --delete-conflicting-outputs
```

# Run to generate translated message code 🍺

```
flutter pub run intl_utils:generate
```
Now, you can get the localized text by `L10n.of(context).msgap001`.

# Run to generate path icon 🔃
- docs: https://pub.dev/packages/flutter_gen
- note: do not create directory 'default'

```
fluttergen -c pubspec.yaml
```
- ⏭️ example:
import './generated/assets.gen.dart';
Now, you can get path icon from folder svg by `Assets.svg.icon.path`


# 📓 Quik run this project 
Run this cmd to all generate if you don't like to run step buy step
```
sh run.sh
```

# ✒️ How to run 
### Debug

```shell script
flutter run --debug --flavor development -t lib/main/main_development.dart
flutter run --debug --flavor staging -t lib/main/main_staging.dart
flutter run --debug --flavor production -t lib/main/main_production.dart
```

### Release

```shell script
flutter run --release --flavor development -t lib/main/main_development.dart
flutter run --release --flavor production -t lib/main/main_production.dart
```

# How to build
### Android
```shell script
flutter build apk --debug --flavor development -t lib/main/main_development.dart
flutter build apk --debug --flavor production -t lib/main/main_production.dart

# release
flutter build appbundle --release --flavor development -t lib/main/main_development.dart
flutter build appbundle --release --flavor production -t lib/main/main_production.dart
```

### iOS
```shell script
flutter build ios --release --no-codesign --flavor production -t lib/main/main_production.dart; cd ios; fastlane publish_production; cd -
```

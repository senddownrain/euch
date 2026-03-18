# Малітоўнік Эўхарыстак

Flutter-приложение для iOS и Android с Firebase, офлайн-кэшем Firestore, Riverpod, go_router, HTML-рендерингом и административными сценариями для управления заметками/молитвами.

## Что внутри

- список заметок с поиском, фильтрами и закреплением;
- экран чтения HTML-контента с настройками шрифта;
- административное создание, редактирование, удаление, импорт и экспорт JSON;
- Firebase Auth (email/password) для администратора;
- Firestore realtime + offline persistence;
- локальные настройки через SharedPreferences;
- локализация `be` и `ru` через ARB.

## Запуск

```bash
flutter pub get
flutterfire configure
flutter run
```

## Платформенные шаги

### Android
- убедитесь, что `android/app/google-services.json` актуален;
- при необходимости обновите `applicationId` и повторно выполните `flutterfire configure`.

### iOS
- добавьте актуальный `GoogleService-Info.plist` через FlutterFire CLI;
- выполните `cd ios && pod install` после `flutter pub get`, если CocoaPods не обновлялись.

## Структура

```text
lib/
  app/
  core/
  features/
  l10n/
  firebase_options.dart
  main.dart
```

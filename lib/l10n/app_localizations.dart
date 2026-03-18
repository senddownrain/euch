import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_be.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('be'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In be, this message translates to:
  /// **'Малітоўнік Эўхарыстак'**
  String get appTitle;

  /// No description provided for @searchHint.
  ///
  /// In be, this message translates to:
  /// **'Пошук малітваў і нататак'**
  String get searchHint;

  /// No description provided for @search.
  ///
  /// In be, this message translates to:
  /// **'Пошук'**
  String get search;

  /// No description provided for @filters.
  ///
  /// In be, this message translates to:
  /// **'Фільтры'**
  String get filters;

  /// No description provided for @settings.
  ///
  /// In be, this message translates to:
  /// **'Налады'**
  String get settings;

  /// No description provided for @about.
  ///
  /// In be, this message translates to:
  /// **'Пра праграму'**
  String get about;

  /// No description provided for @admin.
  ///
  /// In be, this message translates to:
  /// **'Адміністраванне'**
  String get admin;

  /// No description provided for @login.
  ///
  /// In be, this message translates to:
  /// **'Уваход'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In be, this message translates to:
  /// **'Выйсці'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In be, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In be, this message translates to:
  /// **'Пароль'**
  String get password;

  /// No description provided for @signIn.
  ///
  /// In be, this message translates to:
  /// **'Увайсці'**
  String get signIn;

  /// No description provided for @cancel.
  ///
  /// In be, this message translates to:
  /// **'Скасаваць'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In be, this message translates to:
  /// **'Захаваць'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In be, this message translates to:
  /// **'Выдаліць'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In be, this message translates to:
  /// **'Рэдагаваць'**
  String get edit;

  /// No description provided for @share.
  ///
  /// In be, this message translates to:
  /// **'Падзяліцца'**
  String get share;

  /// No description provided for @textSettings.
  ///
  /// In be, this message translates to:
  /// **'Налады тэксту'**
  String get textSettings;

  /// No description provided for @theme.
  ///
  /// In be, this message translates to:
  /// **'Тэма'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In be, this message translates to:
  /// **'Светлая'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In be, this message translates to:
  /// **'Цёмная'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In be, this message translates to:
  /// **'Сістэмная'**
  String get systemTheme;

  /// No description provided for @keepScreenOn.
  ///
  /// In be, this message translates to:
  /// **'Не выключаць экран'**
  String get keepScreenOn;

  /// No description provided for @fontFamily.
  ///
  /// In be, this message translates to:
  /// **'Шрыфт'**
  String get fontFamily;

  /// No description provided for @fontSize.
  ///
  /// In be, this message translates to:
  /// **'Памер тэксту'**
  String get fontSize;

  /// No description provided for @viewMode.
  ///
  /// In be, this message translates to:
  /// **'Рэжым спісу'**
  String get viewMode;

  /// No description provided for @cardView.
  ///
  /// In be, this message translates to:
  /// **'Карткі'**
  String get cardView;

  /// No description provided for @compactView.
  ///
  /// In be, this message translates to:
  /// **'Кампактны'**
  String get compactView;

  /// No description provided for @allItems.
  ///
  /// In be, this message translates to:
  /// **'Усе нататкі'**
  String get allItems;

  /// No description provided for @addItem.
  ///
  /// In be, this message translates to:
  /// **'Дадаць нататку'**
  String get addItem;

  /// No description provided for @editItem.
  ///
  /// In be, this message translates to:
  /// **'Рэдагаваць нататку'**
  String get editItem;

  /// No description provided for @title.
  ///
  /// In be, this message translates to:
  /// **'Назва'**
  String get title;

  /// No description provided for @content.
  ///
  /// In be, this message translates to:
  /// **'Змест'**
  String get content;

  /// No description provided for @tags.
  ///
  /// In be, this message translates to:
  /// **'Тэгі'**
  String get tags;

  /// No description provided for @addTagHint.
  ///
  /// In be, this message translates to:
  /// **'Дадаць тэг'**
  String get addTagHint;

  /// No description provided for @preview.
  ///
  /// In be, this message translates to:
  /// **'Папярэдні прагляд'**
  String get preview;

  /// No description provided for @editor.
  ///
  /// In be, this message translates to:
  /// **'Рэдактар'**
  String get editor;

  /// No description provided for @pin.
  ///
  /// In be, this message translates to:
  /// **'Замацаваць'**
  String get pin;

  /// No description provided for @unpin.
  ///
  /// In be, this message translates to:
  /// **'Адмацаваць'**
  String get unpin;

  /// No description provided for @pinned.
  ///
  /// In be, this message translates to:
  /// **'Замацавана'**
  String get pinned;

  /// No description provided for @emptyItemsTitle.
  ///
  /// In be, this message translates to:
  /// **'Пакуль няма нататак'**
  String get emptyItemsTitle;

  /// No description provided for @emptyItemsSubtitle.
  ///
  /// In be, this message translates to:
  /// **'Дадайце нататку або праверце фільтры.'**
  String get emptyItemsSubtitle;

  /// No description provided for @notFound.
  ///
  /// In be, this message translates to:
  /// **'Запіс не знойдзены'**
  String get notFound;

  /// No description provided for @loading.
  ///
  /// In be, this message translates to:
  /// **'Загрузка...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In be, this message translates to:
  /// **'Паўтарыць'**
  String get retry;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In be, this message translates to:
  /// **'Выдаліць нататку?'**
  String get confirmDeleteTitle;

  /// No description provided for @confirmDeleteBody.
  ///
  /// In be, this message translates to:
  /// **'Гэта дзеянне немагчыма адмяніць.'**
  String get confirmDeleteBody;

  /// No description provided for @deleteSuccess.
  ///
  /// In be, this message translates to:
  /// **'Нататка выдалена'**
  String get deleteSuccess;

  /// No description provided for @saveSuccess.
  ///
  /// In be, this message translates to:
  /// **'Нататка захавана'**
  String get saveSuccess;

  /// No description provided for @loginSuccess.
  ///
  /// In be, this message translates to:
  /// **'Уваход выкананы'**
  String get loginSuccess;

  /// No description provided for @logoutSuccess.
  ///
  /// In be, this message translates to:
  /// **'Вы выйшлі з сістэмы'**
  String get logoutSuccess;

  /// No description provided for @importJson.
  ///
  /// In be, this message translates to:
  /// **'Імпартаваць JSON'**
  String get importJson;

  /// No description provided for @exportJson.
  ///
  /// In be, this message translates to:
  /// **'Экспартаваць JSON'**
  String get exportJson;

  /// No description provided for @importMode.
  ///
  /// In be, this message translates to:
  /// **'Рэжым імпарту'**
  String get importMode;

  /// No description provided for @importAddOnly.
  ///
  /// In be, this message translates to:
  /// **'Дадаваць толькі новыя'**
  String get importAddOnly;

  /// No description provided for @importOverwrite.
  ///
  /// In be, this message translates to:
  /// **'Перазапісваць існуючыя'**
  String get importOverwrite;

  /// No description provided for @confirmImportTitle.
  ///
  /// In be, this message translates to:
  /// **'Пацвердзіць імпарт'**
  String get confirmImportTitle;

  /// No description provided for @confirmImportBody.
  ///
  /// In be, this message translates to:
  /// **'Імпартаваць {count} запісаў?'**
  String confirmImportBody(Object count);

  /// No description provided for @importSuccess.
  ///
  /// In be, this message translates to:
  /// **'Імпарт завершаны'**
  String get importSuccess;

  /// No description provided for @exportSuccess.
  ///
  /// In be, this message translates to:
  /// **'Экспарт гатовы для шэрынгу'**
  String get exportSuccess;

  /// No description provided for @offlineReady.
  ///
  /// In be, this message translates to:
  /// **'Нататкі даступныя офлайн'**
  String get offlineReady;

  /// No description provided for @downloadOffline.
  ///
  /// In be, this message translates to:
  /// **'Спампаваць офлайн'**
  String get downloadOffline;

  /// No description provided for @invalidJson.
  ///
  /// In be, this message translates to:
  /// **'Няслушны JSON-файл'**
  String get invalidJson;

  /// No description provided for @adminOnly.
  ///
  /// In be, this message translates to:
  /// **'Гэта дзеянне даступнае толькі адміністратару'**
  String get adminOnly;

  /// No description provided for @shareMessage.
  ///
  /// In be, this message translates to:
  /// **'{title}\n\nПадзяліцца: {url}'**
  String shareMessage(Object title, Object url);

  /// No description provided for @tagFilterTitle.
  ///
  /// In be, this message translates to:
  /// **'Фільтр па тэгах'**
  String get tagFilterTitle;

  /// No description provided for @apply.
  ///
  /// In be, this message translates to:
  /// **'Ужыць'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In be, this message translates to:
  /// **'Ачысціць'**
  String get clear;

  /// No description provided for @selectedTags.
  ///
  /// In be, this message translates to:
  /// **'Выбраныя тэгі'**
  String get selectedTags;

  /// No description provided for @readPreview.
  ///
  /// In be, this message translates to:
  /// **'Узор чытання'**
  String get readPreview;

  /// No description provided for @aboutBody.
  ///
  /// In be, this message translates to:
  /// **'Праграма для чытання, пошуку і захавання малітваў і нататак з падтрымкай афлайн-рэжыму, шэрынгу і адміністравання.'**
  String get aboutBody;

  /// No description provided for @loginError.
  ///
  /// In be, this message translates to:
  /// **'Не ўдалося ўвайсці'**
  String get loginError;

  /// No description provided for @genericError.
  ///
  /// In be, this message translates to:
  /// **'Нешта пайшло не так'**
  String get genericError;

  /// No description provided for @noTags.
  ///
  /// In be, this message translates to:
  /// **'Тэгаў няма'**
  String get noTags;

  /// No description provided for @itemsCount.
  ///
  /// In be, this message translates to:
  /// **'Колькасць запісаў: {count}'**
  String itemsCount(Object count);

  /// No description provided for @htmlSource.
  ///
  /// In be, this message translates to:
  /// **'HTML-крыніца'**
  String get htmlSource;

  /// No description provided for @previewText.
  ///
  /// In be, this message translates to:
  /// **'Папярэдні прагляд'**
  String get previewText;

  /// No description provided for @sourceModeHint.
  ///
  /// In be, this message translates to:
  /// **'Пішыце або рэдагуйце HTML-тэкст тут.'**
  String get sourceModeHint;

  /// No description provided for @loginRequiredBody.
  ///
  /// In be, this message translates to:
  /// **'Каб працягнуць, увайдзіце як адміністратар.'**
  String get loginRequiredBody;

  /// No description provided for @openAdmin.
  ///
  /// In be, this message translates to:
  /// **'Адкрыць адміністраванне'**
  String get openAdmin;

  /// No description provided for @language.
  ///
  /// In be, this message translates to:
  /// **'Мова'**
  String get language;

  /// No description provided for @belarusian.
  ///
  /// In be, this message translates to:
  /// **'Беларуская'**
  String get belarusian;

  /// No description provided for @russian.
  ///
  /// In be, this message translates to:
  /// **'Руская'**
  String get russian;

  /// No description provided for @downloadedFromCache.
  ///
  /// In be, this message translates to:
  /// **'Паказваюцца кэшаваныя дадзеныя'**
  String get downloadedFromCache;

  /// No description provided for @networkUnavailable.
  ///
  /// In be, this message translates to:
  /// **'Няма сеткі, але кэш даступны'**
  String get networkUnavailable;

  /// No description provided for @confirm.
  ///
  /// In be, this message translates to:
  /// **'Пацвердзіць'**
  String get confirm;

  /// No description provided for @close.
  ///
  /// In be, this message translates to:
  /// **'Закрыць'**
  String get close;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['be', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'be':
      return AppLocalizationsBe();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

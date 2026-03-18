// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Belarusian (`be`).
class AppLocalizationsBe extends AppLocalizations {
  AppLocalizationsBe([String locale = 'be']) : super(locale);

  @override
  String get appTitle => 'Малітоўнік Эўхарыстак';

  @override
  String get searchHint => 'Пошук малітваў і нататак';

  @override
  String get search => 'Пошук';

  @override
  String get filters => 'Фільтры';

  @override
  String get settings => 'Налады';

  @override
  String get about => 'Пра праграму';

  @override
  String get admin => 'Адміністраванне';

  @override
  String get login => 'Уваход';

  @override
  String get logout => 'Выйсці';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get signIn => 'Увайсці';

  @override
  String get cancel => 'Скасаваць';

  @override
  String get save => 'Захаваць';

  @override
  String get delete => 'Выдаліць';

  @override
  String get edit => 'Рэдагаваць';

  @override
  String get share => 'Падзяліцца';

  @override
  String get textSettings => 'Налады тэксту';

  @override
  String get theme => 'Тэма';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Цёмная';

  @override
  String get systemTheme => 'Сістэмная';

  @override
  String get keepScreenOn => 'Не выключаць экран';

  @override
  String get fontFamily => 'Шрыфт';

  @override
  String get fontSize => 'Памер тэксту';

  @override
  String get viewMode => 'Рэжым спісу';

  @override
  String get cardView => 'Карткі';

  @override
  String get compactView => 'Кампактны';

  @override
  String get allItems => 'Усе нататкі';

  @override
  String get addItem => 'Дадаць нататку';

  @override
  String get editItem => 'Рэдагаваць нататку';

  @override
  String get title => 'Назва';

  @override
  String get content => 'Змест';

  @override
  String get tags => 'Тэгі';

  @override
  String get addTagHint => 'Дадаць тэг';

  @override
  String get preview => 'Папярэдні прагляд';

  @override
  String get editor => 'Рэдактар';

  @override
  String get pin => 'Замацаваць';

  @override
  String get unpin => 'Адмацаваць';

  @override
  String get pinned => 'Замацавана';

  @override
  String get emptyItemsTitle => 'Пакуль няма нататак';

  @override
  String get emptyItemsSubtitle => 'Дадайце нататку або праверце фільтры.';

  @override
  String get notFound => 'Запіс не знойдзены';

  @override
  String get loading => 'Загрузка...';

  @override
  String get retry => 'Паўтарыць';

  @override
  String get confirmDeleteTitle => 'Выдаліць нататку?';

  @override
  String get confirmDeleteBody => 'Гэта дзеянне немагчыма адмяніць.';

  @override
  String get deleteSuccess => 'Нататка выдалена';

  @override
  String get saveSuccess => 'Нататка захавана';

  @override
  String get loginSuccess => 'Уваход выкананы';

  @override
  String get logoutSuccess => 'Вы выйшлі з сістэмы';

  @override
  String get importJson => 'Імпартаваць JSON';

  @override
  String get exportJson => 'Экспартаваць JSON';

  @override
  String get importMode => 'Рэжым імпарту';

  @override
  String get importAddOnly => 'Дадаваць толькі новыя';

  @override
  String get importOverwrite => 'Перазапісваць існуючыя';

  @override
  String get confirmImportTitle => 'Пацвердзіць імпарт';

  @override
  String confirmImportBody(Object count) {
    return 'Імпартаваць $count запісаў?';
  }

  @override
  String get importSuccess => 'Імпарт завершаны';

  @override
  String get exportSuccess => 'Экспарт гатовы для шэрынгу';

  @override
  String get offlineReady => 'Нататкі даступныя офлайн';

  @override
  String get downloadOffline => 'Спампаваць офлайн';

  @override
  String get invalidJson => 'Няслушны JSON-файл';

  @override
  String get adminOnly => 'Гэта дзеянне даступнае толькі адміністратару';

  @override
  String shareMessage(Object title, Object url) {
    return '$title\n\nПадзяліцца: $url';
  }

  @override
  String get tagFilterTitle => 'Фільтр па тэгах';

  @override
  String get apply => 'Ужыць';

  @override
  String get clear => 'Ачысціць';

  @override
  String get selectedTags => 'Выбраныя тэгі';

  @override
  String get readPreview => 'Узор чытання';

  @override
  String get aboutBody =>
      'Праграма для чытання, пошуку і захавання малітваў і нататак з падтрымкай афлайн-рэжыму, шэрынгу і адміністравання.';

  @override
  String get loginError => 'Не ўдалося ўвайсці';

  @override
  String get genericError => 'Нешта пайшло не так';

  @override
  String get noTags => 'Тэгаў няма';

  @override
  String itemsCount(Object count) {
    return 'Колькасць запісаў: $count';
  }

  @override
  String get htmlSource => 'HTML-крыніца';

  @override
  String get previewText => 'Папярэдні прагляд';

  @override
  String get sourceModeHint => 'Пішыце або рэдагуйце HTML-тэкст тут.';

  @override
  String get loginRequiredBody => 'Каб працягнуць, увайдзіце як адміністратар.';

  @override
  String get openAdmin => 'Адкрыць адміністраванне';

  @override
  String get language => 'Мова';

  @override
  String get belarusian => 'Беларуская';

  @override
  String get russian => 'Руская';

  @override
  String get downloadedFromCache => 'Паказваюцца кэшаваныя дадзеныя';

  @override
  String get networkUnavailable => 'Няма сеткі, але кэш даступны';

  @override
  String get confirm => 'Пацвердзіць';

  @override
  String get close => 'Закрыць';
}

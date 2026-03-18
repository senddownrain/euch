// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Молитвенник Евхаристок';

  @override
  String get searchHint => 'Поиск молитв и заметок';

  @override
  String get search => 'Поиск';

  @override
  String get filters => 'Фильтры';

  @override
  String get settings => 'Настройки';

  @override
  String get about => 'О приложении';

  @override
  String get admin => 'Администрирование';

  @override
  String get login => 'Вход';

  @override
  String get logout => 'Выйти';

  @override
  String get email => 'Email';

  @override
  String get password => 'Пароль';

  @override
  String get signIn => 'Войти';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get share => 'Поделиться';

  @override
  String get textSettings => 'Настройки текста';

  @override
  String get theme => 'Тема';

  @override
  String get lightTheme => 'Светлая';

  @override
  String get darkTheme => 'Тёмная';

  @override
  String get systemTheme => 'Системная';

  @override
  String get keepScreenOn => 'Не выключать экран';

  @override
  String get fontFamily => 'Шрифт';

  @override
  String get fontSize => 'Размер текста';

  @override
  String get viewMode => 'Режим списка';

  @override
  String get cardView => 'Карточки';

  @override
  String get compactView => 'Компактный';

  @override
  String get allItems => 'Все записи';

  @override
  String get addItem => 'Добавить запись';

  @override
  String get editItem => 'Редактировать запись';

  @override
  String get title => 'Название';

  @override
  String get content => 'Содержание';

  @override
  String get tags => 'Теги';

  @override
  String get addTagHint => 'Добавить тег';

  @override
  String get preview => 'Предпросмотр';

  @override
  String get editor => 'Редактор';

  @override
  String get pin => 'Закрепить';

  @override
  String get unpin => 'Открепить';

  @override
  String get pinned => 'Закреплено';

  @override
  String get emptyItemsTitle => 'Пока нет записей';

  @override
  String get emptyItemsSubtitle => 'Добавьте запись или проверьте фильтры.';

  @override
  String get notFound => 'Запись не найдена';

  @override
  String get loading => 'Загрузка...';

  @override
  String get retry => 'Повторить';

  @override
  String get confirmDeleteTitle => 'Удалить запись?';

  @override
  String get confirmDeleteBody => 'Это действие нельзя отменить.';

  @override
  String get deleteSuccess => 'Запись удалена';

  @override
  String get saveSuccess => 'Запись сохранена';

  @override
  String get loginSuccess => 'Вход выполнен';

  @override
  String get logoutSuccess => 'Вы вышли из системы';

  @override
  String get importJson => 'Импортировать JSON';

  @override
  String get exportJson => 'Экспортировать JSON';

  @override
  String get importMode => 'Режим импорта';

  @override
  String get importAddOnly => 'Добавлять только новые';

  @override
  String get importOverwrite => 'Перезаписывать существующие';

  @override
  String get confirmImportTitle => 'Подтвердите импорт';

  @override
  String confirmImportBody(Object count) {
    return 'Импортировать $count записей?';
  }

  @override
  String get importSuccess => 'Импорт завершён';

  @override
  String get exportSuccess => 'Экспорт готов для шаринга';

  @override
  String get offlineReady => 'Записи доступны офлайн';

  @override
  String get downloadOffline => 'Скачать офлайн';

  @override
  String get invalidJson => 'Некорректный JSON-файл';

  @override
  String get adminOnly => 'Это действие доступно только администратору';

  @override
  String shareMessage(Object title, Object url) {
    return '$title\n\nПоделиться: $url';
  }

  @override
  String get tagFilterTitle => 'Фильтр по тегам';

  @override
  String get apply => 'Применить';

  @override
  String get clear => 'Очистить';

  @override
  String get selectedTags => 'Выбранные теги';

  @override
  String get readPreview => 'Пример чтения';

  @override
  String get aboutBody =>
      'Приложение для чтения, поиска и хранения молитв и заметок с поддержкой офлайн-режима, шаринга и администрирования.';

  @override
  String get loginError => 'Не удалось войти';

  @override
  String get genericError => 'Что-то пошло не так';

  @override
  String get noTags => 'Тегов нет';

  @override
  String itemsCount(Object count) {
    return 'Количество записей: $count';
  }

  @override
  String get htmlSource => 'HTML-источник';

  @override
  String get previewText => 'Предпросмотр';

  @override
  String get sourceModeHint => 'Пишите или редактируйте HTML-текст здесь.';

  @override
  String get loginRequiredBody =>
      'Чтобы продолжить, войдите как администратор.';

  @override
  String get openAdmin => 'Открыть администрирование';

  @override
  String get language => 'Язык';

  @override
  String get belarusian => 'Белорусский';

  @override
  String get russian => 'Русский';

  @override
  String get downloadedFromCache => 'Показываются кэшированные данные';

  @override
  String get networkUnavailable => 'Нет сети, но кэш доступен';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get close => 'Закрыть';
}

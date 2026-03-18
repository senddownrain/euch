class AppStrings {
  const AppStrings._();

  static const appTitle = 'Малітоўнік Эўхарыстак';
  static const defaultItemLanguage = 'be';

  static const search = 'Пошук';
  static const searchHint = 'Шукаць па назве або тэксце';
  static const filters = 'Фільтры';
  static const settings = 'Налады';
  static const admin = 'Адміністраванне';
  static const login = 'Уваход';
  static const logout = 'Выйсці';
  static const logoutSuccess = 'Вы выйшлі з уліковага запісу';
  static const updateDatabase = 'Абнавіць базу';
  static const offlineReady = 'Афлайн-даныя абноўлены';
  static const networkUnavailable = 'Няма сеткі для абнаўлення';
  static const addItem = 'Дадаць тэкст';
  static const editItem = 'Рэдагаваць тэкст';
  static const save = 'Захаваць';
  static const saveSuccess = 'Змены захаваныя';
  static const loading = 'Загрузка...';
  static const genericError = 'Нешта пайшло не так';
  static const notFound = 'Нічога не знойдзена';
  static const emptyItemsTitle = 'Пакуль няма запісаў';
  static const emptyItemsSubtitle = 'Дадайце новы тэкст або змяніце фільтры.';
  static const edit = 'Рэдагаваць';
  static const delete = 'Выдаліць';
  static const cancel = 'Скасаваць';
  static const clear = 'Ачысціць';
  static const confirm = 'Пацвердзіць';
  static const confirmDeleteTitle = 'Выдаліць тэкст?';
  static const confirmDeleteBody = 'Гэта дзеянне нельга будзе адмяніць.';
  static const deleteSuccess = 'Тэкст выдалены';
  static const title = 'Назва';
  static const tags = 'Тэгі';
  static const addTagHint = 'Дадаць тэг';
  static const content = 'Змест';
  static const tagFilterTitle = 'Фільтр па тэгах';
  static const noTags = 'Тэгі пакуль адсутнічаюць';
  static const apply = 'Ужыць';
  static const htmlSource = 'HTML';
  static const previewText = 'Папярэдні прагляд';
  static const sourceModeHint = 'Увядзіце HTML або адрэдагаваны тэкст';
  static const textSettings = 'Налады тэксту';
  static const fontFamily = 'Шрыфт';
  static const fontSize = 'Памер шрыфту';
  static const systemTheme = 'Сістэмная';
  static const lightTheme = 'Светлая';
  static const darkTheme = 'Цёмная';
  static const keepScreenOn = 'Не выключаць экран падчас чытання';
  static const cardView = 'Карткі';
  static const compactView = 'Кампактны';
  static const readPreview = 'Прыклад чытання';
  static const about = 'Пра праграму';
  static const aboutBody =
      'Праграма для чытання, пошуку і захавання малітваў і нататак з падтрымкай афлайн-рэжыму і адміністравання.';
  static const loginSuccess = 'Уваход выкананы';
  static const loginError = 'Не ўдалося ўвайсці';
  static const loginRequiredBody = 'Каб працягнуць, увайдзіце як адміністратар.';
  static const email = 'Email';
  static const password = 'Пароль';
  static const signIn = 'Увайсці';
  static const exportSuccess = 'Экспарт завершаны';
  static const invalidJson = 'Не атрымалася прачытаць JSON';
  static const importSuccess = 'Імпарт завершаны';
  static const importAddOnly = 'Толькі новыя';
  static const importOverwrite = 'Перазапісваць';
  static const exportJson = 'Экспартаваць JSON';
  static const importJson = 'Імпартаваць JSON';
  static const offlineStatusSyncing = 'Сінхранізацыя афлайн-даных';
  static const offlineStatusReady = 'Афлайн-рэжым гатовы';
  static const offlineStatusError = 'Не ўдалося абнавіць афлайн-даныя';

  static String confirmImportBody(int count) {
    return 'Імпартаваць $count запісаў?';
  }

  static String itemsCount(int count) {
    return 'Усяго запісаў: $count';
  }
}

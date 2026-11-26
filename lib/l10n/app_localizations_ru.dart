// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get watchNext => 'Смотреть дальше';

  @override
  String get seeAll => 'Смотреть все';

  @override
  String get homeRecordedToday => 'Видео, снятые сегодня';

  @override
  String get homePlays => 'Воспроизведения';

  @override
  String get homeWatchActivity => 'Активность просмотров';

  @override
  String get homeWatchStreak => 'Дни просмотра подряд';

  @override
  String get homeMostWatched => 'Самые просматриваемые';

  @override
  String get homeTopFolders => 'Популярные папки';

  @override
  String get homeVideoRecap => 'Итоги по видео';

  @override
  String get homeRecordedThisYear => 'Видео, снятые в этом году';

  @override
  String get homeWatchedToday => 'Просмотрено сегодня';

  @override
  String get homeTopAlbums => 'Популярные альбомы';

  @override
  String get homeNoWatchHistory =>
      'Посмотрите видео, чтобы начать историю просмотров.';

  @override
  String get homeNoVideoAlbums => 'Здесь появятся альбомы с видео.';

  @override
  String get homeNoVideoFolders => 'Здесь появятся папки с видео.';

  @override
  String get homeLimitedVideoCollections =>
      'При ограниченном доступе некоторые альбомы или папки могут быть скрыты.';

  @override
  String homeWatchDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString дня',
      many: '$countString дней',
      few: '$countString дня',
      one: '$countString день',
    );
    return '$_temp0';
  }

  @override
  String homePlayCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString просмотра',
      many: '$countString просмотров',
      few: '$countString просмотра',
      one: '$countString просмотр',
    );
    return '$_temp0';
  }

  @override
  String get homeUnavailable => 'Недоступно';

  @override
  String get homeLoading => 'Загрузка…';

  @override
  String get homeCameraRoll => 'Ваши\nвидео';

  @override
  String get homeWatchTab => 'Смотреть';

  @override
  String get homeActivityTab => 'Активность';

  @override
  String get homeYourActivity => 'Ваша активность';

  @override
  String get homeEmptyTitle => 'Здесь будет ваше первое видео';

  @override
  String get homeEmptyBody =>
      'Снимите видео на камеру. Когда вернётесь, оно будет здесь.';

  @override
  String get homeOpenCamera => 'Открыть камеру';

  @override
  String get homeCaptureFailed =>
      'RollReel не удалось снять или сохранить видео.';

  @override
  String get homeAccessTitle => 'Выберите свои видео';

  @override
  String get homeAccessBody =>
      'Разрешите доступ к приложению «Фото» в настройках, чтобы смотреть свои видео.';

  @override
  String get homeLoadFailed => 'Не удалось загрузить ваши видео';

  @override
  String get homeLoadFailedBody =>
      'Медиатека, возможно, ещё синхронизируется. Попробуйте снова.';

  @override
  String get homeNoMemories => 'Нет видео за эту дату в прошлые годы.';

  @override
  String homePlayClip(String title) {
    return 'Воспроизвести $title';
  }

  @override
  String get homePlaybackFailed => 'Не удалось воспроизвести видео.';

  @override
  String get homePause => 'Пауза';

  @override
  String get homePlay => 'Воспроизвести';

  @override
  String get onboardingTitle => 'Снова в вашей\nмедиатеке.';

  @override
  String favoritesSavedCount(int count) {
    return 'Сохранено: $count';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return 'Удалить «$title» из избранного';
  }

  @override
  String get favoritesRemoved => 'Удалено из избранного';

  @override
  String get favoritesUndo => 'Отменить';

  @override
  String get favoritesLoadFailed => 'Не удалось загрузить избранное';

  @override
  String get favoritesRetryBody =>
      'Попробуйте загрузить сохранённые видео снова.';

  @override
  String get favoritesAccessBody =>
      'Разрешите доступ к приложению «Фото», чтобы увидеть сохранённые видео.';

  @override
  String get favoritesUpdateFailed => 'Не удалось обновить избранное.';

  @override
  String get onboardingSwipeTitle => 'Смахните вверх\nдля следующего видео.';

  @override
  String get onboardingSwipeSubtitle => 'Попробуйте на примере ниже.';

  @override
  String get onboardingTrySwipe => 'Попробовать жест';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Пример $current из $total';
  }

  @override
  String get onboardingNextSample => 'Показать следующий пример';

  @override
  String get onboardingLimitedTitle => 'Выберите отдельные видео';

  @override
  String get onboardingLimitedBody =>
      'Укажите в системном окне, какие файлы доступны RollReel.';

  @override
  String get onboardingFullTitle => 'Разрешите всю медиатеку';

  @override
  String get onboardingFullBody =>
      'Просматривайте все видео. Доступ можно изменить в настройках.';

  @override
  String get onboardingChooseVideos => 'Выбрать видео';

  @override
  String get onboardingNotNow => 'Не сейчас';

  @override
  String get onboardingSubtitle =>
      'Пересмотрите моменты, которые вы сняли, по одному видео за раз.';

  @override
  String get onboardingPrivacyBody =>
      'Видео воспроизводятся на вашем устройстве. Создавать аккаунт и загружать медиатеку не нужно.';

  @override
  String get onboardingPermissionBody =>
      'Разрешите доступ к медиатеке, чтобы RollReel мог найти и воспроизвести ваши видео.';

  @override
  String get onboardingAccessBody =>
      'RollReel использует доступ к приложению «Фото», чтобы показать ваши видео.';

  @override
  String get onboardingPermissionNote =>
      'Доступ можно изменить в настройках в любое время.';

  @override
  String get onboardingPermissionError =>
      'Не удалось запросить доступ. Попробуйте снова или пропустите этот шаг.';

  @override
  String onboardingStep(int step, int total) {
    return 'Шаг $step из $total';
  }

  @override
  String get onboardingPrivacyTitle => 'Только для вас.';

  @override
  String get onboardingPermissionTitle => 'Какие видео\nможно показать?';

  @override
  String get onboardingNoCloud => 'Без облака';

  @override
  String get onboardingNoAccount => 'Без аккаунта';

  @override
  String get onboardingNoTracking => 'Без слежки';

  @override
  String get swipeHint => 'СВАЙП';

  @override
  String get skip => 'Пропустить';

  @override
  String get getStarted => 'Начать';

  @override
  String get continueLabel => 'Продолжить';

  @override
  String get requesting => 'Запрос…';

  @override
  String get allowAccess => 'Разрешить доступ';

  @override
  String get noVideosYetTitle => 'Пока нет видео';

  @override
  String get noVideosYetBody => 'Видео из вашей галереи появятся здесь.';

  @override
  String get openPhotosApp => 'Открыть «Фото»';

  @override
  String get loadingLibrary => 'Загрузка медиатеки...';

  @override
  String get permissionDeniedTitle => 'Доступ к «Фото»\nотключён.';

  @override
  String get permissionDeniedBody =>
      'Выберите видео в настройках, когда будете готовы. Продолжать знакомство с RollReel можно и сейчас.';

  @override
  String get openSettings => 'Открыть Настройки';

  @override
  String get continueAnyway => 'Продолжить всё равно';

  @override
  String get today => 'Сегодня';

  @override
  String get yesterday => 'Вчера';

  @override
  String get cancel => 'Отменить';

  @override
  String get ok => 'ОК';

  @override
  String get back => 'Назад';

  @override
  String get remove => 'Убрать';

  @override
  String get manage => 'Управлять';

  @override
  String get videoFallbackTitle => 'Видео';

  @override
  String get filterAll => 'Все';

  @override
  String get filterToday => 'Сегодня';

  @override
  String get filterShorts => 'Короткие';

  @override
  String get filterLong => 'Длинные';

  @override
  String get filterRecent => 'Недавние';

  @override
  String get videoDeleted => 'Видео удалено';

  @override
  String get getInfo => 'Свойства';

  @override
  String get addToVault => 'Добавить в хранилище';

  @override
  String get removeFromVault => 'Убрать из хранилища';

  @override
  String get deleteVideo => 'Удалить видео';

  @override
  String get deleteVideoWarning =>
      'Видео будет безвозвратно удалено из вашей медиатеки.';

  @override
  String get thisVideo => 'Это видео';

  @override
  String get share => 'Поделиться';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Развернуть';

  @override
  String get photoLibraryAccess => 'Доступ к медиатеке';

  @override
  String get limitedAccessMessage =>
      'Сейчас вы предоставили доступ только к части видео.';

  @override
  String get selectMoreVideos => 'Выбрать ещё видео';

  @override
  String get allowFullAccess => 'Разрешить полный доступ';

  @override
  String managingCount(int count) {
    return 'Доступно $count ваших видео';
  }

  @override
  String get infoDate => 'Дата';

  @override
  String get infoDuration => 'Длительность';

  @override
  String get infoResolution => 'Разрешение';

  @override
  String get infoFileSize => 'Размер файла';

  @override
  String get infoFormat => 'Формат';

  @override
  String get feed => 'Лента';

  @override
  String get library => 'Медиатека';

  @override
  String get libraryFilters => 'Фильтры';

  @override
  String get libraryClose => 'Закрыть';

  @override
  String get libraryEmptyTitle => 'Здесь пока нет видео';

  @override
  String get libraryAccessOff => 'Доступ к «Фото» отключён';

  @override
  String get libraryNoMatches => 'Подходящих видео нет';

  @override
  String get librarySearchHelp =>
      'Попробуйте другое название или сбросьте поиск.';

  @override
  String get libraryNoFilterMatches =>
      'Этим фильтрам не соответствует ни одно видео';

  @override
  String get libraryFilterHelp => 'Сбросьте фильтры, чтобы увидеть все видео.';

  @override
  String get libraryUnknownDate => 'Дата неизвестна';

  @override
  String get libraryDeleteFailed => 'RollReel не удалось удалить видео.';

  @override
  String libraryDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count видео',
      one: '$count видео',
    );
    return '$_temp0 на этом устройстве';
  }

  @override
  String libraryMemoriesCount(int count) {
    return '$count видео из прошлых лет';
  }

  @override
  String libraryVideoOptions(String title) {
    return 'Параметры для «$title»';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => 'Здесь пока нет избранного';

  @override
  String get favoritesEmptyBody =>
      'Нажмите на сердечко во время просмотра, чтобы сохранить видео здесь.';

  @override
  String get goToLibrary => 'Открыть медиатеку';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'Поиск видео…';

  @override
  String get videosTitle => 'Видео';

  @override
  String videosCount(int count) {
    return 'Видео: $count';
  }

  @override
  String get yourLibrary => 'Ваша медиатека';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Локально';

  @override
  String get noResults => 'Нет результатов';

  @override
  String get noVideosFound => 'Видео не найдены';

  @override
  String noSearchMatches(String query) {
    return 'Нет видео по запросу \"$query\".';
  }

  @override
  String get tryDifferentFilter => 'Попробуйте другой фильтр.';

  @override
  String get clearSearch => 'Очистить поиск';

  @override
  String get clearFilters => 'Сбросить фильтры';

  @override
  String get filter => 'Фильтр';

  @override
  String get reset => 'Сбросить';

  @override
  String get timePeriod => 'ПЕРИОД';

  @override
  String get thisWeek => 'Эта неделя';

  @override
  String get thisMonth => 'Этот месяц';

  @override
  String get duration => 'ДЛИТЕЛЬНОСТЬ';

  @override
  String get any => 'Любая';

  @override
  String get durationShort => '< 1 мин';

  @override
  String get durationMedium => '1–5 мин';

  @override
  String get durationLong => '> 5 мин';

  @override
  String get sortBy => 'СОРТИРОВКА';

  @override
  String get newestFirst => 'Сначала новые';

  @override
  String get oldestFirst => 'Сначала старые';

  @override
  String get shortestFirst => 'Сначала короткие';

  @override
  String get longestFirst => 'Сначала длинные';

  @override
  String get applyFilters => 'Применить фильтры';

  @override
  String get onThisDay => 'В этот день';

  @override
  String onThisDaySubtitleOne(String years) {
    return '1 воспоминание из $years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return 'Воспоминаний прошлых лет: $count';
  }

  @override
  String get yearsAgoOne => '1 год назад';

  @override
  String yearsAgoMany(int years) {
    return '$years лет назад';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'В этот день · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current из $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'Не удалось загрузить воспоминания: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'Не удалось загрузить видео: $error';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Избранное';

  @override
  String get playbackSection => 'Воспроизведение';

  @override
  String get loopShortVideos => 'Повтор коротких видео';

  @override
  String get loopShortVideosSub => 'Повторять ролики короче 30 секунд';

  @override
  String get autoPlayOnLaunch => 'Автовоспроизведение при запуске';

  @override
  String get autoPlayOnLaunchSub =>
      'Запускать воспроизведение при открытии ленты';

  @override
  String get defaultFilter => 'Фильтр по умолчанию';

  @override
  String get defaultFilterSub => 'Выберите, что показывать в ленте';

  @override
  String get appearanceSection => 'Оформление';

  @override
  String get darkMode => 'Тёмная тема';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Показывать даты';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Показывать длительность';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'Конфиденциальность';

  @override
  String get privacyVault => 'Личное хранилище';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'О приложении';

  @override
  String get privacyPolicy => 'Политика конфиденциальности';

  @override
  String get privacyPolicyBody =>
      'RollReel не загружает, не передаёт и не хранит ваши видео за пределами устройства. Аккаунт не требуется. Личные данные не передаются третьим лицам.';

  @override
  String get rateApp => 'Оценить RollReel';

  @override
  String get shareApp => 'Поделиться RollReel';

  @override
  String get version => 'Версия';

  @override
  String get settingsFilterDescription =>
      'Выберите, какие видео показывать при открытии ленты.';

  @override
  String get settingsProDescription =>
      'Просмотр без рекламы и личное хранилище';

  @override
  String get settingsProActive => 'Pro активен';

  @override
  String get settingsVaultDescription => 'Откройте свои личные видео';

  @override
  String get settingsRestoreComplete =>
      'Проверка предыдущих покупок завершена.';

  @override
  String get settingsRestoreFailed =>
      'Не удалось восстановить покупки. Попробуйте ещё раз.';

  @override
  String get proCardSubtitle =>
      'Без рекламы · Хранилище · Скорость · Коллекции';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'Попробуйте RollReel — листайте видео из своей галереи, 100% офлайн!';

  @override
  String get vaultTitle => 'Личное хранилище';

  @override
  String get vaultLocked => 'Хранилище заблокировано';

  @override
  String get vaultLockedSubtitle => 'Ваши личные видео здесь в безопасности';

  @override
  String get unlockWithFaceId => 'Разблокировать с Face ID';

  @override
  String get unlockVaultReason => 'Разблокируйте личное хранилище';

  @override
  String get faceIdUnavailable => 'Face ID недоступен на этом устройстве.';

  @override
  String get orDivider => 'OR';

  @override
  String get enterPasscode => 'Enter Passcode';

  @override
  String get vaultBadgeSecureTitle => 'Private & Secure';

  @override
  String get vaultBadgeSecureSub => 'Only you can access your vault';

  @override
  String get vaultBadgeEncryptedTitle => 'End-to-End Encrypted';

  @override
  String get vaultBadgeEncryptedSub => 'Your videos stay fully encrypted';

  @override
  String get vaultBadgeHiddenTitle => 'Hidden & Discreet';

  @override
  String get vaultBadgeHiddenSub => 'Your privacy is our priority';

  @override
  String get authFailed => 'Ошибка аутентификации. Попробуйте ещё раз.';

  @override
  String get vaultLoadFailed => 'Не удалось загрузить хранилище';

  @override
  String get vaultEmpty => 'Хранилище пусто';

  @override
  String get vaultEmptyHint =>
      'Нажмите ••• на любом видео, чтобы добавить его сюда';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'Убрать из хранилища?';

  @override
  String get removeFromVaultBody => 'Это видео вернётся в основную медиатеку.';

  @override
  String get vaultRecoveryLocked =>
      'Чтобы вернуть видео в медиатеку, разблокируйте хранилище.';

  @override
  String get vaultReturnAll => 'Вернуть видео в медиатеку';

  @override
  String get vaultRecoveryBody =>
      'Видео из хранилища можно вернуть в медиатеку в любое время.';

  @override
  String get vaultRecoveryConfirm =>
      'Все видео из хранилища снова появятся в медиатеке RollReel.';

  @override
  String get vaultRecoveryDone => 'Видео возвращены в медиатеку.';

  @override
  String get vaultUpdateFailed =>
      'Не удалось обновить хранилище. Попробуйте ещё раз.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallPlaybackTitle => 'Смотрите дальше.';

  @override
  String get paywallPlaybackBody => 'Ваши видео без рекламных пауз.';

  @override
  String get paywallVaultTitle => 'Только для вас.';

  @override
  String get paywallVaultBody => 'Закрытое хранилище для личных видео.';

  @override
  String get paywallMemoriesTitle => 'Проживите этот день снова.';

  @override
  String get paywallMemoriesBody =>
      'Найдите видео, снятые в этот день в прошлые годы.';

  @override
  String get paywallSpeedTitle => 'Смотрите в своём темпе.';

  @override
  String get paywallAdFree => 'Просмотр без рекламы';

  @override
  String get paywallAdFreeBody => 'Смотрите ролики без рекламы';

  @override
  String get paywallVaultBenefit => 'Закройте выбранные ролики';

  @override
  String get paywallSpeed => 'Удерживайте для скорости 2×';

  @override
  String get paywallSpeedBenefit => 'Нажмите и удерживайте для перемотки';

  @override
  String get paywallMemoriesBenefit => 'Найдите ролики прошлых лет';

  @override
  String get paywallChoosePlan => 'Выберите тариф';

  @override
  String get paywallLifetime => 'Навсегда';

  @override
  String get paywallMonthly => 'Ежемесячно';

  @override
  String get paywallRenewsMonthly => 'Автопродление каждый месяц';

  @override
  String get paywallGetLifetime => 'Купить навсегда';

  @override
  String get paywallSubscribeMonthly => 'Подписаться на месяц';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price/мес.';
  }

  @override
  String paywallLifetimeBilling(String price) {
    return '$price одним платежом. Без подписки.';
  }

  @override
  String paywallMonthlyBilling(String price) {
    return '$price/мес. Автопродление каждый месяц. Отмена в настройках App Store.';
  }

  @override
  String get paywallLoadingPrices => 'Загружаем цены…';

  @override
  String get paywallPricesUnavailable => 'Тарифы недоступны';

  @override
  String get paywallLinkUnavailable =>
      'Не удалось открыть ссылку. Попробуйте ещё раз.';

  @override
  String get paywallTagline => 'Смотрите больше. Волнуйтесь меньше.';

  @override
  String get featureAdFree => 'Без рекламы';

  @override
  String get featureAdFreeSub => 'Никаких перерывов, никогда';

  @override
  String get featureVault => 'Личное хранилище';

  @override
  String get featureVaultSub => 'Защитите личные видео с Face ID';

  @override
  String get featureSpeed => 'Скорость воспроизведения';

  @override
  String get featureSpeedSub => 'Перемотка 2× при долгом нажатии';

  @override
  String get featureOnThisDay => 'В этот день';

  @override
  String get featureOnThisDaySub => 'Пересматривайте видео прошлых лет';

  @override
  String get unlockPro => 'Открыть RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'У вас Pro!';

  @override
  String get lifetimeFooter => 'Разовая покупка · Без подписки';

  @override
  String get monthlyFooter => 'Продлевается ежемесячно · Отмена в любой момент';

  @override
  String get restorePurchases => 'Восстановить покупки';

  @override
  String get subscriptionDisclaimer =>
      'Оплата списывается с Apple ID. Подписка продлевается автоматически, если не отменить её за 24 часа до конца периода.';

  @override
  String get oneTimeDisclaimer =>
      'Payment charged to Apple ID. No subscription. Your access is permanent.';

  @override
  String get onePaymentLabel => 'One-time payment';

  @override
  String get bulletLifetimeAccess => 'Lifetime access';

  @override
  String get bulletAllProFeatures => 'All Pro features';

  @override
  String get bulletFutureUpdates => 'Future updates';

  @override
  String get termsOfUse => 'Условия использования (EULA)';

  @override
  String get lifetimeAccess => 'Пожизненный доступ';

  @override
  String get foundingMember => 'Один из первых';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'Этот план сейчас недоступен. Попробуйте позже.';

  @override
  String get purchaseFailed => 'Покупка не удалась';

  @override
  String get active => 'АКТИВНО';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Повторить';
}

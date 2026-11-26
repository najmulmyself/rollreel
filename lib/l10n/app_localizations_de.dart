// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get watchNext => 'Als Nächstes ansehen';

  @override
  String get seeAll => 'Alle ansehen';

  @override
  String get homeRecordedToday => 'Heute aufgenommene Videos';

  @override
  String get homePlays => 'Wiedergaben';

  @override
  String get homeWatchActivity => 'Wiedergabeaktivität';

  @override
  String get homeWatchStreak => 'Tage in Folge';

  @override
  String get homeMostWatched => 'Am häufigsten angesehen';

  @override
  String get homeTopFolders => 'Top-Ordner';

  @override
  String get homeVideoRecap => 'Video-Rückblick';

  @override
  String get homeRecordedThisYear => 'Dieses Jahr aufgenommene Videos';

  @override
  String get homeWatchedToday => 'Heute angesehen';

  @override
  String get homeTopAlbums => 'Top-Alben';

  @override
  String get playerGuideSwipe => 'Nach oben wischen';

  @override
  String get playerGuideSwipeBody =>
      'Wechsle zum nächsten Video in deiner Mediathek.';

  @override
  String get playerGuideTap => 'Tippen zum Abspielen oder Pausieren';

  @override
  String get playerGuideTapBody =>
      'Tippe einmal auf das Video, um es anzuhalten. Tippe erneut, um es fortzusetzen.';

  @override
  String get playerGuideSeek => 'Doppeltippen zum Spulen';

  @override
  String get playerGuideSeekBody =>
      'Tippe links doppelt für 10 Sekunden zurück oder rechts doppelt für 10 Sekunden vor.';

  @override
  String get playerGuideEdges => 'Am Rand streichen';

  @override
  String get playerGuideEdgesBody =>
      'Streiche links nach oben oder unten für die Helligkeit und rechts für die Lautstärke.';

  @override
  String get playerGuideDone => 'Verstanden';

  @override
  String get homeNoWatchHistory =>
      'Sieh dir ein Video an, um deinen Verlauf zu starten.';

  @override
  String get homeNoVideoAlbums => 'Alben mit Videos erscheinen hier.';

  @override
  String get homeNoVideoFolders => 'Ordner mit Videos erscheinen hier.';

  @override
  String get homeLimitedVideoCollections =>
      'Bei eingeschränktem Zugriff können einige Alben oder Ordner fehlen.';

  @override
  String homeWatchDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString Tage',
      one: '$countString Tag',
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
      other: '$countString Wiedergaben',
      one: '$countString Wiedergabe',
    );
    return '$_temp0';
  }

  @override
  String get homeUnavailable => 'Nicht verfügbar';

  @override
  String get homeLoading => 'Wird geladen…';

  @override
  String get homeCameraRoll => 'Deine\nVideos';

  @override
  String get homeWatchTab => 'Ansehen';

  @override
  String get homeActivityTab => 'Aktivität';

  @override
  String get homeYourActivity => 'Deine Aktivität';

  @override
  String get homeAccessTitle => 'Wähle deine Videos';

  @override
  String get homeAccessBody =>
      'Erlaube in den Einstellungen den Zugriff auf Fotos, um deine Videos anzusehen.';

  @override
  String get homeLoadFailed => 'Deine Videos konnten nicht geladen werden';

  @override
  String get homeLoadFailedBody =>
      'Deine Mediathek wird vielleicht noch synchronisiert. Versuch es erneut.';

  @override
  String get homeNoMemories =>
      'Keine Videos von diesem Datum in früheren Jahren.';

  @override
  String homePlayClip(String title) {
    return '$title abspielen';
  }

  @override
  String get homePlaybackFailed =>
      'Dieses Video konnte nicht abgespielt werden.';

  @override
  String get homePause => 'Pausieren';

  @override
  String get homePlay => 'Abspielen';

  @override
  String get onboardingTitle => 'Zurück zu deinen\nAufnahmen.';

  @override
  String favoritesSavedCount(int count) {
    return '$count gespeichert';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return '$title aus Favoriten entfernen';
  }

  @override
  String get favoritesRemoved => 'Aus Favoriten entfernt';

  @override
  String get favoritesUndo => 'Rückgängig';

  @override
  String get favoritesLoadFailed => 'Favoriten konnten nicht geladen werden';

  @override
  String get favoritesRetryBody =>
      'Versuche erneut, deine gespeicherten Videos zu laden.';

  @override
  String get favoritesAccessBody =>
      'Erlaube den Zugriff auf Fotos, um deine gespeicherten Videos anzuzeigen.';

  @override
  String get favoritesUpdateFailed =>
      'Favoriten konnten nicht aktualisiert werden.';

  @override
  String get onboardingSwipeTitle => 'Wisch nach oben\nzum nächsten Video.';

  @override
  String get onboardingSwipeSubtitle => 'Probier es in der Vorschau aus.';

  @override
  String get onboardingTrySwipe => 'Wischen ausprobieren';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Beispielvideo $current von $total';
  }

  @override
  String get onboardingNextSample => 'Nächstes Beispielvideo anzeigen';

  @override
  String get onboardingLimitedTitle => 'Einzelne Videos wählen';

  @override
  String get onboardingLimitedBody =>
      'Wähle im System aus, welche Elemente RollReel sehen darf.';

  @override
  String get onboardingFullTitle => 'Ganze Mediathek erlauben';

  @override
  String get onboardingFullBody =>
      'Durchstöbere alle Videos. Den Zugriff kannst du in den Einstellungen ändern.';

  @override
  String get onboardingChooseVideos => 'Videos auswählen';

  @override
  String get onboardingNotNow => 'Jetzt nicht';

  @override
  String get onboardingSubtitle =>
      'Schau dir die kleinen Momente an, die du gefilmt hast.';

  @override
  String get onboardingPrivacyBody =>
      'Deine Videos werden direkt auf deinem Gerät abgespielt. Du brauchst kein Konto und keinen Upload.';

  @override
  String get onboardingPermissionBody =>
      'Erlaube den Zugriff auf deine Fotomediathek, damit RollReel deine Videos finden und abspielen kann.';

  @override
  String get onboardingAccessBody =>
      'RollReel braucht Zugriff auf Fotos, um deine Videos anzuzeigen.';

  @override
  String get onboardingPermissionNote =>
      'Du kannst den Zugriff jederzeit in den Einstellungen ändern.';

  @override
  String get onboardingPermissionError =>
      'Der Zugriff konnte nicht angefragt werden. Versuche es erneut oder überspringe diesen Schritt.';

  @override
  String onboardingStep(int step, int total) {
    return 'Schritt $step von $total';
  }

  @override
  String get onboardingPrivacyTitle => 'Nur für dich.';

  @override
  String get onboardingPermissionTitle =>
      'Welche Videos\ndürfen wir abspielen?';

  @override
  String get onboardingNoCloud => 'Keine Cloud';

  @override
  String get onboardingNoAccount => 'Kein Konto';

  @override
  String get onboardingNoTracking => 'Kein Tracking';

  @override
  String get swipeHint => 'WISCHEN';

  @override
  String get skip => 'Überspringen';

  @override
  String get getStarted => 'Los geht\'s';

  @override
  String get continueLabel => 'Weiter';

  @override
  String get requesting => 'Wird angefragt…';

  @override
  String get allowAccess => 'Zugriff erlauben';

  @override
  String get noVideosYetTitle => 'Noch keine Videos';

  @override
  String get noVideosYetBody =>
      'Deine Videos aus der Mediathek erscheinen hier.';

  @override
  String get openPhotosApp => 'Fotos-App öffnen';

  @override
  String get loadingLibrary => 'Mediathek wird geladen...';

  @override
  String get permissionDeniedTitle => 'Der Zugriff auf Fotos\nist aus.';

  @override
  String get permissionDeniedBody =>
      'Wähle Videos in den Einstellungen, wenn du möchtest. Du kannst RollReel weiter erkunden.';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get continueAnyway => 'Trotzdem fortfahren';

  @override
  String get today => 'Heute';

  @override
  String get yesterday => 'Gestern';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Zurück';

  @override
  String get remove => 'Entfernen';

  @override
  String get manage => 'Verwalten';

  @override
  String get videoFallbackTitle => 'Video';

  @override
  String get filterAll => 'Alle';

  @override
  String get filterToday => 'Heute';

  @override
  String get filterShorts => 'Kurz';

  @override
  String get filterLong => 'Lang';

  @override
  String get filterRecent => 'Neueste';

  @override
  String get videoDeleted => 'Video gelöscht';

  @override
  String get getInfo => 'Informationen';

  @override
  String get addToVault => 'Zum Tresor hinzufügen';

  @override
  String get removeFromVault => 'Aus Tresor entfernen';

  @override
  String get deleteVideo => 'Video löschen';

  @override
  String get deleteVideoWarning =>
      'Das Video wird dauerhaft aus deiner Mediathek gelöscht.';

  @override
  String get thisVideo => 'Dieses Video';

  @override
  String get share => 'Teilen';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Erweitern';

  @override
  String get photoLibraryAccess => 'Zugriff auf Fotomediathek';

  @override
  String get limitedAccessMessage =>
      'Du teilst derzeit nur eine begrenzte Auswahl an Videos.';

  @override
  String get selectMoreVideos => 'Weitere Videos auswählen';

  @override
  String get allowFullAccess => 'Vollzugriff erlauben';

  @override
  String managingCount(int count) {
    return '$count deiner Videos werden verwaltet';
  }

  @override
  String get infoDate => 'Datum';

  @override
  String get infoDuration => 'Dauer';

  @override
  String get infoResolution => 'Auflösung';

  @override
  String get infoFileSize => 'Dateigröße';

  @override
  String get infoFormat => 'Format';

  @override
  String get feed => 'Feed';

  @override
  String get library => 'Mediathek';

  @override
  String get libraryFilters => 'Filter';

  @override
  String get libraryClose => 'Schließen';

  @override
  String get libraryEmptyTitle => 'Noch keine Videos';

  @override
  String get libraryAccessOff => 'Der Zugriff auf Fotos ist deaktiviert';

  @override
  String get libraryNoMatches => 'Keine passenden Videos';

  @override
  String get librarySearchHelp =>
      'Versuche einen anderen Titel oder lösche die Suche.';

  @override
  String get libraryNoFilterMatches =>
      'Keine Videos entsprechen diesen Filtern';

  @override
  String get libraryFilterHelp =>
      'Deaktiviere die Filter, um alle Videos zu sehen.';

  @override
  String get libraryUnknownDate => 'Datum unbekannt';

  @override
  String get libraryDeleteFailed => 'RollReel konnte das Video nicht löschen.';

  @override
  String libraryDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Videos',
      one: '1 Video',
    );
    return '$_temp0 auf diesem Gerät';
  }

  @override
  String libraryMemoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Videos',
      one: '1 Video',
    );
    return '$_temp0 aus früheren Jahren';
  }

  @override
  String libraryVideoOptions(String title) {
    return 'Optionen für $title';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => 'Noch keine Favoriten';

  @override
  String get favoritesEmptyBody =>
      'Tippe beim Anschauen eines Videos auf das Herz, um es hier zu speichern.';

  @override
  String get goToLibrary => 'Mediathek ansehen';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'Videos suchen…';

  @override
  String get videosTitle => 'Videos';

  @override
  String videosCount(int count) {
    return '$count Videos';
  }

  @override
  String get yourLibrary => 'Deine Mediathek';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Lokal';

  @override
  String get noResults => 'Keine Ergebnisse';

  @override
  String get noVideosFound => 'Keine Videos gefunden';

  @override
  String noSearchMatches(String query) {
    return 'Keine Videos für \"$query\".';
  }

  @override
  String get tryDifferentFilter => 'Versuche einen anderen Filter.';

  @override
  String get clearSearch => 'Suche löschen';

  @override
  String get clearFilters => 'Filter zurücksetzen';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Zurücksetzen';

  @override
  String get timePeriod => 'ZEITRAUM';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get thisMonth => 'Dieser Monat';

  @override
  String get duration => 'DAUER';

  @override
  String get any => 'Beliebig';

  @override
  String get durationShort => '< 1 Min.';

  @override
  String get durationMedium => '1–5 Min.';

  @override
  String get durationLong => '> 5 Min.';

  @override
  String get sortBy => 'SORTIEREN NACH';

  @override
  String get newestFirst => 'Neueste zuerst';

  @override
  String get oldestFirst => 'Älteste zuerst';

  @override
  String get shortestFirst => 'Kürzeste zuerst';

  @override
  String get longestFirst => 'Längste zuerst';

  @override
  String get applyFilters => 'Filter anwenden';

  @override
  String get onThisDay => 'An diesem Tag';

  @override
  String onThisDaySubtitleOne(String years) {
    return '1 Erinnerung aus $years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '$count Erinnerungen aus vergangenen Jahren';
  }

  @override
  String get yearsAgoOne => 'Vor 1 Jahr';

  @override
  String yearsAgoMany(int years) {
    return 'Vor $years Jahren';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'An diesem Tag · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current von $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'Erinnerungen konnten nicht geladen werden: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'Videos konnten nicht geladen werden: $error';
  }

  @override
  String get settings => 'Einstellungen';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favoriten';

  @override
  String get playbackSection => 'Wiedergabe';

  @override
  String get loopShortVideos => 'Kurze Videos wiederholen';

  @override
  String get loopShortVideosSub => 'Clips unter 30 Sekunden wiederholen';

  @override
  String get autoPlayOnLaunch => 'Autoplay beim Start';

  @override
  String get autoPlayOnLaunchSub => 'Wiedergabe beim Öffnen des Feeds starten';

  @override
  String get defaultFilter => 'Standardfilter';

  @override
  String get defaultFilterSub => 'Inhalte für den Feed auswählen';

  @override
  String get appearanceSection => 'Darstellung';

  @override
  String get darkMode => 'Dunkelmodus';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Datum anzeigen';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Dauer anzeigen';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'Datenschutz';

  @override
  String get privacyVault => 'Privater Tresor';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'Info';

  @override
  String get privacyPolicy => 'Datenschutzrichtlinie';

  @override
  String get privacyPolicyBody =>
      'RollReel lädt deine Videos nicht hoch, überträgt sie nicht und speichert sie nicht außerhalb deines Geräts. Es ist kein Konto erforderlich. Es werden keine persönlichen Daten an Dritte weitergegeben.';

  @override
  String get rateApp => 'RollReel bewerten';

  @override
  String get shareApp => 'RollReel teilen';

  @override
  String get version => 'Version';

  @override
  String get settingsFilterDescription =>
      'Wähle, welche Videos beim Öffnen des Feeds angezeigt werden.';

  @override
  String get settingsProDescription =>
      'Werbefreie Wiedergabe und privater Tresor';

  @override
  String get settingsProActive => 'Pro ist aktiv';

  @override
  String get settingsVaultDescription => 'Öffne deine privaten Videos';

  @override
  String get settingsRestoreComplete => 'Frühere Käufe wurden geprüft.';

  @override
  String get settingsRestoreFailed =>
      'Käufe konnten nicht wiederhergestellt werden. Versuche es erneut.';

  @override
  String get proCardSubtitle => 'Werbefrei · Tresor · Tempo · Sammlungen';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'Schau dir RollReel an – wische durch deine Kamera-Videos, 100 % offline!';

  @override
  String get vaultTitle => 'Privater Tresor';

  @override
  String get vaultLocked => 'Tresor gesperrt';

  @override
  String get vaultLockedSubtitle =>
      'Entsperre den Tresor mit Biometrie oder deinem Gerätecode.';

  @override
  String get unlockWithFaceId => 'Mit Face ID entsperren';

  @override
  String get unlockVaultReason => 'Entsperre deinen privaten Tresor';

  @override
  String get faceIdUnavailable =>
      'Face ID ist auf diesem Gerät nicht verfügbar.';

  @override
  String get orDivider => 'OR';

  @override
  String get enterPasscode => 'Enter Passcode';

  @override
  String get vaultBadgeSecureTitle => 'Private & Secure';

  @override
  String get vaultBadgeSecureSub => 'Only you can access your vault';

  @override
  String get vaultBadgePhotosTitle => 'Originalvideos';

  @override
  String get vaultBadgePhotosSub => 'Bleiben in Fotos';

  @override
  String get vaultBadgeHiddenTitle => 'Hidden & Discreet';

  @override
  String get vaultBadgeHiddenSub => 'Your privacy is our priority';

  @override
  String get authFailed =>
      'Authentifizierung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get vaultLoadFailed => 'Tresor konnte nicht geladen werden';

  @override
  String get vaultEmpty => 'Tresor ist leer';

  @override
  String get vaultEmptyHint =>
      'Tippe bei einem Video auf •••, um es hinzuzufügen';

  @override
  String get vaultEmptySubtitle =>
      'Wenn du ein Video zum Tresor hinzufügst, wird es in RollReel ausgeblendet. Das Original bleibt in der Fotos-App.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'Aus Tresor entfernen?';

  @override
  String get removeFromVaultBody =>
      'Dieses Video kehrt in deine Hauptmediathek zurück.';

  @override
  String get vaultRecoveryLocked =>
      'Entsperre den Tresor, um deine Videos in die Mediathek zurückzuholen.';

  @override
  String get vaultReturnAll => 'Videos in die Mediathek zurückholen';

  @override
  String get vaultRecoveryBody =>
      'Du kannst deine Videos jederzeit aus dem Tresor in die Mediathek zurückholen.';

  @override
  String get vaultRecoveryConfirm =>
      'Alle Videos aus dem Tresor sind dann wieder in deiner RollReel-Mediathek sichtbar.';

  @override
  String get vaultRecoveryDone => 'Videos sind wieder in der Mediathek.';

  @override
  String get vaultUpdateFailed =>
      'Der Tresor konnte nicht aktualisiert werden. Versuche es erneut.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallPlaybackTitle => 'Schau weiter.';

  @override
  String get paywallPlaybackBody => 'Deine Videos ohne Werbepausen.';

  @override
  String get paywallVaultTitle => 'Nur für dich.';

  @override
  String get paywallVaultBody =>
      'Ein geschützter Ort für deine privaten Videos.';

  @override
  String get paywallMemoriesTitle => 'Erlebe den Tag erneut.';

  @override
  String get paywallMemoriesBody =>
      'Finde Videos vom selben Tag aus früheren Jahren.';

  @override
  String get paywallSpeedTitle => 'Schau in deinem Tempo.';

  @override
  String get paywallAdFree => 'Werbefreie Wiedergabe';

  @override
  String get paywallAdFreeBody => 'Clips ohne Werbepausen ansehen';

  @override
  String get paywallVaultBenefit => 'Sperre die Clips deiner Wahl';

  @override
  String get paywallSpeed => 'Halten für 2× Tempo';

  @override
  String get paywallSpeedBenefit => 'Zum Vorspulen gedrückt halten';

  @override
  String get paywallMemoriesBenefit => 'Entdecke Clips aus früheren Jahren';

  @override
  String get paywallChoosePlan => 'Wähle einen Tarif';

  @override
  String get paywallLifetime => 'Lebenslang';

  @override
  String get paywallMonthly => 'Monatlich';

  @override
  String get paywallRenewsMonthly => 'Verlängert sich monatlich';

  @override
  String get paywallGetLifetime => 'Lebenslang freischalten';

  @override
  String get paywallSubscribeMonthly => 'Monatlich abonnieren';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price/Monat';
  }

  @override
  String paywallLifetimeBilling(String price) {
    return '$price einmalig. Ohne Abo.';
  }

  @override
  String paywallMonthlyBilling(String price) {
    return '$price/Monat. Verlängert sich automatisch. Kündigung in den App-Store-Einstellungen.';
  }

  @override
  String get paywallLoadingPrices => 'Preise werden geladen…';

  @override
  String get paywallPricesUnavailable => 'Tarife nicht verfügbar';

  @override
  String get paywallLinkUnavailable =>
      'Der Link konnte nicht geöffnet werden. Versuche es erneut.';

  @override
  String get paywallTagline => 'Mehr sehen. Weniger sorgen.';

  @override
  String get featureAdFree => 'Werbefreies Erlebnis';

  @override
  String get featureAdFreeSub => 'Keine Unterbrechungen, nie';

  @override
  String get featureVault => 'Privater Tresor';

  @override
  String get featureVaultSub => 'Sensible Videos mit Face ID sperren';

  @override
  String get featureSpeed => 'Wiedergabegeschwindigkeit';

  @override
  String get featureSpeedSub => '2× Vorlauf durch langes Drücken';

  @override
  String get featureOnThisDay => 'An diesem Tag';

  @override
  String get featureOnThisDaySub => 'Videos aus vergangenen Jahren neu erleben';

  @override
  String get unlockPro => 'RollReel Pro freischalten';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'Du bist Pro!';

  @override
  String get lifetimeFooter => 'Einmaliger Kauf · Kein Abo';

  @override
  String get monthlyFooter => 'Verlängert sich monatlich · Jederzeit kündbar';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get subscriptionDisclaimer =>
      'Die Zahlung wird über die Apple ID abgerechnet. Das Abo verlängert sich automatisch, sofern es nicht mindestens 24 Std. vor Ablauf des Zeitraums gekündigt wird.';

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
  String get termsOfUse => 'Nutzungsbedingungen (EULA)';

  @override
  String get lifetimeAccess => 'Lebenslanger Zugriff';

  @override
  String get foundingMember => 'Gründungsmitglied';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'Dieser Plan ist derzeit nicht verfügbar. Bitte versuche es später erneut.';

  @override
  String get purchaseFailed => 'Kauf fehlgeschlagen';

  @override
  String get active => 'AKTIV';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Erneut versuchen';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsSystemLanguage => 'Systemstandard';

  @override
  String get settingsLanguageSaveFailed =>
      'Die Sprache konnte nicht gespeichert werden. Bitte versuche es erneut.';

  @override
  String get updateAvailableTitle => 'Eine neue Version von RollReel ist da';

  @override
  String updateAvailableBody(String version) {
    return 'Version $version ist im App Store verfügbar. Aktualisiere die App, wenn du bereit bist.';
  }

  @override
  String get updateNow => 'Aktualisieren';

  @override
  String get updateStoreUnavailable =>
      'Der App Store konnte nicht geöffnet werden. Bitte versuche es erneut.';
}

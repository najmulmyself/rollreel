// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get watchNext => 'Da guardare';

  @override
  String get seeAll => 'Vedi tutto';

  @override
  String get homeRecordedToday => 'Video registrati oggi';

  @override
  String get homePlays => 'Riproduzioni';

  @override
  String get homeWatchActivity => 'Attività di visione';

  @override
  String get homeWatchStreak => 'Giorni di visione consecutivi';

  @override
  String get homeMostWatched => 'Più guardati';

  @override
  String get homeTopFolders => 'Cartelle principali';

  @override
  String get homeVideoRecap => 'Riepilogo video';

  @override
  String get homeRecordedThisYear => 'Video registrati quest’anno';

  @override
  String get homeWatchedToday => 'Video guardati oggi';

  @override
  String get homeTopAlbums => 'Album principali';

  @override
  String get playerGuideSwipe => 'Scorri verso l’alto';

  @override
  String get playerGuideSwipeBody =>
      'Passa al video successivo della tua libreria.';

  @override
  String get playerGuideTap => 'Tocca per riprodurre o mettere in pausa';

  @override
  String get playerGuideTapBody =>
      'Tocca il video una volta per metterlo in pausa. Toccalo di nuovo per riprendere.';

  @override
  String get playerGuideSeek => 'Tocca due volte per saltare';

  @override
  String get playerGuideSeekBody =>
      'Tocca due volte a sinistra per tornare indietro di 10 secondi o a destra per avanzare di 10 secondi.';

  @override
  String get playerGuideEdges => 'Scorri lungo i bordi';

  @override
  String get playerGuideEdgesBody =>
      'Scorri verso l’alto o il basso sul bordo sinistro per la luminosità e sul destro per il volume.';

  @override
  String get playerGuideDone => 'Ho capito';

  @override
  String get homeNoWatchHistory =>
      'Guarda un video per iniziare la cronologia.';

  @override
  String get homeNoVideoAlbums =>
      'Qui appariranno gli album che contengono video.';

  @override
  String get homeNoVideoFolders =>
      'Qui appariranno le cartelle che contengono video.';

  @override
  String get homeLimitedVideoCollections =>
      'L’accesso limitato può nascondere alcuni album o cartelle.';

  @override
  String homeWatchDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString giorni',
      one: '$countString giorno',
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
      other: '$countString riproduzioni',
      one: '$countString riproduzione',
    );
    return '$_temp0';
  }

  @override
  String get homeUnavailable => 'Non disponibile';

  @override
  String get homeLoading => 'Caricamento…';

  @override
  String get homeCameraRoll => 'I tuoi\nvideo';

  @override
  String get homeWatchTab => 'Guarda';

  @override
  String get homeActivityTab => 'Attività';

  @override
  String get homeYourActivity => 'La tua attività';

  @override
  String get homeAccessTitle => 'Scegli i tuoi video';

  @override
  String get homeAccessBody =>
      'Consenti l’accesso a Foto nelle Impostazioni per guardare i tuoi video.';

  @override
  String get homeLoadFailed => 'Impossibile caricare i tuoi video';

  @override
  String get homeLoadFailedBody =>
      'La libreria potrebbe essere ancora in sincronizzazione. Riprova.';

  @override
  String get homeNoMemories =>
      'Nessun video di questa data negli anni passati.';

  @override
  String homePlayClip(String title) {
    return 'Riproduci $title';
  }

  @override
  String get homePlaybackFailed => 'Impossibile riprodurre questo video.';

  @override
  String get homePause => 'Pausa';

  @override
  String get homePlay => 'Riproduci';

  @override
  String get onboardingTitle => 'Torna al tuo\nrullino.';

  @override
  String favoritesSavedCount(int count) {
    return '$count salvati';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return 'Rimuovi $title dai preferiti';
  }

  @override
  String get favoritesRemoved => 'Rimosso dai preferiti';

  @override
  String get favoritesUndo => 'Annulla';

  @override
  String get favoritesLoadFailed => 'Impossibile caricare i preferiti';

  @override
  String get favoritesRetryBody => 'Prova a caricare di nuovo i video salvati.';

  @override
  String get favoritesAccessBody =>
      'Consenti l’accesso a Foto per vedere i video salvati.';

  @override
  String get favoritesUpdateFailed => 'Impossibile aggiornare i preferiti.';

  @override
  String get onboardingSwipeTitle =>
      'Scorri verso l’alto\nper il prossimo video.';

  @override
  String get onboardingSwipeSubtitle => 'Prova nell’anteprima qui sotto.';

  @override
  String get onboardingTrySwipe => 'Prova a scorrere';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Video di esempio $current di $total';
  }

  @override
  String get onboardingNextSample => 'Mostra il prossimo video di esempio';

  @override
  String get onboardingLimitedTitle => 'Scegli video specifici';

  @override
  String get onboardingLimitedBody =>
      'Seleziona dal sistema gli elementi che RollReel può vedere.';

  @override
  String get onboardingFullTitle => 'Consenti tutta la libreria';

  @override
  String get onboardingFullBody =>
      'Sfoglia tutti i video. Puoi cambiare l’accesso nelle Impostazioni.';

  @override
  String get onboardingChooseVideos => 'Scegli video';

  @override
  String get onboardingNotNow => 'Non ora';

  @override
  String get onboardingSubtitle =>
      'Rivedi i piccoli momenti che hai filmato, un video alla volta.';

  @override
  String get onboardingPrivacyBody =>
      'I tuoi video vengono riprodotti sul dispositivo. Non serve un account né caricare la libreria.';

  @override
  String get onboardingPermissionBody =>
      'Consenti l’accesso alla libreria foto per permettere a RollReel di trovare e riprodurre i tuoi video.';

  @override
  String get onboardingAccessBody =>
      'RollReel accede a Foto per mostrare i video del rullino.';

  @override
  String get onboardingPermissionNote =>
      'Puoi modificare l’accesso in qualsiasi momento nelle Impostazioni.';

  @override
  String get onboardingPermissionError =>
      'Impossibile richiedere l’accesso. Riprova o salta questo passaggio.';

  @override
  String onboardingStep(int step, int total) {
    return 'Passaggio $step di $total';
  }

  @override
  String get onboardingPrivacyTitle => 'Solo per te.';

  @override
  String get onboardingPermissionTitle => 'Quali video\npossiamo riprodurre?';

  @override
  String get onboardingNoCloud => 'Niente cloud';

  @override
  String get onboardingNoAccount => 'Nessun account';

  @override
  String get onboardingNoTracking => 'Zero tracciamento';

  @override
  String get swipeHint => 'SCORRI';

  @override
  String get skip => 'Salta';

  @override
  String get getStarted => 'Inizia';

  @override
  String get continueLabel => 'Continua';

  @override
  String get requesting => 'Richiesta in corso…';

  @override
  String get allowAccess => 'Consenti accesso';

  @override
  String get noVideosYetTitle => 'Ancora nessun video';

  @override
  String get noVideosYetBody => 'I video del tuo rullino appariranno qui.';

  @override
  String get openPhotosApp => 'Apri l\'app Foto';

  @override
  String get loadingLibrary => 'Caricamento della libreria...';

  @override
  String get permissionDeniedTitle => 'L’accesso a Foto\nè disattivato.';

  @override
  String get permissionDeniedBody =>
      'Scegli i video nelle Impostazioni quando vuoi. Puoi continuare a esplorare RollReel.';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get continueAnyway => 'Continua comunque';

  @override
  String get today => 'Oggi';

  @override
  String get yesterday => 'Ieri';

  @override
  String get cancel => 'Annulla';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Indietro';

  @override
  String get remove => 'Rimuovi';

  @override
  String get manage => 'Gestisci';

  @override
  String get videoFallbackTitle => 'Video';

  @override
  String get filterAll => 'Tutti';

  @override
  String get filterToday => 'Oggi';

  @override
  String get filterShorts => 'Brevi';

  @override
  String get filterLong => 'Lunghi';

  @override
  String get filterRecent => 'Recenti';

  @override
  String get videoDeleted => 'Video eliminato';

  @override
  String get getInfo => 'Info';

  @override
  String get addToVault => 'Aggiungi alla cassaforte';

  @override
  String get removeFromVault => 'Rimuovi dalla cassaforte';

  @override
  String get deleteVideo => 'Elimina video';

  @override
  String get deleteVideoWarning =>
      'Il video verrà eliminato definitivamente dalla tua libreria.';

  @override
  String get thisVideo => 'Questo video';

  @override
  String get share => 'Condividi';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Espandi';

  @override
  String get photoLibraryAccess => 'Accesso alla libreria foto';

  @override
  String get limitedAccessMessage =>
      'Stai condividendo una selezione limitata di video.';

  @override
  String get selectMoreVideos => 'Seleziona altri video';

  @override
  String get allowFullAccess => 'Consenti accesso completo';

  @override
  String managingCount(int count) {
    return 'Gestione di $count dei tuoi video';
  }

  @override
  String get infoDate => 'Data';

  @override
  String get infoDuration => 'Durata';

  @override
  String get infoResolution => 'Risoluzione';

  @override
  String get infoFileSize => 'Dimensione file';

  @override
  String get infoFormat => 'Formato';

  @override
  String get feed => 'Feed';

  @override
  String get library => 'Libreria';

  @override
  String get libraryFilters => 'Filtri';

  @override
  String get libraryClose => 'Chiudi';

  @override
  String get libraryEmptyTitle => 'Ancora nessun video';

  @override
  String get libraryAccessOff => 'L’accesso a Foto è disattivato';

  @override
  String get libraryNoMatches => 'Nessun video corrispondente';

  @override
  String get librarySearchHelp =>
      'Prova con un altro titolo o cancella la ricerca.';

  @override
  String get libraryNoFilterMatches =>
      'Nessun video corrisponde a questi filtri';

  @override
  String get libraryFilterHelp => 'Cancella i filtri per vedere tutti i video.';

  @override
  String get libraryUnknownDate => 'Data sconosciuta';

  @override
  String get libraryDeleteFailed =>
      'RollReel non ha potuto eliminare il video.';

  @override
  String libraryDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video',
      one: '1 video',
    );
    return '$_temp0 su questo dispositivo';
  }

  @override
  String libraryMemoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count video',
      one: '1 video',
    );
    return '$_temp0 degli anni passati';
  }

  @override
  String libraryVideoOptions(String title) {
    return 'Opzioni per $title';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => 'Ancora nessun preferito';

  @override
  String get favoritesEmptyBody =>
      'Tocca il cuore mentre guardi un video per salvarlo qui.';

  @override
  String get goToLibrary => 'Sfoglia la libreria';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'Cerca video…';

  @override
  String get videosTitle => 'Video';

  @override
  String videosCount(int count) {
    return '$count video';
  }

  @override
  String get yourLibrary => 'La tua libreria';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Locale';

  @override
  String get noResults => 'Nessun risultato';

  @override
  String get noVideosFound => 'Nessun video trovato';

  @override
  String noSearchMatches(String query) {
    return 'Nessun video corrisponde a \"$query\".';
  }

  @override
  String get tryDifferentFilter => 'Prova un filtro diverso.';

  @override
  String get clearSearch => 'Cancella ricerca';

  @override
  String get clearFilters => 'Cancella filtri';

  @override
  String get filter => 'Filtro';

  @override
  String get reset => 'Ripristina';

  @override
  String get timePeriod => 'PERIODO';

  @override
  String get thisWeek => 'Questa settimana';

  @override
  String get thisMonth => 'Questo mese';

  @override
  String get duration => 'DURATA';

  @override
  String get any => 'Qualsiasi';

  @override
  String get durationShort => '< 1 min';

  @override
  String get durationMedium => '1–5 min';

  @override
  String get durationLong => '> 5 min';

  @override
  String get sortBy => 'ORDINA PER';

  @override
  String get newestFirst => 'Prima i più recenti';

  @override
  String get oldestFirst => 'Prima i più vecchi';

  @override
  String get shortestFirst => 'Prima i più brevi';

  @override
  String get longestFirst => 'Prima i più lunghi';

  @override
  String get applyFilters => 'Applica filtri';

  @override
  String get onThisDay => 'Accadde oggi';

  @override
  String onThisDaySubtitleOne(String years) {
    return '1 ricordo di $years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '$count ricordi degli anni passati';
  }

  @override
  String get yearsAgoOne => '1 anno fa';

  @override
  String yearsAgoMany(int years) {
    return '$years anni fa';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'Accadde oggi · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current di $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'Impossibile caricare i ricordi: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'Impossibile caricare i video: $error';
  }

  @override
  String get settings => 'Impostazioni';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Preferiti';

  @override
  String get playbackSection => 'Riproduzione';

  @override
  String get loopShortVideos => 'Ripeti video brevi';

  @override
  String get loopShortVideosSub => 'Ripeti le clip sotto i 30 secondi';

  @override
  String get autoPlayOnLaunch => 'Riproduzione automatica all\'avvio';

  @override
  String get autoPlayOnLaunchSub => 'Avvia la riproduzione quando apri il feed';

  @override
  String get defaultFilter => 'Filtro predefinito';

  @override
  String get defaultFilterSub => 'Scegli cosa vedere nel feed';

  @override
  String get appearanceSection => 'Aspetto';

  @override
  String get darkMode => 'Modalità scura';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Mostra etichette data';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Mostra durata';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'Privacy';

  @override
  String get privacyVault => 'Cassaforte privata';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'Informazioni';

  @override
  String get privacyPolicy => 'Informativa sulla privacy';

  @override
  String get privacyPolicyBody =>
      'RollReel non carica, trasmette né archivia i tuoi video al di fuori del tuo dispositivo. Non è richiesto alcun account. Nessun dato personale viene condiviso con terze parti.';

  @override
  String get rateApp => 'Valuta RollReel';

  @override
  String get shareApp => 'Condividi RollReel';

  @override
  String get version => 'Versione';

  @override
  String get settingsFilterDescription =>
      'Scegli quali video vedere quando apri il feed.';

  @override
  String get settingsProDescription =>
      'Riproduzione senza pubblicità e cassaforte privata';

  @override
  String get settingsProActive => 'Pro è attivo';

  @override
  String get settingsVaultDescription => 'Apri i tuoi video privati';

  @override
  String get settingsRestoreComplete =>
      'Verifica degli acquisti precedenti completata.';

  @override
  String get settingsRestoreFailed =>
      'Impossibile ripristinare gli acquisti. Riprova.';

  @override
  String get proCardSubtitle =>
      'Senza pubblicità · Cassaforte · Velocità · Raccolte';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'Scopri RollReel – scorri i video del tuo rullino, 100% offline!';

  @override
  String get vaultTitle => 'Cassaforte privata';

  @override
  String get vaultLocked => 'Cassaforte bloccata';

  @override
  String get vaultLockedSubtitle =>
      'Sblocca la cassaforte con la biometria o con il codice del dispositivo.';

  @override
  String get unlockWithFaceId => 'Sblocca con Face ID';

  @override
  String get unlockVaultReason => 'Sblocca la tua cassaforte privata';

  @override
  String get faceIdUnavailable =>
      'Face ID non è disponibile su questo dispositivo.';

  @override
  String get orDivider => 'OR';

  @override
  String get enterPasscode => 'Enter Passcode';

  @override
  String get vaultBadgeSecureTitle => 'Private & Secure';

  @override
  String get vaultBadgeSecureSub => 'Only you can access your vault';

  @override
  String get vaultBadgePhotosTitle => 'Video originali';

  @override
  String get vaultBadgePhotosSub => 'Restano in Foto';

  @override
  String get vaultBadgeHiddenTitle => 'Hidden & Discreet';

  @override
  String get vaultBadgeHiddenSub => 'Your privacy is our priority';

  @override
  String get authFailed => 'Autenticazione non riuscita. Riprova.';

  @override
  String get vaultLoadFailed => 'Impossibile caricare la cassaforte';

  @override
  String get vaultEmpty => 'La cassaforte è vuota';

  @override
  String get vaultEmptyHint => 'Tocca ••• su un video per aggiungerlo qui';

  @override
  String get vaultEmptySubtitle =>
      'Un video aggiunto alla cassaforte viene nascosto in RollReel. L’originale resta nell’app Foto.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'Rimuovere dalla cassaforte?';

  @override
  String get removeFromVaultBody =>
      'Questo video tornerà nella tua libreria principale.';

  @override
  String get vaultRecoveryLocked =>
      'Sblocca la cassaforte per riportare i video nella libreria.';

  @override
  String get vaultReturnAll => 'Riporta i video nella libreria';

  @override
  String get vaultRecoveryBody =>
      'Puoi riportare i video dalla cassaforte alla libreria in qualsiasi momento.';

  @override
  String get vaultRecoveryConfirm =>
      'Tutti i video nella cassaforte saranno di nuovo visibili nella tua libreria RollReel.';

  @override
  String get vaultRecoveryDone => 'I video sono tornati nella libreria.';

  @override
  String get vaultUpdateFailed =>
      'Impossibile aggiornare la cassaforte. Riprova.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallPlaybackTitle => 'Continua a guardare.';

  @override
  String get paywallPlaybackBody =>
      'I tuoi video, senza interruzioni pubblicitarie.';

  @override
  String get paywallVaultTitle => 'Tieni tutto per te.';

  @override
  String get paywallVaultBody =>
      'Uno spazio protetto per i tuoi video privati.';

  @override
  String get paywallMemoriesTitle => 'Rivivi questo giorno.';

  @override
  String get paywallMemoriesBody =>
      'Trova i video di questo giorno negli anni passati.';

  @override
  String get paywallSpeedTitle => 'Guarda al tuo ritmo.';

  @override
  String get paywallAdFree => 'Riproduzione senza pubblicità';

  @override
  String get paywallAdFreeBody => 'Riguarda i clip senza pubblicità';

  @override
  String get paywallVaultBenefit => 'Proteggi i clip che scegli';

  @override
  String get paywallSpeed => 'Tieni premuto per andare a 2×';

  @override
  String get paywallSpeedBenefit => 'Tieni premuto per avanzare rapidamente';

  @override
  String get paywallMemoriesBenefit => 'Riscopri i clip degli anni passati';

  @override
  String get paywallChoosePlan => 'Scegli un piano';

  @override
  String get paywallLifetime => 'A vita';

  @override
  String get paywallMonthly => 'Mensile';

  @override
  String get paywallRenewsMonthly => 'Rinnovo mensile automatico';

  @override
  String get paywallGetLifetime => 'Ottieni l’accesso a vita';

  @override
  String get paywallSubscribeMonthly => 'Abbonati al mese';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price/mese';
  }

  @override
  String paywallLifetimeBilling(String price) {
    return 'Un solo pagamento di $price. Senza abbonamento.';
  }

  @override
  String paywallMonthlyBilling(String price) {
    return '$price/mese. Rinnovo automatico. Annulla dalle impostazioni dell’App Store.';
  }

  @override
  String get paywallLoadingPrices => 'Caricamento dei prezzi…';

  @override
  String get paywallPricesUnavailable => 'Piani non disponibili';

  @override
  String get paywallLinkUnavailable => 'Impossibile aprire il link. Riprova.';

  @override
  String get paywallTagline => 'Guarda di più. Senza pensieri.';

  @override
  String get featureAdFree => 'Esperienza senza pubblicità';

  @override
  String get featureAdFreeSub => 'Nessuna interruzione, mai';

  @override
  String get featureVault => 'Cassaforte privata';

  @override
  String get featureVaultSub => 'Proteggi i video sensibili con Face ID';

  @override
  String get featureSpeed => 'Controllo velocità di riproduzione';

  @override
  String get featureSpeedSub => 'Avanzamento 2× con pressione prolungata';

  @override
  String get featureOnThisDay => 'Accadde oggi';

  @override
  String get featureOnThisDaySub => 'Rivivi i video degli anni passati';

  @override
  String get unlockPro => 'Sblocca RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'Sei Pro!';

  @override
  String get lifetimeFooter => 'Acquisto unico · Nessun abbonamento';

  @override
  String get monthlyFooter =>
      'Rinnovo mensile automatico · Annulla quando vuoi';

  @override
  String get restorePurchases => 'Ripristina acquisti';

  @override
  String get subscriptionDisclaimer =>
      'Pagamento addebitato sull\'ID Apple. L\'abbonamento si rinnova automaticamente se non annullato 24 ore prima della fine del periodo.';

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
  String get termsOfUse => 'Termini d\'uso (EULA)';

  @override
  String get lifetimeAccess => 'Accesso a vita';

  @override
  String get foundingMember => 'Membro fondatore';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'Questo piano non è disponibile al momento. Riprova più tardi.';

  @override
  String get purchaseFailed => 'Acquisto non riuscito';

  @override
  String get active => 'ATTIVO';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Riprova';

  @override
  String get settingsLanguage => 'Lingua';

  @override
  String get settingsSystemLanguage => 'Lingua di sistema';

  @override
  String get settingsLanguageSaveFailed =>
      'Impossibile salvare la lingua. Riprova.';
}

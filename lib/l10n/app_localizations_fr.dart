// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get watchNext => 'À regarder';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get homeRecordedToday => 'Vidéos filmées aujourd’hui';

  @override
  String get homePlays => 'Lectures';

  @override
  String get homeWatchActivity => 'Activité de visionnage';

  @override
  String get homeWatchStreak => 'Jours de visionnage consécutifs';

  @override
  String get homeMostWatched => 'Les plus regardées';

  @override
  String get homeTopFolders => 'Dossiers principaux';

  @override
  String get homeVideoRecap => 'Bilan vidéo';

  @override
  String get homeRecordedThisYear => 'Vidéos filmées cette année';

  @override
  String get homeNoWatchHistory =>
      'RollReel n’enregistre pas encore l’historique de visionnage.';

  @override
  String get homeFolderDetailsUnavailable =>
      'Les détails des dossiers sont indisponibles pour cette photothèque.';

  @override
  String get homeUnavailable => 'Indisponible';

  @override
  String get homeLoading => 'Chargement…';

  @override
  String get homeCameraRoll => 'Vos\nvidéos';

  @override
  String get homeWatchTab => 'Regarder';

  @override
  String get homeActivityTab => 'Activité';

  @override
  String get homeYourActivity => 'Votre activité';

  @override
  String get homeEmptyTitle => 'Votre première vidéo commence ici';

  @override
  String get homeEmptyBody =>
      'Filmez une vidéo. Vous la retrouverez ici à votre retour.';

  @override
  String get homeOpenCamera => 'Ouvrir l’appareil photo';

  @override
  String get homeCaptureFailed =>
      'RollReel n’a pas pu filmer ou enregistrer la vidéo.';

  @override
  String get homeAccessTitle => 'Choisissez vos vidéos';

  @override
  String get homeAccessBody =>
      'Autorisez l’accès à Photos dans Réglages pour regarder vos vidéos.';

  @override
  String get homeLoadFailed => 'Vos vidéos n’ont pas pu se charger';

  @override
  String get homeLoadFailedBody =>
      'Vos vidéos sont peut-être encore en cours de synchronisation. Réessayez.';

  @override
  String get homeNoMemories =>
      'Aucune vidéo à cette date les années précédentes.';

  @override
  String homePlayClip(String title) {
    return 'Lire $title';
  }

  @override
  String get homePlaybackFailed => 'Impossible de lire cette vidéo.';

  @override
  String get homePause => 'Mettre en pause';

  @override
  String get homePlay => 'Lire';

  @override
  String get onboardingTitle => 'Retrouvez votre\npellicule.';

  @override
  String get onboardingSwipeTitle => 'Balayez vers le haut\npour la suite.';

  @override
  String get onboardingSwipeSubtitle => 'Essayez sur l’aperçu ci-dessous.';

  @override
  String get onboardingTrySwipe => 'Essayer le geste';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Exemple $current sur $total';
  }

  @override
  String get onboardingNextSample => 'Afficher l’exemple suivant';

  @override
  String get onboardingLimitedTitle => 'Choisir des vidéos précises';

  @override
  String get onboardingLimitedBody =>
      'Sélectionnez dans le système les éléments accessibles à RollReel.';

  @override
  String get onboardingFullTitle => 'Autoriser toute la photothèque';

  @override
  String get onboardingFullBody =>
      'Parcourez toutes vos vidéos. Vous pouvez modifier l’accès dans Réglages.';

  @override
  String get onboardingChooseVideos => 'Choisir des vidéos';

  @override
  String get onboardingNotNow => 'Plus tard';

  @override
  String get onboardingSubtitle =>
      'Revoyez les petits moments que vous avez filmés, une vidéo à la fois.';

  @override
  String get onboardingPrivacyBody =>
      'Vos vidéos sont lues sur votre appareil. Aucun compte à créer ni photothèque à téléverser.';

  @override
  String get onboardingPermissionBody =>
      'Autorisez l’accès à votre photothèque pour que RollReel puisse trouver et lire vos vidéos.';

  @override
  String get onboardingAccessBody =>
      'RollReel accède à Photos pour afficher les vidéos de votre pellicule.';

  @override
  String get onboardingPermissionNote =>
      'Vous pouvez modifier l’accès à tout moment dans Réglages.';

  @override
  String get onboardingPermissionError =>
      'Impossible de demander l’accès. Réessayez ou ignorez cette étape.';

  @override
  String onboardingStep(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String get onboardingPrivacyTitle => 'Rien que pour vous.';

  @override
  String get onboardingPermissionTitle => 'Quelles vidéos\npouvons-nous lire ?';

  @override
  String get onboardingNoCloud => 'Sans cloud';

  @override
  String get onboardingNoAccount => 'Sans compte';

  @override
  String get onboardingNoTracking => 'Sans suivi';

  @override
  String get swipeHint => 'BALAYEZ';

  @override
  String get skip => 'Ignorer';

  @override
  String get getStarted => 'Commencer';

  @override
  String get continueLabel => 'Continuer';

  @override
  String get requesting => 'Demande en cours…';

  @override
  String get allowAccess => 'Autoriser l\'accès';

  @override
  String get noVideosYetTitle => 'Aucune vidéo pour l\'instant';

  @override
  String get noVideosYetBody =>
      'Les vidéos de votre pellicule apparaîtront ici.';

  @override
  String get openPhotosApp => 'Ouvrir l\'app Photos';

  @override
  String get loadingLibrary => 'Chargement de votre bibliothèque...';

  @override
  String get permissionDeniedTitle => 'L’accès à Photos\nest désactivé.';

  @override
  String get permissionDeniedBody =>
      'Choisissez vos vidéos dans Réglages quand vous voulez. Vous pouvez continuer à explorer RollReel.';

  @override
  String get openSettings => 'Ouvrir les Réglages';

  @override
  String get continueAnyway => 'Continuer quand même';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get yesterday => 'Hier';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Retour';

  @override
  String get remove => 'Retirer';

  @override
  String get manage => 'Gérer';

  @override
  String get videoFallbackTitle => 'Vidéo';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterToday => 'Aujourd\'hui';

  @override
  String get filterShorts => 'Courtes';

  @override
  String get filterLong => 'Longues';

  @override
  String get filterRecent => 'Récentes';

  @override
  String get videoDeleted => 'Vidéo supprimée';

  @override
  String get getInfo => 'Infos';

  @override
  String get addToVault => 'Ajouter au coffre';

  @override
  String get removeFromVault => 'Retirer du coffre';

  @override
  String get deleteVideo => 'Supprimer la vidéo';

  @override
  String get deleteVideoWarning =>
      'Cette vidéo sera définitivement supprimée de votre bibliothèque.';

  @override
  String get thisVideo => 'Cette vidéo';

  @override
  String get share => 'Partager';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Agrandir';

  @override
  String get photoLibraryAccess => 'Accès à la photothèque';

  @override
  String get limitedAccessMessage =>
      'Vous partagez actuellement une sélection limitée de vidéos.';

  @override
  String get selectMoreVideos => 'Sélectionner plus de vidéos';

  @override
  String get allowFullAccess => 'Autoriser l\'accès complet';

  @override
  String managingCount(int count) {
    return '$count de vos vidéos gérées';
  }

  @override
  String get infoDate => 'Date';

  @override
  String get infoDuration => 'Durée';

  @override
  String get infoResolution => 'Résolution';

  @override
  String get infoFileSize => 'Taille du fichier';

  @override
  String get infoFormat => 'Format';

  @override
  String get feed => 'Flux';

  @override
  String get library => 'Library';

  @override
  String get favoritesEmptyTitle => 'No Favorites Yet';

  @override
  String get favoritesEmptyBody =>
      'Tap the heart on any video to save it here.';

  @override
  String get goToLibrary => 'Go to Library';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'Rechercher des vidéos…';

  @override
  String get videosTitle => 'Vidéos';

  @override
  String videosCount(int count) {
    return '$count vidéos';
  }

  @override
  String get yourLibrary => 'Votre bibliothèque';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Local';

  @override
  String get noResults => 'Aucun résultat';

  @override
  String get noVideosFound => 'Aucune vidéo trouvée';

  @override
  String noSearchMatches(String query) {
    return 'Aucune vidéo ne correspond à « $query ».';
  }

  @override
  String get tryDifferentFilter => 'Essayez un autre filtre.';

  @override
  String get clearSearch => 'Effacer la recherche';

  @override
  String get clearFilters => 'Effacer les filtres';

  @override
  String get filter => 'Filtrer';

  @override
  String get reset => 'Réinitialiser';

  @override
  String get timePeriod => 'PÉRIODE';

  @override
  String get thisWeek => 'Cette semaine';

  @override
  String get thisMonth => 'Ce mois-ci';

  @override
  String get duration => 'DURÉE';

  @override
  String get any => 'Toutes';

  @override
  String get durationShort => '< 1 min';

  @override
  String get durationMedium => '1–5 min';

  @override
  String get durationLong => '> 5 min';

  @override
  String get sortBy => 'TRIER PAR';

  @override
  String get newestFirst => 'Plus récentes d\'abord';

  @override
  String get oldestFirst => 'Plus anciennes d\'abord';

  @override
  String get shortestFirst => 'Plus courtes d\'abord';

  @override
  String get longestFirst => 'Plus longues d\'abord';

  @override
  String get applyFilters => 'Appliquer les filtres';

  @override
  String get onThisDay => 'Ce jour-là';

  @override
  String onThisDaySubtitleOne(String years) {
    return '1 souvenir d\'$years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '$count souvenirs des années passées';
  }

  @override
  String get yearsAgoOne => 'il y a 1 an';

  @override
  String yearsAgoMany(int years) {
    return 'il y a $years ans';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'Ce jour-là · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current sur $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'Impossible de charger les souvenirs : $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'Impossible de charger les vidéos : $error';
  }

  @override
  String get settings => 'Réglages';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get playbackSection => 'LECTURE';

  @override
  String get loopShortVideos => 'Lire en boucle les vidéos courtes';

  @override
  String get loopShortVideosSub => 'Automatically loop to the next video';

  @override
  String get autoPlayOnLaunch => 'Lecture auto au lancement';

  @override
  String get autoPlayOnLaunchSub => 'Start playing videos automatically';

  @override
  String get defaultFilter => 'Filtre par défaut';

  @override
  String get defaultFilterSub => 'Set your default video filter';

  @override
  String get appearanceSection => 'APPARENCE';

  @override
  String get darkMode => 'Mode sombre';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Afficher les dates';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Afficher les durées';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'CONFIDENTIALITÉ';

  @override
  String get privacyVault => 'Coffre privé';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'À PROPOS';

  @override
  String get privacyPolicy => 'Politique de confidentialité';

  @override
  String get privacyPolicyBody =>
      'RollReel n\'envoie, ne transmet ni ne stocke aucune de vos vidéos en dehors de votre appareil. Aucun compte n\'est requis. Aucune donnée personnelle n\'est partagée avec des tiers.';

  @override
  String get rateApp => 'Noter RollReel';

  @override
  String get shareApp => 'Partager RollReel';

  @override
  String get version => 'Version';

  @override
  String get proCardSubtitle => 'Sans pub · Coffre · Vitesse · Collections';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'Découvrez RollReel – faites défiler les vidéos de votre pellicule, 100 % hors ligne !';

  @override
  String get vaultTitle => 'Coffre privé';

  @override
  String get vaultLocked => 'Coffre verrouillé';

  @override
  String get vaultLockedSubtitle => 'Vos vidéos privées sont en sécurité ici';

  @override
  String get unlockWithFaceId => 'Déverrouiller avec Face ID';

  @override
  String get unlockVaultReason => 'Déverrouillez votre coffre privé';

  @override
  String get faceIdUnavailable =>
      'Face ID n\'est pas disponible sur cet appareil.';

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
  String get authFailed => 'Échec de l\'authentification. Veuillez réessayer.';

  @override
  String get vaultLoadFailed => 'Impossible de charger le coffre';

  @override
  String get vaultEmpty => 'Le coffre est vide';

  @override
  String get vaultEmptyHint => 'Touchez ••• sur une vidéo pour l\'ajouter ici';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'Retirer du coffre ?';

  @override
  String get removeFromVaultBody =>
      'Cette vidéo reviendra dans votre bibliothèque principale.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallTagline => 'Regardez plus. Sans souci.';

  @override
  String get featureAdFree => 'Expérience sans publicité';

  @override
  String get featureAdFreeSub => 'Aucune interruption, jamais';

  @override
  String get featureVault => 'Coffre privé';

  @override
  String get featureVaultSub => 'Verrouillez vos vidéos sensibles avec Face ID';

  @override
  String get featureSpeed => 'Contrôle de la vitesse de lecture';

  @override
  String get featureSpeedSub => 'Avance rapide 2× par appui long';

  @override
  String get featureOnThisDay => 'Ce jour-là';

  @override
  String get featureOnThisDaySub => 'Revivez les vidéos des années passées';

  @override
  String get unlockPro => 'Débloquer RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'Vous êtes Pro !';

  @override
  String get lifetimeFooter => 'Achat unique · Sans abonnement';

  @override
  String get monthlyFooter =>
      'Renouvellement mensuel auto · Annulable à tout moment';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String get subscriptionDisclaimer =>
      'Paiement débité sur votre identifiant Apple. L\'abonnement se renouvelle automatiquement sauf annulation 24 h avant la fin de la période.';

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
  String get termsOfUse => 'Conditions d\'utilisation (CLUF)';

  @override
  String get lifetimeAccess => 'Accès à vie';

  @override
  String get foundingMember => 'Membre fondateur';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'Cette formule n\'est pas disponible pour le moment. Veuillez réessayer plus tard.';

  @override
  String get purchaseFailed => 'Échec de l\'achat';

  @override
  String get active => 'ACTIF';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Réessayer';
}

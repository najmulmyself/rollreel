// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get watchNext => 'Watch next';

  @override
  String get seeAll => 'See all';

  @override
  String get homeRecordedToday => 'Recorded today';

  @override
  String get homePlays => 'Plays';

  @override
  String get homeWatchActivity => 'Watch activity';

  @override
  String get homeWatchStreak => 'Watch streak';

  @override
  String get homeMostWatched => 'Most Watched';

  @override
  String get homeTopFolders => 'Top folders';

  @override
  String get homeVideoRecap => 'Year in review';

  @override
  String get homeRecordedThisYear => 'Recorded this year';

  @override
  String get homeNoWatchHistory =>
      'RollReel doesn’t track plays, watch streaks, or most-watched videos.';

  @override
  String get homeFolderDetailsUnavailable =>
      'Folder details aren’t available for this library.';

  @override
  String get homeUnavailable => 'Unavailable';

  @override
  String get homeLoading => 'Loading…';

  @override
  String get homeCameraRoll => 'Your\ncamera roll.';

  @override
  String get homeWatchTab => 'Watch';

  @override
  String get homeActivityTab => 'Activity';

  @override
  String get homeYourActivity => 'Your activity';

  @override
  String get homeEmptyTitle => 'Your first reel starts here';

  @override
  String get homeEmptyBody =>
      'Record a video with your camera. It’ll be here when you come back.';

  @override
  String get homeOpenCamera => 'Open Camera';

  @override
  String get homeCaptureFailed => 'RollReel couldn’t record or save the video.';

  @override
  String get homeAccessTitle => 'Choose your videos';

  @override
  String get homeAccessBody =>
      'Allow Photos access in Settings to watch videos from your camera roll.';

  @override
  String get homeLoadFailed => 'Your videos couldn’t load';

  @override
  String get homeLoadFailedBody =>
      'Your camera roll may still be syncing. Give it another try.';

  @override
  String get homeNoMemories => 'No videos from this date in past years.';

  @override
  String homePlayClip(String title) {
    return 'Play $title';
  }

  @override
  String get homePlaybackFailed => 'This video couldn’t play.';

  @override
  String get homePause => 'Pause';

  @override
  String get homePlay => 'Play';

  @override
  String get onboardingTitle => 'Back to your\ncamera roll.';

  @override
  String favoritesSavedCount(int count) {
    return '$count saved';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return 'Remove $title from Favorites';
  }

  @override
  String get favoritesRemoved => 'Removed from Favorites';

  @override
  String get favoritesUndo => 'Undo';

  @override
  String get favoritesLoadFailed => 'Favorites couldn’t load';

  @override
  String get favoritesRetryBody => 'Try fetching your saved videos again.';

  @override
  String get favoritesAccessBody =>
      'Allow Photos access to see your saved videos.';

  @override
  String get favoritesUpdateFailed => 'Couldn’t update Favorites.';

  @override
  String get onboardingSwipeTitle => 'Swipe up for\nthe next video.';

  @override
  String get onboardingSwipeSubtitle => 'Try it on the preview below.';

  @override
  String get onboardingTrySwipe => 'Try a swipe';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Sample clip $current of $total';
  }

  @override
  String get onboardingNextSample => 'Show next sample clip';

  @override
  String get onboardingLimitedTitle => 'Pick specific videos';

  @override
  String get onboardingLimitedBody =>
      'Choose the items RollReel can see in the system picker.';

  @override
  String get onboardingFullTitle => 'Allow your whole library';

  @override
  String get onboardingFullBody =>
      'Browse all your camera-roll videos. You can change access in Settings.';

  @override
  String get onboardingChooseVideos => 'Choose videos';

  @override
  String get onboardingNotNow => 'Not Now';

  @override
  String get onboardingSubtitle =>
      'Watch the little moments you filmed, one video at a time.';

  @override
  String get onboardingPrivacyBody =>
      'Your own videos play on your device. There’s no account to create or library to upload.';

  @override
  String get onboardingPermissionBody =>
      'Allow photo library access so RollReel can find and play your videos.';

  @override
  String get onboardingAccessBody =>
      'RollReel uses Photos access to show videos from your camera roll.';

  @override
  String get onboardingPermissionNote =>
      'You can change access anytime in Settings.';

  @override
  String get onboardingPermissionError =>
      'Couldn’t request access. Try again or skip for now.';

  @override
  String onboardingStep(int step, int total) {
    return 'Step $step of $total';
  }

  @override
  String get onboardingPrivacyTitle => 'For your eyes only.';

  @override
  String get onboardingPermissionTitle => 'Which videos\ncan we play?';

  @override
  String get onboardingNoCloud => 'No Cloud';

  @override
  String get onboardingNoAccount => 'No Account';

  @override
  String get onboardingNoTracking => 'No Tracking';

  @override
  String get swipeHint => 'SWIPE';

  @override
  String get skip => 'Skip';

  @override
  String get getStarted => 'Get Started';

  @override
  String get continueLabel => 'Continue';

  @override
  String get requesting => 'Requesting…';

  @override
  String get allowAccess => 'Allow Access';

  @override
  String get noVideosYetTitle => 'No Videos Yet';

  @override
  String get noVideosYetBody => 'Your camera roll videos will appear here.';

  @override
  String get openPhotosApp => 'Open Photos App';

  @override
  String get loadingLibrary => 'Loading your library...';

  @override
  String get permissionDeniedTitle => 'Photos access\nis off.';

  @override
  String get permissionDeniedBody =>
      'Choose videos in Settings when you’re ready. You can still explore RollReel.';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get continueAnyway => 'Continue Anyway';

  @override
  String get today => 'Today';

  @override
  String get yesterday => 'Yesterday';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Back';

  @override
  String get remove => 'Remove';

  @override
  String get manage => 'Manage';

  @override
  String get videoFallbackTitle => 'Video';

  @override
  String get filterAll => 'All';

  @override
  String get filterToday => 'Today';

  @override
  String get filterShorts => 'Shorts';

  @override
  String get filterLong => 'Long';

  @override
  String get filterRecent => 'Recent';

  @override
  String get videoDeleted => 'Video deleted';

  @override
  String get getInfo => 'Get Info';

  @override
  String get addToVault => 'Add to Vault';

  @override
  String get removeFromVault => 'Remove from Vault';

  @override
  String get deleteVideo => 'Delete Video';

  @override
  String get deleteVideoWarning =>
      'This will permanently delete the video from your library.';

  @override
  String get thisVideo => 'This video';

  @override
  String get share => 'Share';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Expand';

  @override
  String get photoLibraryAccess => 'Photo Library Access';

  @override
  String get limitedAccessMessage =>
      'You\'re currently sharing a limited selection of videos.';

  @override
  String get selectMoreVideos => 'Select More Videos';

  @override
  String get allowFullAccess => 'Allow Full Access';

  @override
  String managingCount(int count) {
    return 'Managing $count of your videos';
  }

  @override
  String get infoDate => 'Date';

  @override
  String get infoDuration => 'Duration';

  @override
  String get infoResolution => 'Resolution';

  @override
  String get infoFileSize => 'File Size';

  @override
  String get infoFormat => 'Format';

  @override
  String get feed => 'Feed';

  @override
  String get library => 'Library';

  @override
  String get libraryFilters => 'Filters';

  @override
  String get libraryClose => 'Close';

  @override
  String get libraryEmptyTitle => 'No videos yet';

  @override
  String get libraryAccessOff => 'Photos access is off';

  @override
  String get libraryNoMatches => 'No matching videos';

  @override
  String get librarySearchHelp => 'Try a different title or clear your search.';

  @override
  String get libraryNoFilterMatches => 'No videos match these filters';

  @override
  String get libraryFilterHelp =>
      'Clear the filters to see all of your videos.';

  @override
  String get libraryUnknownDate => 'Date unknown';

  @override
  String get libraryDeleteFailed => 'RollReel couldn’t delete the video.';

  @override
  String libraryDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos',
      one: '1 video',
    );
    return '$_temp0 on this device';
  }

  @override
  String libraryMemoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count videos',
      one: '1 video',
    );
    return '$_temp0 from past years';
  }

  @override
  String libraryVideoOptions(String title) {
    return 'Options for $title';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => 'No favorites yet';

  @override
  String get favoritesEmptyBody =>
      'Tap the heart while watching a video to save it here.';

  @override
  String get goToLibrary => 'Browse Library';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'Search videos…';

  @override
  String get videosTitle => 'Videos';

  @override
  String videosCount(int count) {
    return '$count Videos';
  }

  @override
  String get yourLibrary => 'Your Library';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Local';

  @override
  String get noResults => 'No Results';

  @override
  String get noVideosFound => 'No Videos Found';

  @override
  String noSearchMatches(String query) {
    return 'No videos match \"$query\".';
  }

  @override
  String get tryDifferentFilter => 'Try a different filter.';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get filter => 'Filter';

  @override
  String get reset => 'Reset';

  @override
  String get timePeriod => 'Time period';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get duration => 'Duration';

  @override
  String get any => 'Any';

  @override
  String get durationShort => 'Under 1 min';

  @override
  String get durationMedium => '1–5 min';

  @override
  String get durationLong => 'Over 5 min';

  @override
  String get sortBy => 'Sort by';

  @override
  String get newestFirst => 'Newest First';

  @override
  String get oldestFirst => 'Oldest First';

  @override
  String get shortestFirst => 'Shortest First';

  @override
  String get longestFirst => 'Longest First';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get onThisDay => 'On This Day';

  @override
  String onThisDaySubtitleOne(String years) {
    return '1 memory from $years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '$count memories from past years';
  }

  @override
  String get yearsAgoOne => '1 year ago';

  @override
  String yearsAgoMany(int years) {
    return '$years years ago';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'On This Day · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current of $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'Could not load memories: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'Could not load videos: $error';
  }

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get playbackSection => 'PLAYBACK';

  @override
  String get loopShortVideos => 'Loop Short Videos';

  @override
  String get loopShortVideosSub => 'Automatically loop to the next video';

  @override
  String get autoPlayOnLaunch => 'Auto-play on Launch';

  @override
  String get autoPlayOnLaunchSub => 'Start playing videos automatically';

  @override
  String get defaultFilter => 'Default Filter';

  @override
  String get defaultFilterSub => 'Set your default video filter';

  @override
  String get appearanceSection => 'APPEARANCE';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Show Date Labels';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Show Duration Badges';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'PRIVACY';

  @override
  String get privacyVault => 'Privacy Vault';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'ABOUT';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get privacyPolicyBody =>
      'RollReel does not upload, transmit, or store any of your videos outside your device. No account is required. No personal data is shared with third parties.';

  @override
  String get rateApp => 'Rate RollReel';

  @override
  String get shareApp => 'Share RollReel';

  @override
  String get version => 'Version';

  @override
  String get proCardSubtitle => 'Ad-free · Vault · Speed · Collections';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'Check out RollReel – swipe through your camera roll videos, 100% offline!';

  @override
  String get vaultTitle => 'Private Vault';

  @override
  String get vaultLocked => 'Vault Locked';

  @override
  String get vaultLockedSubtitle =>
      'Your private videos are safely locked and only you can access them.';

  @override
  String get unlockWithFaceId => 'Unlock with Face ID';

  @override
  String get unlockVaultReason => 'Unlock your Private Vault';

  @override
  String get faceIdUnavailable => 'Face ID is not available on this device.';

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
  String get authFailed => 'Authentication failed. Please try again.';

  @override
  String get vaultLoadFailed => 'Failed to load vault';

  @override
  String get vaultEmpty => 'Vault is empty';

  @override
  String get vaultEmptyHint => 'Tap ••• on any video to add it here';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'Remove from Vault?';

  @override
  String get removeFromVaultBody =>
      'This video will return to your main library.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallTagline => 'Watch more. Worry less.';

  @override
  String get featureAdFree => 'Ad-Free Experience';

  @override
  String get featureAdFreeSub => 'No interruptions, ever';

  @override
  String get featureVault => 'Privacy Vault';

  @override
  String get featureVaultSub => 'Lock sensitive videos with Face ID';

  @override
  String get featureSpeed => 'Playback Speed Control';

  @override
  String get featureSpeedSub => '2× fast-forward on long-press';

  @override
  String get featureOnThisDay => 'On This Day';

  @override
  String get featureOnThisDaySub => 'Relive videos from past years';

  @override
  String get unlockPro => 'Unlock RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'You\'re Pro!';

  @override
  String get lifetimeFooter =>
      'One-time purchase · No subscription · Forever yours';

  @override
  String get monthlyFooter => 'Auto-renews monthly · Cancel anytime';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get subscriptionDisclaimer =>
      'Payment charged to Apple ID. Subscription auto-renews unless cancelled 24h before period ends.';

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
  String get termsOfUse => 'Terms of Use (EULA)';

  @override
  String get lifetimeAccess => 'Lifetime Access';

  @override
  String get foundingMember => 'Founding member';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'This plan isn\'t available right now. Please try again later.';

  @override
  String get purchaseFailed => 'Purchase failed';

  @override
  String get active => 'ACTIVE';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Retry';
}

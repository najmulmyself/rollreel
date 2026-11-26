// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get watchNext => 'आगे देखें';

  @override
  String get seeAll => 'सभी देखें';

  @override
  String get homeRecordedToday => 'आज रिकॉर्ड किए गए वीडियो';

  @override
  String get homePlays => 'प्ले';

  @override
  String get homeWatchActivity => 'देखने की गतिविधि';

  @override
  String get homeWatchStreak => 'लगातार देखने के दिन';

  @override
  String get homeMostWatched => 'सबसे ज़्यादा देखे गए';

  @override
  String get homeTopFolders => 'प्रमुख फ़ोल्डर';

  @override
  String get homeVideoRecap => 'वीडियो का सारांश';

  @override
  String get homeRecordedThisYear => 'इस साल रिकॉर्ड किए गए वीडियो';

  @override
  String get homeWatchedToday => 'आज देखे गए वीडियो';

  @override
  String get homeTopAlbums => 'प्रमुख एल्बम';

  @override
  String get playerGuideSwipe => 'ऊपर स्वाइप करें';

  @override
  String get playerGuideSwipeBody => 'अपनी लाइब्रेरी का अगला वीडियो देखें।';

  @override
  String get playerGuideTap => 'चलाने या रोकने के लिए टैप करें';

  @override
  String get playerGuideTapBody =>
      'वीडियो रोकने के लिए एक बार टैप करें। फिर से चलाने के लिए दोबारा टैप करें।';

  @override
  String get playerGuideSeek => 'आगे या पीछे जाने के लिए दो बार टैप करें';

  @override
  String get playerGuideSeekBody =>
      '10 सेकंड पीछे जाने के लिए बाईं ओर या 10 सेकंड आगे जाने के लिए दाईं ओर दो बार टैप करें।';

  @override
  String get playerGuideEdges => 'किनारों पर उंगली खिसकाएँ';

  @override
  String get playerGuideEdgesBody =>
      'चमक के लिए बाएँ किनारे पर और आवाज़ के लिए दाएँ किनारे पर ऊपर या नीचे स्वाइप करें।';

  @override
  String get playerGuideDone => 'समझ गया';

  @override
  String get homeNoWatchHistory =>
      'अपना इतिहास शुरू करने के लिए कोई वीडियो देखें।';

  @override
  String get homeNoVideoAlbums => 'वीडियो वाले एल्बम यहाँ दिखेंगे।';

  @override
  String get homeNoVideoFolders => 'वीडियो वाले फ़ोल्डर यहाँ दिखेंगे।';

  @override
  String get homeLimitedVideoCollections =>
      'सीमित पहुँच के कारण कुछ एल्बम या फ़ोल्डर नहीं दिख सकते।';

  @override
  String homeWatchDays(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString दिन';
  }

  @override
  String homePlayCount(int count) {
    final intl.NumberFormat countNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String countString = countNumberFormat.format(count);

    return '$countString बार चलाया गया';
  }

  @override
  String get homeUnavailable => 'उपलब्ध नहीं';

  @override
  String get homeLoading => 'लोड हो रहा है…';

  @override
  String get homeCameraRoll => 'आपके\nवीडियो';

  @override
  String get homeWatchTab => 'देखें';

  @override
  String get homeActivityTab => 'गतिविधि';

  @override
  String get homeYourActivity => 'आपकी गतिविधि';

  @override
  String get homeAccessTitle => 'अपने वीडियो चुनें';

  @override
  String get homeAccessBody =>
      'अपने वीडियो देखने के लिए सेटिंग्स में फ़ोटो का ऐक्सेस दें।';

  @override
  String get homeLoadFailed => 'आपके वीडियो लोड नहीं हुए';

  @override
  String get homeLoadFailedBody =>
      'हो सकता है कि आपकी लाइब्रेरी अभी सिंक हो रही हो। फिर से कोशिश करें।';

  @override
  String get homeNoMemories =>
      'पिछले सालों में इस तारीख का कोई वीडियो नहीं है।';

  @override
  String homePlayClip(String title) {
    return '$title चलाएँ';
  }

  @override
  String get homePlaybackFailed => 'यह वीडियो नहीं चल सका।';

  @override
  String get homePause => 'रोकें';

  @override
  String get homePlay => 'चलाएँ';

  @override
  String get onboardingTitle => 'अपने कैमरा रोल\nपर लौटें।';

  @override
  String favoritesSavedCount(int count) {
    return '$count सेव किए गए';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return 'पसंदीदा से $title हटाएँ';
  }

  @override
  String get favoritesRemoved => 'पसंदीदा से हटाया गया';

  @override
  String get favoritesUndo => 'पहले जैसा करें';

  @override
  String get favoritesLoadFailed => 'पसंदीदा वीडियो लोड नहीं हो सके';

  @override
  String get favoritesRetryBody => 'अपने सेव किए गए वीडियो फिर से लोड करें।';

  @override
  String get favoritesAccessBody =>
      'सेव किए गए वीडियो देखने के लिए फ़ोटो का ऐक्सेस दें।';

  @override
  String get favoritesUpdateFailed => 'पसंदीदा अपडेट नहीं हो सके।';

  @override
  String get onboardingSwipeTitle => 'अगले वीडियो के लिए\nऊपर स्वाइप करें।';

  @override
  String get onboardingSwipeSubtitle => 'नीचे दिए प्रीव्यू पर आज़माएँ।';

  @override
  String get onboardingTrySwipe => 'स्वाइप आज़माएँ';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'नमूना वीडियो $current / $total';
  }

  @override
  String get onboardingNextSample => 'अगला नमूना वीडियो दिखाएँ';

  @override
  String get onboardingLimitedTitle => 'कुछ वीडियो चुनें';

  @override
  String get onboardingLimitedBody =>
      'सिस्टम के पिकर में चुनें कि RollReel किन फ़ाइलों को देख सकता है।';

  @override
  String get onboardingFullTitle => 'पूरी लाइब्रेरी की अनुमति दें';

  @override
  String get onboardingFullBody =>
      'अपने सभी वीडियो देखें। सेटिंग्स में अनुमति बदल सकते हैं।';

  @override
  String get onboardingChooseVideos => 'वीडियो चुनें';

  @override
  String get onboardingNotNow => 'अभी नहीं';

  @override
  String get onboardingSubtitle =>
      'रिकॉर्ड किए छोटे-छोटे पलों को फिर देखें, एक बार में एक वीडियो।';

  @override
  String get onboardingPrivacyBody =>
      'आपके वीडियो आपके डिवाइस पर चलते हैं। खाता बनाने या लाइब्रेरी अपलोड करने की ज़रूरत नहीं है।';

  @override
  String get onboardingPermissionBody =>
      'फ़ोटो लाइब्रेरी का ऐक्सेस दें ताकि RollReel आपके वीडियो ढूँढ़कर चला सके।';

  @override
  String get onboardingAccessBody =>
      'RollReel कैमरा रोल के वीडियो दिखाने के लिए फ़ोटो की अनुमति का उपयोग करता है।';

  @override
  String get onboardingPermissionNote =>
      'आप सेटिंग में कभी भी ऐक्सेस बदल सकते हैं।';

  @override
  String get onboardingPermissionError =>
      'ऐक्सेस का अनुरोध नहीं हो सका। फिर कोशिश करें या अभी छोड़ दें।';

  @override
  String onboardingStep(int step, int total) {
    return 'चरण $step / $total';
  }

  @override
  String get onboardingPrivacyTitle => 'सिर्फ़ आपके लिए।';

  @override
  String get onboardingPermissionTitle => 'हम कौन से वीडियो\nचला सकते हैं?';

  @override
  String get onboardingNoCloud => 'क्लाउड नहीं';

  @override
  String get onboardingNoAccount => 'अकाउंट नहीं';

  @override
  String get onboardingNoTracking => 'ट्रैकिंग नहीं';

  @override
  String get swipeHint => 'स्वाइप करें';

  @override
  String get skip => 'छोड़ें';

  @override
  String get getStarted => 'शुरू करें';

  @override
  String get continueLabel => 'जारी रखें';

  @override
  String get requesting => 'अनुरोध जारी…';

  @override
  String get allowAccess => 'एक्सेस दें';

  @override
  String get noVideosYetTitle => 'अभी कोई वीडियो नहीं';

  @override
  String get noVideosYetBody => 'आपके कैमरा रोल के वीडियो यहाँ दिखेंगे।';

  @override
  String get openPhotosApp => 'फ़ोटो ऐप खोलें';

  @override
  String get loadingLibrary => 'आपकी लाइब्रेरी लोड हो रही है...';

  @override
  String get permissionDeniedTitle => 'फ़ोटो की\nअनुमति बंद है।';

  @override
  String get permissionDeniedBody =>
      'तैयार होने पर सेटिंग्स में वीडियो चुनें। आप अभी भी RollReel देख सकते हैं।';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get continueAnyway => 'फिर भी जारी रखें';

  @override
  String get today => 'आज';

  @override
  String get yesterday => 'कल';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get ok => 'ठीक है';

  @override
  String get back => 'वापस';

  @override
  String get remove => 'हटाएँ';

  @override
  String get manage => 'प्रबंधित करें';

  @override
  String get videoFallbackTitle => 'वीडियो';

  @override
  String get filterAll => 'सभी';

  @override
  String get filterToday => 'आज';

  @override
  String get filterShorts => 'छोटे';

  @override
  String get filterLong => 'लंबे';

  @override
  String get filterRecent => 'हाल के';

  @override
  String get videoDeleted => 'वीडियो हटाया गया';

  @override
  String get getInfo => 'जानकारी देखें';

  @override
  String get addToVault => 'वॉल्ट में जोड़ें';

  @override
  String get removeFromVault => 'वॉल्ट से हटाएँ';

  @override
  String get deleteVideo => 'वीडियो हटाएँ';

  @override
  String get deleteVideoWarning =>
      'यह वीडियो आपकी लाइब्रेरी से हमेशा के लिए हट जाएगा।';

  @override
  String get thisVideo => 'यह वीडियो';

  @override
  String get share => 'शेयर करें';

  @override
  String get like => 'Like';

  @override
  String get expand => 'बड़ा करें';

  @override
  String get photoLibraryAccess => 'फ़ोटो लाइब्रेरी एक्सेस';

  @override
  String get limitedAccessMessage => 'आप अभी सीमित वीडियो ही साझा कर रहे हैं।';

  @override
  String get selectMoreVideos => 'और वीडियो चुनें';

  @override
  String get allowFullAccess => 'पूर्ण एक्सेस दें';

  @override
  String managingCount(int count) {
    return 'आपके $count वीडियो प्रबंधित हो रहे हैं';
  }

  @override
  String get infoDate => 'तारीख़';

  @override
  String get infoDuration => 'अवधि';

  @override
  String get infoResolution => 'रिज़ॉल्यूशन';

  @override
  String get infoFileSize => 'फ़ाइल आकार';

  @override
  String get infoFormat => 'फ़ॉर्मैट';

  @override
  String get feed => 'फ़ीड';

  @override
  String get library => 'लाइब्रेरी';

  @override
  String get libraryFilters => 'फ़िल्टर';

  @override
  String get libraryClose => 'बंद करें';

  @override
  String get libraryEmptyTitle => 'अभी कोई वीडियो नहीं है';

  @override
  String get libraryAccessOff => 'फ़ोटो की अनुमति बंद है';

  @override
  String get libraryNoMatches => 'कोई मिलता-जुलता वीडियो नहीं मिला';

  @override
  String get librarySearchHelp => 'दूसरा शीर्षक आज़माएँ या खोज साफ़ करें।';

  @override
  String get libraryNoFilterMatches => 'इन फ़िल्टर से कोई वीडियो नहीं मिला';

  @override
  String get libraryFilterHelp => 'सभी वीडियो देखने के लिए फ़िल्टर साफ़ करें।';

  @override
  String get libraryUnknownDate => 'तारीख अज्ञात है';

  @override
  String get libraryDeleteFailed => 'RollReel वीडियो नहीं मिटा पाया।';

  @override
  String libraryDeviceCount(int count) {
    return 'इस डिवाइस पर $count वीडियो';
  }

  @override
  String libraryMemoriesCount(int count) {
    return 'पिछले सालों के $count वीडियो';
  }

  @override
  String libraryVideoOptions(String title) {
    return '$title के विकल्प';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => 'अभी कोई पसंदीदा वीडियो नहीं है';

  @override
  String get favoritesEmptyBody =>
      'वीडियो देखते समय दिल पर टैप करें ताकि वह यहाँ सेव हो जाए।';

  @override
  String get goToLibrary => 'लाइब्रेरी देखें';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'वीडियो खोजें…';

  @override
  String get videosTitle => 'वीडियो';

  @override
  String videosCount(int count) {
    return '$count वीडियो';
  }

  @override
  String get yourLibrary => 'आपकी लाइब्रेरी';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'लोकल';

  @override
  String get noResults => 'कोई परिणाम नहीं';

  @override
  String get noVideosFound => 'कोई वीडियो नहीं मिला';

  @override
  String noSearchMatches(String query) {
    return '\"$query\" से मेल खाता कोई वीडियो नहीं।';
  }

  @override
  String get tryDifferentFilter => 'कोई दूसरा फ़िल्टर आज़माएँ।';

  @override
  String get clearSearch => 'खोज साफ़ करें';

  @override
  String get clearFilters => 'फ़िल्टर साफ़ करें';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get reset => 'रीसेट';

  @override
  String get timePeriod => 'समय अवधि';

  @override
  String get thisWeek => 'इस सप्ताह';

  @override
  String get thisMonth => 'इस महीने';

  @override
  String get duration => 'अवधि';

  @override
  String get any => 'कोई भी';

  @override
  String get durationShort => '< 1 मिनट';

  @override
  String get durationMedium => '1–5 मिनट';

  @override
  String get durationLong => '> 5 मिनट';

  @override
  String get sortBy => 'क्रमबद्ध करें';

  @override
  String get newestFirst => 'सबसे नए पहले';

  @override
  String get oldestFirst => 'सबसे पुराने पहले';

  @override
  String get shortestFirst => 'सबसे छोटे पहले';

  @override
  String get longestFirst => 'सबसे लंबे पहले';

  @override
  String get applyFilters => 'फ़िल्टर लागू करें';

  @override
  String get onThisDay => 'आज के दिन';

  @override
  String onThisDaySubtitleOne(String years) {
    return '$years की 1 याद';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return 'बीते वर्षों की $count यादें';
  }

  @override
  String get yearsAgoOne => '1 साल पहले';

  @override
  String yearsAgoMany(int years) {
    return '$years साल पहले';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'आज के दिन · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$total में से $current';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'यादें लोड नहीं हो सकीं: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'वीडियो लोड नहीं हो सके: $error';
  }

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'पसंदीदा';

  @override
  String get playbackSection => 'प्लेबैक';

  @override
  String get loopShortVideos => 'छोटे वीडियो लूप करें';

  @override
  String get loopShortVideosSub => '30 सेकंड से छोटी क्लिप दोबारा चलाएँ';

  @override
  String get autoPlayOnLaunch => 'खुलते ही ऑटो-प्ले';

  @override
  String get autoPlayOnLaunchSub => 'फ़ीड खोलते ही वीडियो चलाएँ';

  @override
  String get defaultFilter => 'डिफ़ॉल्ट फ़िल्टर';

  @override
  String get defaultFilterSub => 'चुनें कि फ़ीड में क्या दिखे';

  @override
  String get appearanceSection => 'दिखावट';

  @override
  String get darkMode => 'डार्क मोड';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'तारीख़ लेबल दिखाएँ';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'अवधि बैज दिखाएँ';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'गोपनीयता';

  @override
  String get privacyVault => 'प्राइवेसी वॉल्ट';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'जानकारी';

  @override
  String get privacyPolicy => 'गोपनीयता नीति';

  @override
  String get privacyPolicyBody =>
      'RollReel आपके वीडियो आपके डिवाइस के बाहर अपलोड, प्रसारित या संग्रहीत नहीं करता। किसी अकाउंट की ज़रूरत नहीं। कोई निजी डेटा तीसरे पक्ष से साझा नहीं किया जाता।';

  @override
  String get rateApp => 'RollReel को रेट करें';

  @override
  String get shareApp => 'RollReel शेयर करें';

  @override
  String get version => 'संस्करण';

  @override
  String get settingsFilterDescription =>
      'चुनें कि फ़ीड खोलने पर कौन से वीडियो दिखें।';

  @override
  String get settingsProDescription =>
      'बिना विज्ञापन के वीडियो और प्राइवेसी वॉल्ट';

  @override
  String get settingsProActive => 'Pro चालू है';

  @override
  String get settingsVaultDescription => 'अपने निजी वीडियो खोलें';

  @override
  String get settingsRestoreComplete => 'पिछली खरीदारी की जाँच पूरी हुई।';

  @override
  String get settingsRestoreFailed =>
      'खरीदारी बहाल नहीं हो सकी। फिर से कोशिश करें।';

  @override
  String get proCardSubtitle => 'विज्ञापन-मुक्त · वॉल्ट · स्पीड · कलेक्शन';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'RollReel देखें – अपने कैमरा रोल के वीडियो स्वाइप करें, 100% ऑफ़लाइन!';

  @override
  String get vaultTitle => 'प्राइवेट वॉल्ट';

  @override
  String get vaultLocked => 'वॉल्ट लॉक है';

  @override
  String get vaultLockedSubtitle => 'आपके निजी वीडियो यहाँ सुरक्षित हैं';

  @override
  String get unlockWithFaceId => 'Face ID से अनलॉक करें';

  @override
  String get unlockVaultReason => 'अपना प्राइवेट वॉल्ट अनलॉक करें';

  @override
  String get faceIdUnavailable => 'इस डिवाइस पर Face ID उपलब्ध नहीं है।';

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
  String get authFailed => 'प्रमाणीकरण विफल। कृपया फिर से कोशिश करें।';

  @override
  String get vaultLoadFailed => 'वॉल्ट लोड नहीं हो सका';

  @override
  String get vaultEmpty => 'वॉल्ट खाली है';

  @override
  String get vaultEmptyHint => 'किसी वीडियो पर ••• दबाकर यहाँ जोड़ें';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'वॉल्ट से हटाएँ?';

  @override
  String get removeFromVaultBody =>
      'यह वीडियो आपकी मुख्य लाइब्रेरी में वापस चला जाएगा।';

  @override
  String get vaultRecoveryLocked =>
      'अपने वीडियो लाइब्रेरी में वापस लाने के लिए वॉल्ट अनलॉक करें।';

  @override
  String get vaultReturnAll => 'वीडियो लाइब्रेरी में वापस लाएँ';

  @override
  String get vaultRecoveryBody =>
      'आप वॉल्ट के वीडियो कभी भी लाइब्रेरी में वापस ला सकते हैं।';

  @override
  String get vaultRecoveryConfirm =>
      'वॉल्ट के सभी वीडियो आपकी RollReel लाइब्रेरी में फिर दिखेंगे।';

  @override
  String get vaultRecoveryDone => 'वीडियो लाइब्रेरी में वापस आ गए हैं।';

  @override
  String get vaultUpdateFailed => 'वॉल्ट अपडेट नहीं हो सका। फिर से कोशिश करें।';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallPlaybackTitle => 'देखते रहें।';

  @override
  String get paywallPlaybackBody => 'आपके वीडियो, बिना विज्ञापन के।';

  @override
  String get paywallVaultTitle => 'बस आपके लिए।';

  @override
  String get paywallVaultBody => 'आपके निजी वीडियो के लिए एक सुरक्षित जगह।';

  @override
  String get paywallMemoriesTitle => 'इस दिन को फिर जीएँ।';

  @override
  String get paywallMemoriesBody => 'पिछले सालों में इसी दिन के वीडियो ढूँढें।';

  @override
  String get paywallSpeedTitle => 'अपनी रफ़्तार से देखें।';

  @override
  String get paywallAdFree => 'बिना विज्ञापन के प्लेबैक';

  @override
  String get paywallAdFreeBody => 'क्लिप बिना विज्ञापन के फिर देखें';

  @override
  String get paywallVaultBenefit => 'अपनी चुनी हुई क्लिप लॉक करें';

  @override
  String get paywallSpeed => '2× पर चलाने के लिए दबाए रखें';

  @override
  String get paywallSpeedBenefit => 'तेज़ी से आगे बढ़ने के लिए दबाए रखें';

  @override
  String get paywallMemoriesBenefit => 'पिछले सालों की क्लिप फिर देखें';

  @override
  String get paywallChoosePlan => 'प्लान चुनें';

  @override
  String get paywallLifetime => 'आजीवन';

  @override
  String get paywallMonthly => 'मासिक';

  @override
  String get paywallRenewsMonthly => 'हर महीने अपने आप रिन्यू होता है';

  @override
  String get paywallGetLifetime => 'आजीवन ऐक्सेस लें';

  @override
  String get paywallSubscribeMonthly => 'मासिक सदस्यता लें';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price/माह';
  }

  @override
  String paywallLifetimeBilling(String price) {
    return 'एक बार $price का भुगतान। कोई सदस्यता नहीं।';
  }

  @override
  String paywallMonthlyBilling(String price) {
    return '$price/माह। हर महीने अपने आप रिन्यू होता है। App Store की सेटिंग में रद्द करें।';
  }

  @override
  String get paywallLoadingPrices => 'कीमतें लोड हो रही हैं…';

  @override
  String get paywallPricesUnavailable => 'प्लान उपलब्ध नहीं हैं';

  @override
  String get paywallLinkUnavailable => 'लिंक नहीं खुल सका। फिर से कोशिश करें।';

  @override
  String get paywallTagline => 'ज़्यादा देखें। बेफ़िक्र रहें।';

  @override
  String get featureAdFree => 'विज्ञापन-मुक्त अनुभव';

  @override
  String get featureAdFreeSub => 'कोई रुकावट नहीं, कभी नहीं';

  @override
  String get featureVault => 'प्राइवेसी वॉल्ट';

  @override
  String get featureVaultSub => 'संवेदनशील वीडियो Face ID से लॉक करें';

  @override
  String get featureSpeed => 'प्लेबैक स्पीड नियंत्रण';

  @override
  String get featureSpeedSub => 'देर तक दबाने पर 2× फ़ास्ट-फ़ॉरवर्ड';

  @override
  String get featureOnThisDay => 'आज के दिन';

  @override
  String get featureOnThisDaySub => 'बीते वर्षों के वीडियो फिर जिएँ';

  @override
  String get unlockPro => 'RollReel Pro अनलॉक करें';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'आप Pro हैं!';

  @override
  String get lifetimeFooter => 'एक बार ख़रीदें · कोई सब्सक्रिप्शन नहीं';

  @override
  String get monthlyFooter => 'हर महीने ऑटो-रिन्यू · कभी भी रद्द करें';

  @override
  String get restorePurchases => 'ख़रीदारी पुनर्स्थापित करें';

  @override
  String get subscriptionDisclaimer =>
      'भुगतान Apple ID से लिया जाता है। अवधि समाप्त होने से 24 घंटे पहले रद्द न करने पर सब्सक्रिप्शन अपने आप रिन्यू हो जाता है।';

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
  String get termsOfUse => 'उपयोग की शर्तें (EULA)';

  @override
  String get lifetimeAccess => 'आजीवन एक्सेस';

  @override
  String get foundingMember => 'संस्थापक सदस्य';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'यह प्लान अभी उपलब्ध नहीं है। कृपया बाद में कोशिश करें।';

  @override
  String get purchaseFailed => 'ख़रीदारी विफल';

  @override
  String get active => 'सक्रिय';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'पुनः प्रयास करें';
}

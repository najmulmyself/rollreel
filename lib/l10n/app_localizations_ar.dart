// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get watchNext => 'شاهد الآن';

  @override
  String get seeAll => 'عرض الكل';

  @override
  String get homeRecordedToday => 'الفيديوهات المصوّرة اليوم';

  @override
  String get homePlays => 'مرات التشغيل';

  @override
  String get homeWatchActivity => 'نشاط المشاهدة';

  @override
  String get homeWatchStreak => 'أيام المشاهدة المتتالية';

  @override
  String get homeMostWatched => 'الأكثر مشاهدة';

  @override
  String get homeTopFolders => 'أهم المجلدات';

  @override
  String get homeVideoRecap => 'ملخّص الفيديوهات';

  @override
  String get homeRecordedThisYear => 'الفيديوهات المصوّرة هذا العام';

  @override
  String get homeNoWatchHistory => 'لا يسجّل RollReel سجل المشاهدة حتى الآن.';

  @override
  String get homeFolderDetailsUnavailable =>
      'تفاصيل المجلدات غير متاحة لهذه المكتبة.';

  @override
  String get homeUnavailable => 'غير متاح';

  @override
  String get homeLoading => 'جارٍ التحميل…';

  @override
  String get homeCameraRoll => 'مقاطعك\nالمصوّرة';

  @override
  String get homeWatchTab => 'مشاهدة';

  @override
  String get homeActivityTab => 'النشاط';

  @override
  String get homeYourActivity => 'نشاطك';

  @override
  String get homeEmptyTitle => 'أول مقطع لك يبدأ هنا';

  @override
  String get homeEmptyBody => 'سجّل مقطعًا بالكاميرا. ستجده هنا عند عودتك.';

  @override
  String get homeOpenCamera => 'فتح الكاميرا';

  @override
  String get homeCaptureFailed => 'تعذّر على RollReel تسجيل المقطع أو حفظه.';

  @override
  String get homeAccessTitle => 'اختر مقاطعك';

  @override
  String get homeAccessBody =>
      'اسمح بالوصول إلى الصور من الإعدادات لمشاهدة مقاطعك.';

  @override
  String get homeLoadFailed => 'تعذّر تحميل مقاطعك';

  @override
  String get homeLoadFailedBody =>
      'ربما لا تزال مكتبتك قيد المزامنة. حاول مجددًا.';

  @override
  String get homeNoMemories => 'لا توجد مقاطع من هذا اليوم في الأعوام السابقة.';

  @override
  String homePlayClip(String title) {
    return 'تشغيل $title';
  }

  @override
  String get homePlaybackFailed => 'تعذّر تشغيل هذا المقطع.';

  @override
  String get homePause => 'إيقاف مؤقت';

  @override
  String get homePlay => 'تشغيل';

  @override
  String get onboardingTitle => 'أعد اكتشاف\nمقاطعك المصوّرة.';

  @override
  String get onboardingSwipeTitle => 'مرّر لأعلى لعرض\nالمقطع التالي.';

  @override
  String get onboardingSwipeSubtitle => 'جرّب على المعاينة أدناه.';

  @override
  String get onboardingTrySwipe => 'جرّب التمرير';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'مقطع تجريبي $current من $total';
  }

  @override
  String get onboardingNextSample => 'عرض المقطع التجريبي التالي';

  @override
  String get onboardingLimitedTitle => 'اختر مقاطع محددة';

  @override
  String get onboardingLimitedBody =>
      'اختر من نافذة النظام العناصر التي يمكن لـ RollReel رؤيتها.';

  @override
  String get onboardingFullTitle => 'اسمح بالوصول إلى المكتبة كلها';

  @override
  String get onboardingFullBody =>
      'تصفّح جميع مقاطعك. يمكنك تغيير الوصول في الإعدادات.';

  @override
  String get onboardingChooseVideos => 'اختيار المقاطع';

  @override
  String get onboardingNotNow => 'ليس الآن';

  @override
  String get onboardingSubtitle =>
      'شاهد اللحظات الصغيرة التي صوّرتها، مقطعًا تلو الآخر.';

  @override
  String get onboardingPrivacyBody =>
      'تُشغّل مقاطعك على جهازك. لا حاجة إلى إنشاء حساب أو رفع مكتبتك.';

  @override
  String get onboardingPermissionBody =>
      'اسمح بالوصول إلى مكتبة الصور كي يعثر RollReel على فيديوهاتك ويشغّلها.';

  @override
  String get onboardingAccessBody =>
      'يستخدم RollReel الوصول إلى الصور لعرض المقاطع من ألبوم الكاميرا.';

  @override
  String get onboardingPermissionNote =>
      'يمكنك تغيير إذن الوصول في أي وقت من الإعدادات.';

  @override
  String get onboardingPermissionError =>
      'تعذّر طلب الوصول. حاول مجددًا أو تخطَّ هذه الخطوة الآن.';

  @override
  String onboardingStep(int step, int total) {
    return 'الخطوة $step من $total';
  }

  @override
  String get onboardingPrivacyTitle => 'لك وحدك.';

  @override
  String get onboardingPermissionTitle => 'ما المقاطع التي\nيمكننا تشغيلها؟';

  @override
  String get onboardingNoCloud => 'بلا سحابة';

  @override
  String get onboardingNoAccount => 'بلا حساب';

  @override
  String get onboardingNoTracking => 'بلا تتبّع';

  @override
  String get swipeHint => 'اسحب';

  @override
  String get skip => 'تخطٍّ';

  @override
  String get getStarted => 'ابدأ';

  @override
  String get continueLabel => 'متابعة';

  @override
  String get requesting => 'جارٍ الطلب…';

  @override
  String get allowAccess => 'السماح بالوصول';

  @override
  String get noVideosYetTitle => 'لا مقاطع بعد';

  @override
  String get noVideosYetBody => 'ستظهر مقاطع ألبوم الكاميرا هنا.';

  @override
  String get openPhotosApp => 'فتح تطبيق الصور';

  @override
  String get loadingLibrary => 'جارٍ تحميل مكتبتك...';

  @override
  String get permissionDeniedTitle => 'الوصول إلى الصور\nمتوقف.';

  @override
  String get permissionDeniedBody =>
      'اختر المقاطع من الإعدادات عندما تكون جاهزًا. لا يزال بإمكانك استكشاف RollReel.';

  @override
  String get openSettings => 'فتح الإعدادات';

  @override
  String get continueAnyway => 'المتابعة على أي حال';

  @override
  String get today => 'اليوم';

  @override
  String get yesterday => 'أمس';

  @override
  String get cancel => 'إلغاء';

  @override
  String get ok => 'حسنًا';

  @override
  String get back => 'رجوع';

  @override
  String get remove => 'إزالة';

  @override
  String get manage => 'إدارة';

  @override
  String get videoFallbackTitle => 'فيديو';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterToday => 'اليوم';

  @override
  String get filterShorts => 'قصيرة';

  @override
  String get filterLong => 'طويلة';

  @override
  String get filterRecent => 'الأحدث';

  @override
  String get videoDeleted => 'تم حذف الفيديو';

  @override
  String get getInfo => 'عرض المعلومات';

  @override
  String get addToVault => 'إضافة إلى الخزنة';

  @override
  String get removeFromVault => 'إزالة من الخزنة';

  @override
  String get deleteVideo => 'حذف الفيديو';

  @override
  String get deleteVideoWarning => 'سيُحذف هذا الفيديو نهائيًا من مكتبتك.';

  @override
  String get thisVideo => 'هذا الفيديو';

  @override
  String get share => 'مشاركة';

  @override
  String get like => 'Like';

  @override
  String get expand => 'توسيع';

  @override
  String get photoLibraryAccess => 'الوصول إلى مكتبة الصور';

  @override
  String get limitedAccessMessage =>
      'أنت تشارك حاليًا مجموعة محدودة من المقاطع.';

  @override
  String get selectMoreVideos => 'اختيار مقاطع إضافية';

  @override
  String get allowFullAccess => 'السماح بالوصول الكامل';

  @override
  String managingCount(int count) {
    return 'تتم إدارة $count من مقاطعك';
  }

  @override
  String get infoDate => 'التاريخ';

  @override
  String get infoDuration => 'المدة';

  @override
  String get infoResolution => 'الدقة';

  @override
  String get infoFileSize => 'حجم الملف';

  @override
  String get infoFormat => 'الصيغة';

  @override
  String get feed => 'الموجز';

  @override
  String get library => 'المكتبة';

  @override
  String get libraryFilters => 'عوامل التصفية';

  @override
  String get libraryClose => 'إغلاق';

  @override
  String get libraryEmptyTitle => 'لا توجد مقاطع بعد';

  @override
  String get libraryAccessOff => 'الوصول إلى الصور متوقف';

  @override
  String get libraryNoMatches => 'لا توجد مقاطع مطابقة';

  @override
  String get librarySearchHelp => 'جرّب عنوانًا آخر أو امسح البحث.';

  @override
  String get libraryNoFilterMatches => 'لا توجد مقاطع توافق عوامل التصفية هذه';

  @override
  String get libraryFilterHelp => 'امسح عوامل التصفية لعرض كل مقاطعك.';

  @override
  String get libraryUnknownDate => 'التاريخ غير معروف';

  @override
  String get libraryDeleteFailed => 'تعذّر على RollReel حذف المقطع.';

  @override
  String libraryDeviceCount(int count) {
    return 'عدد المقاطع على هذا الجهاز: $count';
  }

  @override
  String libraryMemoriesCount(int count) {
    return 'مقاطع من الأعوام السابقة: $count';
  }

  @override
  String libraryVideoOptions(String title) {
    return 'خيارات $title';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

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
  String get searchVideos => 'ابحث عن مقاطع…';

  @override
  String get videosTitle => 'المقاطع';

  @override
  String videosCount(int count) {
    return '$count مقطع';
  }

  @override
  String get yourLibrary => 'مكتبتك';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'محلي';

  @override
  String get noResults => 'لا نتائج';

  @override
  String get noVideosFound => 'لم يُعثر على مقاطع';

  @override
  String noSearchMatches(String query) {
    return 'لا توجد مقاطع تطابق \"$query\".';
  }

  @override
  String get tryDifferentFilter => 'جرّب فلترًا مختلفًا.';

  @override
  String get clearSearch => 'مسح البحث';

  @override
  String get clearFilters => 'مسح الفلاتر';

  @override
  String get filter => 'فلتر';

  @override
  String get reset => 'إعادة تعيين';

  @override
  String get timePeriod => 'الفترة الزمنية';

  @override
  String get thisWeek => 'هذا الأسبوع';

  @override
  String get thisMonth => 'هذا الشهر';

  @override
  String get duration => 'المدة';

  @override
  String get any => 'أي مدة';

  @override
  String get durationShort => '< دقيقة';

  @override
  String get durationMedium => '1–5 دقائق';

  @override
  String get durationLong => '> 5 دقائق';

  @override
  String get sortBy => 'الترتيب حسب';

  @override
  String get newestFirst => 'الأحدث أولًا';

  @override
  String get oldestFirst => 'الأقدم أولًا';

  @override
  String get shortestFirst => 'الأقصر أولًا';

  @override
  String get longestFirst => 'الأطول أولًا';

  @override
  String get applyFilters => 'تطبيق الفلاتر';

  @override
  String get onThisDay => 'في مثل هذا اليوم';

  @override
  String onThisDaySubtitleOne(String years) {
    return 'ذكرى واحدة من $years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '$count ذكريات من السنوات الماضية';
  }

  @override
  String get yearsAgoOne => 'قبل سنة';

  @override
  String yearsAgoMany(int years) {
    return 'قبل $years سنوات';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'في مثل هذا اليوم · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current من $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'تعذّر تحميل الذكريات: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'تعذّر تحميل المقاطع: $error';
  }

  @override
  String get settings => 'الإعدادات';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get playbackSection => 'التشغيل';

  @override
  String get loopShortVideos => 'تكرار المقاطع القصيرة';

  @override
  String get loopShortVideosSub => 'Automatically loop to the next video';

  @override
  String get autoPlayOnLaunch => 'تشغيل تلقائي عند الفتح';

  @override
  String get autoPlayOnLaunchSub => 'Start playing videos automatically';

  @override
  String get defaultFilter => 'الفلتر الافتراضي';

  @override
  String get defaultFilterSub => 'Set your default video filter';

  @override
  String get appearanceSection => 'المظهر';

  @override
  String get darkMode => 'الوضع الداكن';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'إظهار تسميات التاريخ';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'إظهار شارات المدة';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'الخصوصية';

  @override
  String get privacyVault => 'خزنة الخصوصية';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'حول';

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get privacyPolicyBody =>
      'لا يرفع RollReel مقاطعك أو ينقلها أو يخزّنها خارج جهازك. لا حاجة إلى حساب. لا تُشارك أي بيانات شخصية مع أطراف ثالثة.';

  @override
  String get rateApp => 'قيّم RollReel';

  @override
  String get shareApp => 'شارك RollReel';

  @override
  String get version => 'الإصدار';

  @override
  String get proCardSubtitle => 'بلا إعلانات · خزنة · سرعة · مجموعات';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'جرّب RollReel – اسحب عبر مقاطع ألبوم الكاميرا، دون اتصال 100٪!';

  @override
  String get vaultTitle => 'الخزنة الخاصة';

  @override
  String get vaultLocked => 'الخزنة مقفلة';

  @override
  String get vaultLockedSubtitle => 'مقاطعك الخاصة في أمان هنا';

  @override
  String get unlockWithFaceId => 'فتح باستخدام Face ID';

  @override
  String get unlockVaultReason => 'افتح خزنتك الخاصة';

  @override
  String get faceIdUnavailable => 'Face ID غير متاح على هذا الجهاز.';

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
  String get authFailed => 'فشلت المصادقة. يُرجى المحاولة مجددًا.';

  @override
  String get vaultLoadFailed => 'تعذّر تحميل الخزنة';

  @override
  String get vaultEmpty => 'الخزنة فارغة';

  @override
  String get vaultEmptyHint => 'اضغط ••• على أي فيديو لإضافته هنا';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'إزالة من الخزنة؟';

  @override
  String get removeFromVaultBody => 'سيعود هذا الفيديو إلى مكتبتك الرئيسية.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallTagline => 'شاهد أكثر. اطمئن أكثر.';

  @override
  String get featureAdFree => 'تجربة بلا إعلانات';

  @override
  String get featureAdFreeSub => 'بلا مقاطعات، أبدًا';

  @override
  String get featureVault => 'خزنة الخصوصية';

  @override
  String get featureVaultSub => 'اقفل المقاطع الحساسة باستخدام Face ID';

  @override
  String get featureSpeed => 'التحكم في سرعة التشغيل';

  @override
  String get featureSpeedSub => 'تقديم سريع 2× بالضغط المطوّل';

  @override
  String get featureOnThisDay => 'في مثل هذا اليوم';

  @override
  String get featureOnThisDaySub => 'استعد مقاطع السنوات الماضية';

  @override
  String get unlockPro => 'افتح RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'أنت مشترك Pro!';

  @override
  String get lifetimeFooter => 'شراء لمرة واحدة · بلا اشتراك';

  @override
  String get monthlyFooter => 'يتجدد شهريًا تلقائيًا · ألغِ في أي وقت';

  @override
  String get restorePurchases => 'استعادة المشتريات';

  @override
  String get subscriptionDisclaimer =>
      'يُحصَّل المبلغ من حساب Apple ID. يتجدد الاشتراك تلقائيًا ما لم يُلغَ قبل 24 ساعة من نهاية الفترة.';

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
  String get termsOfUse => 'شروط الاستخدام (EULA)';

  @override
  String get lifetimeAccess => 'وصول مدى الحياة';

  @override
  String get foundingMember => 'عضو مؤسس';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'هذه الخطة غير متاحة حاليًا. يُرجى المحاولة لاحقًا.';

  @override
  String get purchaseFailed => 'فشل الشراء';

  @override
  String get active => 'مفعّل';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'إعادة المحاولة';
}

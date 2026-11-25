// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get watchNext => '接着观看';

  @override
  String get seeAll => '查看全部';

  @override
  String get homeRecordedToday => '今天拍摄的视频';

  @override
  String get homePlays => '播放次数';

  @override
  String get homeWatchActivity => '观看活动';

  @override
  String get homeWatchStreak => '连续观看天数';

  @override
  String get homeMostWatched => '观看最多的视频';

  @override
  String get homeTopFolders => '主要文件夹';

  @override
  String get homeVideoRecap => '视频回顾';

  @override
  String get homeRecordedThisYear => '今年拍摄的视频';

  @override
  String get homeNoWatchHistory => 'RollReel 暂未记录观看历史。';

  @override
  String get homeFolderDetailsUnavailable => '此图库没有可用的文件夹信息。';

  @override
  String get homeUnavailable => '不可用';

  @override
  String get homeLoading => '正在加载…';

  @override
  String get homeCameraRoll => '你的\n相机胶卷';

  @override
  String get homeWatchTab => '观看';

  @override
  String get homeActivityTab => '动态';

  @override
  String get homeYourActivity => '你的动态';

  @override
  String get homeEmptyTitle => '从这里开始拍第一段视频';

  @override
  String get homeEmptyBody => '用相机录一段视频，回来就能在这里看到。';

  @override
  String get homeOpenCamera => '打开相机';

  @override
  String get homeCaptureFailed => 'RollReel 无法拍摄或保存视频。';

  @override
  String get homeAccessTitle => '选择你的视频';

  @override
  String get homeAccessBody => '在设置中允许访问照片，即可观看相机胶卷中的视频。';

  @override
  String get homeLoadFailed => '无法加载你的视频';

  @override
  String get homeLoadFailedBody => '相机胶卷可能仍在同步，请再试一次。';

  @override
  String get homeNoMemories => '往年今天没有拍摄视频。';

  @override
  String homePlayClip(String title) {
    return '播放$title';
  }

  @override
  String get homePlaybackFailed => '无法播放此视频。';

  @override
  String get homePause => '暂停';

  @override
  String get homePlay => '播放';

  @override
  String get onboardingTitle => '重温你的\n相机胶卷。';

  @override
  String get onboardingSwipeTitle => '向上滑动，\n观看下一段视频。';

  @override
  String get onboardingSwipeSubtitle => '在下方的预览中试试。';

  @override
  String get onboardingTrySwipe => '试试滑动';

  @override
  String onboardingSampleClip(int current, int total) {
    return '示例视频 $current/$total';
  }

  @override
  String get onboardingNextSample => '显示下一段示例视频';

  @override
  String get onboardingLimitedTitle => '选择部分视频';

  @override
  String get onboardingLimitedBody => '在系统选择器中选择 RollReel 可以访问的项目。';

  @override
  String get onboardingFullTitle => '允许访问整个图库';

  @override
  String get onboardingFullBody => '浏览相机胶卷中的所有视频。你可以在设置中修改权限。';

  @override
  String get onboardingChooseVideos => '选择视频';

  @override
  String get onboardingNotNow => '暂不';

  @override
  String get onboardingSubtitle => '一段一段地回看你拍下的生活片段。';

  @override
  String get onboardingPrivacyBody => '视频在设备上播放，无需创建账号或上传图库。';

  @override
  String get onboardingPermissionBody => '允许访问照片图库，RollReel 才能找到并播放你的影片。';

  @override
  String get onboardingAccessBody => 'RollReel 通过照片权限显示相机胶卷中的视频。';

  @override
  String get onboardingPermissionNote => '你可以随时在设置中更改访问权限。';

  @override
  String get onboardingPermissionError => '无法请求访问。请重试，或暂时跳过。';

  @override
  String onboardingStep(int step, int total) {
    return '第 $step 步，共 $total 步';
  }

  @override
  String get onboardingPrivacyTitle => '只给你看。';

  @override
  String get onboardingPermissionTitle => '我们可以播放\n哪些视频？';

  @override
  String get onboardingNoCloud => '无云端';

  @override
  String get onboardingNoAccount => '无账号';

  @override
  String get onboardingNoTracking => '无追踪';

  @override
  String get swipeHint => '滑动';

  @override
  String get skip => '跳过';

  @override
  String get getStarted => '开始使用';

  @override
  String get continueLabel => '继续';

  @override
  String get requesting => '正在请求…';

  @override
  String get allowAccess => '允许访问';

  @override
  String get noVideosYetTitle => '还没有视频';

  @override
  String get noVideosYetBody => '你的相册视频将显示在这里。';

  @override
  String get openPhotosApp => '打开“照片”App';

  @override
  String get loadingLibrary => '正在载入你的图库...';

  @override
  String get permissionDeniedTitle => '照片访问\n已关闭。';

  @override
  String get permissionDeniedBody => '准备好后，可在设置中选择视频。你仍可继续体验 RollReel。';

  @override
  String get openSettings => '打开设置';

  @override
  String get continueAnyway => '仍然继续';

  @override
  String get today => '今天';

  @override
  String get yesterday => '昨天';

  @override
  String get cancel => '取消';

  @override
  String get ok => '好';

  @override
  String get back => '返回';

  @override
  String get remove => '移除';

  @override
  String get manage => '管理';

  @override
  String get videoFallbackTitle => '视频';

  @override
  String get filterAll => '全部';

  @override
  String get filterToday => '今天';

  @override
  String get filterShorts => '短视频';

  @override
  String get filterLong => '长视频';

  @override
  String get filterRecent => '最近';

  @override
  String get videoDeleted => '视频已删除';

  @override
  String get getInfo => '显示简介';

  @override
  String get addToVault => '加入保险库';

  @override
  String get removeFromVault => '移出保险库';

  @override
  String get deleteVideo => '删除视频';

  @override
  String get deleteVideoWarning => '这将从你的图库中永久删除该视频。';

  @override
  String get thisVideo => '此视频';

  @override
  String get share => '分享';

  @override
  String get like => 'Like';

  @override
  String get expand => '展开';

  @override
  String get photoLibraryAccess => '照片图库访问权限';

  @override
  String get limitedAccessMessage => '你目前仅共享了部分选定的视频。';

  @override
  String get selectMoreVideos => '选择更多视频';

  @override
  String get allowFullAccess => '允许完全访问';

  @override
  String managingCount(int count) {
    return '正在管理你的 $count 个视频';
  }

  @override
  String get infoDate => '日期';

  @override
  String get infoDuration => '时长';

  @override
  String get infoResolution => '分辨率';

  @override
  String get infoFileSize => '文件大小';

  @override
  String get infoFormat => '格式';

  @override
  String get feed => '动态';

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
  String get searchVideos => '搜索视频…';

  @override
  String get videosTitle => '视频';

  @override
  String videosCount(int count) {
    return '$count 个视频';
  }

  @override
  String get yourLibrary => '你的图库';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => '本地';

  @override
  String get noResults => '无结果';

  @override
  String get noVideosFound => '未找到视频';

  @override
  String noSearchMatches(String query) {
    return '没有与“$query”匹配的视频。';
  }

  @override
  String get tryDifferentFilter => '试试其他筛选条件。';

  @override
  String get clearSearch => '清除搜索';

  @override
  String get clearFilters => '清除筛选';

  @override
  String get filter => '筛选';

  @override
  String get reset => '重置';

  @override
  String get timePeriod => '时间范围';

  @override
  String get thisWeek => '本周';

  @override
  String get thisMonth => '本月';

  @override
  String get duration => '时长';

  @override
  String get any => '任意';

  @override
  String get durationShort => '< 1 分钟';

  @override
  String get durationMedium => '1–5 分钟';

  @override
  String get durationLong => '> 5 分钟';

  @override
  String get sortBy => '排序方式';

  @override
  String get newestFirst => '最新优先';

  @override
  String get oldestFirst => '最早优先';

  @override
  String get shortestFirst => '最短优先';

  @override
  String get longestFirst => '最长优先';

  @override
  String get applyFilters => '应用筛选';

  @override
  String get onThisDay => '历史上的今天';

  @override
  String onThisDaySubtitleOne(String years) {
    return '来自 $years 的 1 条回忆';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '来自往年的 $count 条回忆';
  }

  @override
  String get yearsAgoOne => '1 年前';

  @override
  String yearsAgoMany(int years) {
    return '$years 年前';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return '历史上的今天 · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '第 $current 个，共 $total 个';
  }

  @override
  String couldNotLoadMemories(String error) {
    return '无法加载回忆：$error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return '无法加载视频：$error';
  }

  @override
  String get settings => '设置';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get playbackSection => '播放';

  @override
  String get loopShortVideos => '循环播放短视频';

  @override
  String get loopShortVideosSub => 'Automatically loop to the next video';

  @override
  String get autoPlayOnLaunch => '启动时自动播放';

  @override
  String get autoPlayOnLaunchSub => 'Start playing videos automatically';

  @override
  String get defaultFilter => '默认筛选';

  @override
  String get defaultFilterSub => 'Set your default video filter';

  @override
  String get appearanceSection => '外观';

  @override
  String get darkMode => '深色模式';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => '显示日期标签';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => '显示时长标记';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => '隐私';

  @override
  String get privacyVault => '隐私保险库';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => '关于';

  @override
  String get privacyPolicy => '隐私政策';

  @override
  String get privacyPolicyBody =>
      'RollReel 不会将你的任何视频上传、传输或存储到设备之外。无需账号。不会与第三方共享任何个人数据。';

  @override
  String get rateApp => '给 RollReel 评分';

  @override
  String get shareApp => '分享 RollReel';

  @override
  String get version => '版本';

  @override
  String get proCardSubtitle => '无广告 · 保险库 · 倍速 · 合集';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage => '来试试 RollReel——像刷短视频一样刷你的相册视频，100% 离线！';

  @override
  String get vaultTitle => '私密保险库';

  @override
  String get vaultLocked => '保险库已锁定';

  @override
  String get vaultLockedSubtitle => '你的私密视频安全地保存在这里';

  @override
  String get unlockWithFaceId => '使用 Face ID 解锁';

  @override
  String get unlockVaultReason => '解锁你的私密保险库';

  @override
  String get faceIdUnavailable => '此设备不支持 Face ID。';

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
  String get authFailed => '验证失败。请重试。';

  @override
  String get vaultLoadFailed => '无法加载保险库';

  @override
  String get vaultEmpty => '保险库为空';

  @override
  String get vaultEmptyHint => '轻点任意视频上的 ••• 即可添加到这里';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => '移出保险库？';

  @override
  String get removeFromVaultBody => '此视频将返回你的主图库。';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallTagline => '多看一点，少操点心。';

  @override
  String get featureAdFree => '无广告体验';

  @override
  String get featureAdFreeSub => '永无打扰';

  @override
  String get featureVault => '隐私保险库';

  @override
  String get featureVaultSub => '使用 Face ID 锁定私密视频';

  @override
  String get featureSpeed => '播放速度控制';

  @override
  String get featureSpeedSub => '长按 2 倍速快进';

  @override
  String get featureOnThisDay => '历史上的今天';

  @override
  String get featureOnThisDaySub => '重温往年的视频';

  @override
  String get unlockPro => '解锁 RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => '你已是 Pro 用户！';

  @override
  String get lifetimeFooter => '一次性购买 · 无订阅';

  @override
  String get monthlyFooter => '按月自动续订 · 可随时取消';

  @override
  String get restorePurchases => '恢复购买';

  @override
  String get subscriptionDisclaimer =>
      '费用将通过 Apple ID 收取。除非在订阅期结束前 24 小时取消，否则订阅将自动续订。';

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
  String get termsOfUse => '使用条款（EULA）';

  @override
  String get lifetimeAccess => '终身使用权';

  @override
  String get foundingMember => '创始会员';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable => '该方案目前不可用。请稍后再试。';

  @override
  String get purchaseFailed => '购买失败';

  @override
  String get active => '已激活';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => '重试';
}

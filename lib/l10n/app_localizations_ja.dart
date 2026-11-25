// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get watchNext => '次に見る';

  @override
  String get seeAll => 'すべて見る';

  @override
  String get homeRecordedToday => '今日撮影した動画';

  @override
  String get homePlays => '再生回数';

  @override
  String get homeWatchActivity => '視聴アクティビティ';

  @override
  String get homeWatchStreak => '連続視聴日数';

  @override
  String get homeMostWatched => 'よく見た動画';

  @override
  String get homeTopFolders => '主なフォルダ';

  @override
  String get homeVideoRecap => '動画の振り返り';

  @override
  String get homeRecordedThisYear => '今年撮影した動画';

  @override
  String get homeNoWatchHistory => 'RollReel はまだ視聴履歴を記録していません。';

  @override
  String get homeFolderDetailsUnavailable => 'このライブラリのフォルダ情報は利用できません。';

  @override
  String get homeUnavailable => '利用できません';

  @override
  String get homeLoading => '読み込み中…';

  @override
  String get homeCameraRoll => 'あなたの\n動画';

  @override
  String get homeWatchTab => '見る';

  @override
  String get homeActivityTab => 'アクティビティ';

  @override
  String get homeYourActivity => 'あなたのアクティビティ';

  @override
  String get homeEmptyTitle => '最初の動画を撮ってみよう';

  @override
  String get homeEmptyBody => 'カメラで動画を撮影すると、戻ってきたときにここに表示されます。';

  @override
  String get homeOpenCamera => 'カメラを開く';

  @override
  String get homeCaptureFailed => 'RollReel で動画を撮影または保存できませんでした。';

  @override
  String get homeAccessTitle => '動画を選ぶ';

  @override
  String get homeAccessBody => '設定で写真へのアクセスを許可すると、カメラロールの動画を見られます。';

  @override
  String get homeLoadFailed => '動画を読み込めませんでした';

  @override
  String get homeLoadFailedBody => 'カメラロールがまだ同期中かもしれません。もう一度お試しください。';

  @override
  String get homeNoMemories => '過去の同じ日に撮影された動画はありません。';

  @override
  String homePlayClip(String title) {
    return '$titleを再生';
  }

  @override
  String get homePlaybackFailed => 'この動画を再生できませんでした。';

  @override
  String get homePause => '一時停止';

  @override
  String get homePlay => '再生';

  @override
  String get onboardingTitle => 'カメラロールを\nもう一度。';

  @override
  String get onboardingSwipeTitle => '上にスワイプして\n次の動画へ。';

  @override
  String get onboardingSwipeSubtitle => '下のプレビューで試してみましょう。';

  @override
  String get onboardingTrySwipe => 'スワイプを試す';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'サンプル動画 $current/$total';
  }

  @override
  String get onboardingNextSample => '次のサンプル動画を表示';

  @override
  String get onboardingLimitedTitle => '特定の動画を選ぶ';

  @override
  String get onboardingLimitedBody => 'システムの選択画面で RollReel に表示を許可する項目を選びます。';

  @override
  String get onboardingFullTitle => 'ライブラリ全体を許可する';

  @override
  String get onboardingFullBody => 'すべての動画を閲覧できます。アクセスは設定で変更できます。';

  @override
  String get onboardingChooseVideos => '動画を選ぶ';

  @override
  String get onboardingNotNow => '今はしない';

  @override
  String get onboardingSubtitle => '撮りためた日々のひとこまを、1本ずつ見返せます。';

  @override
  String get onboardingPrivacyBody =>
      '動画は端末上で再生されます。アカウントの作成やライブラリのアップロードは不要です。';

  @override
  String get onboardingPermissionBody =>
      '写真ライブラリへのアクセスを許可すると、RollReelで動画を見つけて再生できます。';

  @override
  String get onboardingAccessBody =>
      'RollReel はカメラロールの動画を表示するために写真へのアクセスを使います。';

  @override
  String get onboardingPermissionNote => 'アクセス許可は設定でいつでも変更できます。';

  @override
  String get onboardingPermissionError =>
      'アクセスをリクエストできませんでした。もう一度試すか、今はスキップしてください。';

  @override
  String onboardingStep(int step, int total) {
    return '$totalステップ中$step番目';
  }

  @override
  String get onboardingPrivacyTitle => 'あなただけのもの。';

  @override
  String get onboardingPermissionTitle => 'どの動画を\n再生しますか？';

  @override
  String get onboardingNoCloud => 'クラウドなし';

  @override
  String get onboardingNoAccount => 'アカウント不要';

  @override
  String get onboardingNoTracking => 'トラッキングなし';

  @override
  String get swipeHint => 'スワイプ';

  @override
  String get skip => 'スキップ';

  @override
  String get getStarted => 'はじめる';

  @override
  String get continueLabel => '続ける';

  @override
  String get requesting => 'リクエスト中…';

  @override
  String get allowAccess => 'アクセスを許可';

  @override
  String get noVideosYetTitle => '動画がまだありません';

  @override
  String get noVideosYetBody => 'カメラロールの動画がここに表示されます。';

  @override
  String get openPhotosApp => '「写真」アプリを開く';

  @override
  String get loadingLibrary => 'ライブラリを読み込み中...';

  @override
  String get permissionDeniedTitle => '写真へのアクセスは\nオフです。';

  @override
  String get permissionDeniedBody =>
      '準備ができたら設定で動画を選んでください。このまま RollReel を見ることもできます。';

  @override
  String get openSettings => '設定を開く';

  @override
  String get continueAnyway => 'このまま続ける';

  @override
  String get today => '今日';

  @override
  String get yesterday => '昨日';

  @override
  String get cancel => 'キャンセル';

  @override
  String get ok => 'OK';

  @override
  String get back => '戻る';

  @override
  String get remove => '削除';

  @override
  String get manage => '管理';

  @override
  String get videoFallbackTitle => '動画';

  @override
  String get filterAll => 'すべて';

  @override
  String get filterToday => '今日';

  @override
  String get filterShorts => 'ショート';

  @override
  String get filterLong => 'ロング';

  @override
  String get filterRecent => '最近';

  @override
  String get videoDeleted => '動画を削除しました';

  @override
  String get getInfo => '情報を見る';

  @override
  String get addToVault => '金庫に追加';

  @override
  String get removeFromVault => '金庫から出す';

  @override
  String get deleteVideo => '動画を削除';

  @override
  String get deleteVideoWarning => 'この動画はライブラリから完全に削除されます。';

  @override
  String get thisVideo => 'この動画';

  @override
  String get share => '共有';

  @override
  String get like => 'Like';

  @override
  String get expand => '拡大';

  @override
  String get photoLibraryAccess => '写真ライブラリへのアクセス';

  @override
  String get limitedAccessMessage => '現在、選択した一部の動画のみを共有しています。';

  @override
  String get selectMoreVideos => 'さらに動画を選択';

  @override
  String get allowFullAccess => 'フルアクセスを許可';

  @override
  String managingCount(int count) {
    return '$count 本の動画を管理中';
  }

  @override
  String get infoDate => '日付';

  @override
  String get infoDuration => '長さ';

  @override
  String get infoResolution => '解像度';

  @override
  String get infoFileSize => 'ファイルサイズ';

  @override
  String get infoFormat => 'フォーマット';

  @override
  String get feed => 'フィード';

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
  String get searchVideos => '動画を検索…';

  @override
  String get videosTitle => '動画';

  @override
  String videosCount(int count) {
    return '$count 本の動画';
  }

  @override
  String get yourLibrary => 'ライブラリ';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'ローカル';

  @override
  String get noResults => '結果なし';

  @override
  String get noVideosFound => '動画が見つかりません';

  @override
  String noSearchMatches(String query) {
    return '「$query」に一致する動画はありません。';
  }

  @override
  String get tryDifferentFilter => '別のフィルタをお試しください。';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get clearFilters => 'フィルタをクリア';

  @override
  String get filter => 'フィルタ';

  @override
  String get reset => 'リセット';

  @override
  String get timePeriod => '期間';

  @override
  String get thisWeek => '今週';

  @override
  String get thisMonth => '今月';

  @override
  String get duration => '長さ';

  @override
  String get any => '指定なし';

  @override
  String get durationShort => '1 分未満';

  @override
  String get durationMedium => '1〜5 分';

  @override
  String get durationLong => '5 分以上';

  @override
  String get sortBy => '並べ替え';

  @override
  String get newestFirst => '新しい順';

  @override
  String get oldestFirst => '古い順';

  @override
  String get shortestFirst => '短い順';

  @override
  String get longestFirst => '長い順';

  @override
  String get applyFilters => 'フィルタを適用';

  @override
  String get onThisDay => '過去のこの日';

  @override
  String onThisDaySubtitleOne(String years) {
    return '$years の思い出 1 件';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '過去の思い出 $count 件';
  }

  @override
  String get yearsAgoOne => '1 年前';

  @override
  String yearsAgoMany(int years) {
    return '$years 年前';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return '過去のこの日 · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$total 件中 $current 件目';
  }

  @override
  String couldNotLoadMemories(String error) {
    return '思い出を読み込めませんでした：$error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return '動画を読み込めませんでした：$error';
  }

  @override
  String get settings => '設定';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get playbackSection => '再生';

  @override
  String get loopShortVideos => 'ショート動画をループ再生';

  @override
  String get loopShortVideosSub => 'Automatically loop to the next video';

  @override
  String get autoPlayOnLaunch => '起動時に自動再生';

  @override
  String get autoPlayOnLaunchSub => 'Start playing videos automatically';

  @override
  String get defaultFilter => 'デフォルトのフィルタ';

  @override
  String get defaultFilterSub => 'Set your default video filter';

  @override
  String get appearanceSection => '外観';

  @override
  String get darkMode => 'ダークモード';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => '日付ラベルを表示';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => '再生時間バッジを表示';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'プライバシー';

  @override
  String get privacyVault => 'プライバシー金庫';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => '情報';

  @override
  String get privacyPolicy => 'プライバシーポリシー';

  @override
  String get privacyPolicyBody =>
      'RollReel はお客様の動画をデバイス外にアップロード、送信、保存することはありません。アカウントは不要です。個人データが第三者と共有されることもありません。';

  @override
  String get rateApp => 'RollReel を評価';

  @override
  String get shareApp => 'RollReel を共有';

  @override
  String get version => 'バージョン';

  @override
  String get proCardSubtitle => '広告なし · 金庫 · 倍速 · コレクション';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'RollReel をチェック！カメラロールの動画をフィード感覚でスワイプ、100% オフライン！';

  @override
  String get vaultTitle => 'プライベート金庫';

  @override
  String get vaultLocked => '金庫はロック中';

  @override
  String get vaultLockedSubtitle => 'プライベートな動画はここで安全に保管';

  @override
  String get unlockWithFaceId => 'Face ID でロック解除';

  @override
  String get unlockVaultReason => 'プライベート金庫のロックを解除します';

  @override
  String get faceIdUnavailable => 'このデバイスでは Face ID を利用できません。';

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
  String get authFailed => '認証に失敗しました。もう一度お試しください。';

  @override
  String get vaultLoadFailed => '金庫を読み込めませんでした';

  @override
  String get vaultEmpty => '金庫は空です';

  @override
  String get vaultEmptyHint => '動画の ••• をタップして追加できます';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => '金庫から出しますか？';

  @override
  String get removeFromVaultBody => 'この動画はメインライブラリに戻ります。';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallTagline => 'もっと見る。もっと安心。';

  @override
  String get featureAdFree => '広告なし体験';

  @override
  String get featureAdFreeSub => '中断は一切なし';

  @override
  String get featureVault => 'プライバシー金庫';

  @override
  String get featureVaultSub => '大切な動画を Face ID でロック';

  @override
  String get featureSpeed => '再生速度コントロール';

  @override
  String get featureSpeedSub => '長押しで 2 倍速早送り';

  @override
  String get featureOnThisDay => '過去のこの日';

  @override
  String get featureOnThisDaySub => '過去の動画をもう一度';

  @override
  String get unlockPro => 'RollReel Pro をアンロック';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'あなたは Pro です！';

  @override
  String get lifetimeFooter => '買い切り · サブスクリプションなし';

  @override
  String get monthlyFooter => '毎月自動更新 · いつでもキャンセル可能';

  @override
  String get restorePurchases => '購入を復元';

  @override
  String get subscriptionDisclaimer =>
      '料金は Apple ID に請求されます。期間終了の 24 時間前までにキャンセルしない限り、サブスクリプションは自動更新されます。';

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
  String get termsOfUse => '利用規約（EULA）';

  @override
  String get lifetimeAccess => '生涯アクセス';

  @override
  String get foundingMember => '創設メンバー';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable => 'このプランは現在ご利用いただけません。後ほどもう一度お試しください。';

  @override
  String get purchaseFailed => '購入に失敗しました';

  @override
  String get active => '有効';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => '再試行';
}

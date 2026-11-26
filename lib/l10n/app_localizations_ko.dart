// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get watchNext => '다음에 볼 영상';

  @override
  String get seeAll => '모두 보기';

  @override
  String get homeRecordedToday => '오늘 촬영한 영상';

  @override
  String get homePlays => '재생 횟수';

  @override
  String get homeWatchActivity => '시청 활동';

  @override
  String get homeWatchStreak => '연속 시청 일수';

  @override
  String get homeMostWatched => '가장 많이 본 영상';

  @override
  String get homeTopFolders => '주요 폴더';

  @override
  String get homeVideoRecap => '영상 요약';

  @override
  String get homeRecordedThisYear => '올해 촬영한 영상';

  @override
  String get homeNoWatchHistory => 'RollReel은 아직 시청 기록을 저장하지 않습니다.';

  @override
  String get homeFolderDetailsUnavailable => '이 보관함의 폴더 정보를 사용할 수 없습니다.';

  @override
  String get homeUnavailable => '사용할 수 없음';

  @override
  String get homeLoading => '불러오는 중…';

  @override
  String get homeCameraRoll => '나의\n동영상';

  @override
  String get homeWatchTab => '보기';

  @override
  String get homeActivityTab => '활동';

  @override
  String get homeYourActivity => '나의 활동';

  @override
  String get homeEmptyTitle => '첫 동영상을 찍어 보세요';

  @override
  String get homeEmptyBody => '카메라로 동영상을 찍으면 돌아왔을 때 여기에서 볼 수 있어요.';

  @override
  String get homeOpenCamera => '카메라 열기';

  @override
  String get homeCaptureFailed => 'RollReel에서 동영상을 촬영하거나 저장하지 못했어요.';

  @override
  String get homeAccessTitle => '동영상을 선택하세요';

  @override
  String get homeAccessBody => '카메라 롤의 동영상을 보려면 설정에서 사진 접근을 허용하세요.';

  @override
  String get homeLoadFailed => '동영상을 불러오지 못했어요';

  @override
  String get homeLoadFailedBody => '카메라 롤이 아직 동기화 중일 수 있어요. 다시 시도해 주세요.';

  @override
  String get homeNoMemories => '지난해 같은 날짜에 찍은 동영상이 없어요.';

  @override
  String homePlayClip(String title) {
    return '$title 재생';
  }

  @override
  String get homePlaybackFailed => '이 동영상을 재생할 수 없어요.';

  @override
  String get homePause => '일시 정지';

  @override
  String get homePlay => '재생';

  @override
  String get onboardingTitle => '다시 보는\n카메라 롤.';

  @override
  String favoritesSavedCount(int count) {
    return '$count개 저장됨';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return '즐겨찾기에서 $title 삭제';
  }

  @override
  String get favoritesRemoved => '즐겨찾기에서 삭제했어요';

  @override
  String get favoritesUndo => '실행 취소';

  @override
  String get favoritesLoadFailed => '즐겨찾기를 불러올 수 없어요';

  @override
  String get favoritesRetryBody => '저장된 동영상을 다시 불러와 보세요.';

  @override
  String get favoritesAccessBody => '저장된 동영상을 보려면 사진 접근을 허용하세요.';

  @override
  String get favoritesUpdateFailed => '즐겨찾기를 업데이트할 수 없어요.';

  @override
  String get onboardingSwipeTitle => '위로 밀어\n다음 동영상 보기.';

  @override
  String get onboardingSwipeSubtitle => '아래 미리보기에서 해보세요.';

  @override
  String get onboardingTrySwipe => '밀어 보기';

  @override
  String onboardingSampleClip(int current, int total) {
    return '샘플 동영상 $current/$total';
  }

  @override
  String get onboardingNextSample => '다음 샘플 동영상 보기';

  @override
  String get onboardingLimitedTitle => '특정 동영상 선택';

  @override
  String get onboardingLimitedBody => '시스템 선택 화면에서 RollReel이 볼 수 있는 항목을 선택하세요.';

  @override
  String get onboardingFullTitle => '보관함 전체 허용';

  @override
  String get onboardingFullBody => '모든 동영상을 둘러보세요. 설정에서 접근 권한을 변경할 수 있습니다.';

  @override
  String get onboardingChooseVideos => '동영상 선택';

  @override
  String get onboardingNotNow => '나중에';

  @override
  String get onboardingSubtitle => '직접 찍은 소중한 순간을 하나씩 다시 보세요.';

  @override
  String get onboardingPrivacyBody =>
      '동영상은 기기에서 재생됩니다. 계정을 만들거나 보관함을 업로드할 필요가 없습니다.';

  @override
  String get onboardingPermissionBody =>
      'RollReel이 영상을 찾아 재생할 수 있도록 사진 보관함 접근을 허용해 주세요.';

  @override
  String get onboardingAccessBody =>
      'RollReel은 카메라 롤의 동영상을 표시하기 위해 사진 접근 권한을 사용합니다.';

  @override
  String get onboardingPermissionNote => '접근 권한은 설정에서 언제든 바꿀 수 있습니다.';

  @override
  String get onboardingPermissionError =>
      '접근 권한을 요청하지 못했습니다. 다시 시도하거나 지금은 건너뛰세요.';

  @override
  String onboardingStep(int step, int total) {
    return '전체 $total단계 중 $step단계';
  }

  @override
  String get onboardingPrivacyTitle => '나만을 위한 영상.';

  @override
  String get onboardingPermissionTitle => '어떤 동영상을\n재생할까요?';

  @override
  String get onboardingNoCloud => '클라우드 없음';

  @override
  String get onboardingNoAccount => '계정 없음';

  @override
  String get onboardingNoTracking => '추적 없음';

  @override
  String get swipeHint => '스와이프';

  @override
  String get skip => '건너뛰기';

  @override
  String get getStarted => '시작하기';

  @override
  String get continueLabel => '계속';

  @override
  String get requesting => '요청 중…';

  @override
  String get allowAccess => '접근 허용';

  @override
  String get noVideosYetTitle => '아직 동영상이 없어요';

  @override
  String get noVideosYetBody => '카메라 롤의 동영상이 여기에 표시됩니다.';

  @override
  String get openPhotosApp => '사진 앱 열기';

  @override
  String get loadingLibrary => '보관함을 불러오는 중...';

  @override
  String get permissionDeniedTitle => '사진 접근이\n꺼져 있습니다.';

  @override
  String get permissionDeniedBody =>
      '준비되면 설정에서 동영상을 선택하세요. 지금도 RollReel을 둘러볼 수 있습니다.';

  @override
  String get openSettings => '설정 열기';

  @override
  String get continueAnyway => '그래도 계속';

  @override
  String get today => '오늘';

  @override
  String get yesterday => '어제';

  @override
  String get cancel => '취소';

  @override
  String get ok => '확인';

  @override
  String get back => '뒤로';

  @override
  String get remove => '제거';

  @override
  String get manage => '관리';

  @override
  String get videoFallbackTitle => '동영상';

  @override
  String get filterAll => '전체';

  @override
  String get filterToday => '오늘';

  @override
  String get filterShorts => '짧은';

  @override
  String get filterLong => '긴';

  @override
  String get filterRecent => '최근';

  @override
  String get videoDeleted => '동영상이 삭제됨';

  @override
  String get getInfo => '정보 보기';

  @override
  String get addToVault => '보관함에 추가';

  @override
  String get removeFromVault => '보관함에서 제거';

  @override
  String get deleteVideo => '동영상 삭제';

  @override
  String get deleteVideoWarning => '이 동영상이 보관함에서 영구적으로 삭제됩니다.';

  @override
  String get thisVideo => '이 동영상';

  @override
  String get share => '공유';

  @override
  String get like => 'Like';

  @override
  String get expand => '확대';

  @override
  String get photoLibraryAccess => '사진 보관함 접근';

  @override
  String get limitedAccessMessage => '현재 일부 동영상만 공유하고 있습니다.';

  @override
  String get selectMoreVideos => '동영상 더 선택';

  @override
  String get allowFullAccess => '전체 접근 허용';

  @override
  String managingCount(int count) {
    return '동영상 $count개 관리 중';
  }

  @override
  String get infoDate => '날짜';

  @override
  String get infoDuration => '길이';

  @override
  String get infoResolution => '해상도';

  @override
  String get infoFileSize => '파일 크기';

  @override
  String get infoFormat => '형식';

  @override
  String get feed => '피드';

  @override
  String get library => '보관함';

  @override
  String get libraryFilters => '필터';

  @override
  String get libraryClose => '닫기';

  @override
  String get libraryEmptyTitle => '아직 동영상이 없어요';

  @override
  String get libraryAccessOff => '사진 접근 권한이 꺼져 있어요';

  @override
  String get libraryNoMatches => '일치하는 동영상이 없어요';

  @override
  String get librarySearchHelp => '다른 제목을 검색하거나 검색어를 지워 보세요.';

  @override
  String get libraryNoFilterMatches => '이 필터와 일치하는 동영상이 없어요';

  @override
  String get libraryFilterHelp => '모든 동영상을 보려면 필터를 지우세요.';

  @override
  String get libraryUnknownDate => '날짜를 알 수 없음';

  @override
  String get libraryDeleteFailed => 'RollReel에서 동영상을 삭제할 수 없어요.';

  @override
  String libraryDeviceCount(int count) {
    return '이 기기의 동영상 $count개';
  }

  @override
  String libraryMemoriesCount(int count) {
    return '지난해 같은 날의 동영상 $count개';
  }

  @override
  String libraryVideoOptions(String title) {
    return '$title 옵션';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => '아직 즐겨찾기가 없어요';

  @override
  String get favoritesEmptyBody => '동영상을 보다가 하트를 누르면 여기에 저장돼요.';

  @override
  String get goToLibrary => '보관함 둘러보기';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => '동영상 검색…';

  @override
  String get videosTitle => '동영상';

  @override
  String videosCount(int count) {
    return '동영상 $count개';
  }

  @override
  String get yourLibrary => '내 보관함';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => '로컬';

  @override
  String get noResults => '결과 없음';

  @override
  String get noVideosFound => '동영상을 찾을 수 없음';

  @override
  String noSearchMatches(String query) {
    return '\"$query\"와 일치하는 동영상이 없습니다.';
  }

  @override
  String get tryDifferentFilter => '다른 필터를 사용해 보세요.';

  @override
  String get clearSearch => '검색 지우기';

  @override
  String get clearFilters => '필터 지우기';

  @override
  String get filter => '필터';

  @override
  String get reset => '재설정';

  @override
  String get timePeriod => '기간';

  @override
  String get thisWeek => '이번 주';

  @override
  String get thisMonth => '이번 달';

  @override
  String get duration => '길이';

  @override
  String get any => '전체';

  @override
  String get durationShort => '< 1분';

  @override
  String get durationMedium => '1–5분';

  @override
  String get durationLong => '> 5분';

  @override
  String get sortBy => '정렬';

  @override
  String get newestFirst => '최신순';

  @override
  String get oldestFirst => '오래된순';

  @override
  String get shortestFirst => '짧은순';

  @override
  String get longestFirst => '긴순';

  @override
  String get applyFilters => '필터 적용';

  @override
  String get onThisDay => '그날의 추억';

  @override
  String onThisDaySubtitleOne(String years) {
    return '$years의 추억 1개';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '지난날의 추억 $count개';
  }

  @override
  String get yearsAgoOne => '1년 전';

  @override
  String yearsAgoMany(int years) {
    return '$years년 전';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return '그날의 추억 · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$total개 중 $current';
  }

  @override
  String couldNotLoadMemories(String error) {
    return '추억을 불러올 수 없습니다: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return '동영상을 불러올 수 없습니다: $error';
  }

  @override
  String get settings => '설정';

  @override
  String get home => 'Home';

  @override
  String get favorites => '즐겨찾기';

  @override
  String get playbackSection => '재생';

  @override
  String get loopShortVideos => '짧은 동영상 반복 재생';

  @override
  String get loopShortVideosSub => '30초 미만의 클립을 반복 재생';

  @override
  String get autoPlayOnLaunch => '실행 시 자동 재생';

  @override
  String get autoPlayOnLaunchSub => '피드를 열면 재생 시작';

  @override
  String get defaultFilter => '기본 필터';

  @override
  String get defaultFilterSub => '피드에 표시할 동영상 선택';

  @override
  String get appearanceSection => '화면';

  @override
  String get darkMode => '다크 모드';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => '날짜 표시';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => '길이 표시';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => '개인정보 보호';

  @override
  String get privacyVault => '프라이버시 금고';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => '정보';

  @override
  String get privacyPolicy => '개인정보 처리방침';

  @override
  String get privacyPolicyBody =>
      'RollReel은 동영상을 기기 외부로 업로드, 전송 또는 저장하지 않습니다. 계정이 필요 없습니다. 어떠한 개인정보도 제3자와 공유되지 않습니다.';

  @override
  String get rateApp => 'RollReel 평가하기';

  @override
  String get shareApp => 'RollReel 공유하기';

  @override
  String get version => '버전';

  @override
  String get settingsFilterDescription => '피드를 열 때 표시할 동영상을 선택하세요.';

  @override
  String get settingsProDescription => '광고 없는 재생과 프라이버시 금고';

  @override
  String get settingsProActive => 'Pro 사용 중';

  @override
  String get settingsVaultDescription => '비공개 동영상 열기';

  @override
  String get settingsRestoreComplete => '이전 구매 내역 확인이 완료되었습니다.';

  @override
  String get settingsRestoreFailed => '구매를 복원할 수 없습니다. 다시 시도해 주세요.';

  @override
  String get proCardSubtitle => '광고 없음 · 금고 · 배속 · 컬렉션';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'RollReel을 만나보세요 – 카메라 롤 동영상을 100% 오프라인으로 스와이프!';

  @override
  String get vaultTitle => '프라이빗 금고';

  @override
  String get vaultLocked => '금고 잠김';

  @override
  String get vaultLockedSubtitle => '개인 동영상이 여기에 안전하게 보관됩니다';

  @override
  String get unlockWithFaceId => 'Face ID로 잠금 해제';

  @override
  String get unlockVaultReason => '프라이빗 금고 잠금 해제';

  @override
  String get faceIdUnavailable => '이 기기에서는 Face ID를 사용할 수 없습니다.';

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
  String get authFailed => '인증에 실패했습니다. 다시 시도해 주세요.';

  @override
  String get vaultLoadFailed => '금고를 불러오지 못했습니다';

  @override
  String get vaultEmpty => '금고가 비어 있습니다';

  @override
  String get vaultEmptyHint => '동영상에서 •••를 눌러 여기에 추가하세요';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => '금고에서 제거할까요?';

  @override
  String get removeFromVaultBody => '이 동영상은 기본 보관함으로 돌아갑니다.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallPlaybackTitle => '계속 감상하세요.';

  @override
  String get paywallPlaybackBody => '광고 없이 내 동영상을 감상하세요.';

  @override
  String get paywallVaultTitle => '나만 볼 수 있게.';

  @override
  String get paywallVaultBody => '비공개 동영상을 위한 잠금 공간입니다.';

  @override
  String get paywallMemoriesTitle => '그날을 다시 보세요.';

  @override
  String get paywallMemoriesBody => '지난해 오늘에 찍은 동영상을 찾아보세요.';

  @override
  String get paywallSpeedTitle => '원하는 속도로 감상하세요.';

  @override
  String get paywallAdFree => '광고 없는 재생';

  @override
  String get paywallAdFreeBody => '광고 없이 클립 다시 보기';

  @override
  String get paywallVaultBenefit => '고른 클립을 잠그세요';

  @override
  String get paywallSpeed => '길게 눌러 2배속 재생';

  @override
  String get paywallSpeedBenefit => '길게 눌러 빠르게 넘기세요';

  @override
  String get paywallMemoriesBenefit => '지난해의 클립을 다시 만나세요';

  @override
  String get paywallChoosePlan => '요금제 선택';

  @override
  String get paywallLifetime => '평생 이용';

  @override
  String get paywallMonthly => '월간';

  @override
  String get paywallRenewsMonthly => '매월 자동 갱신';

  @override
  String get paywallGetLifetime => '평생 이용권 구매';

  @override
  String get paywallSubscribeMonthly => '월간 구독';

  @override
  String paywallMonthlyPrice(String price) {
    return '월 $price';
  }

  @override
  String paywallLifetimeBilling(String price) {
    return '$price 한 번 결제. 구독이 아닙니다.';
  }

  @override
  String paywallMonthlyBilling(String price) {
    return '월 $price. 매월 자동 갱신됩니다. App Store 설정에서 취소할 수 있습니다.';
  }

  @override
  String get paywallLoadingPrices => '가격 불러오는 중…';

  @override
  String get paywallPricesUnavailable => '이용 가능한 요금제 없음';

  @override
  String get paywallLinkUnavailable => '링크를 열 수 없습니다. 다시 시도해 주세요.';

  @override
  String get paywallTagline => '더 많이 보고, 걱정은 덜고.';

  @override
  String get featureAdFree => '광고 없는 경험';

  @override
  String get featureAdFreeSub => '어떤 방해도 없이';

  @override
  String get featureVault => '프라이버시 금고';

  @override
  String get featureVaultSub => '민감한 동영상을 Face ID로 잠금';

  @override
  String get featureSpeed => '재생 속도 제어';

  @override
  String get featureSpeedSub => '길게 눌러 2배속 빨리 감기';

  @override
  String get featureOnThisDay => '그날의 추억';

  @override
  String get featureOnThisDaySub => '지난날의 동영상을 다시 만나보세요';

  @override
  String get unlockPro => 'RollReel Pro 잠금 해제';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'Pro 사용 중!';

  @override
  String get lifetimeFooter => '1회 구매 · 구독 없음';

  @override
  String get monthlyFooter => '매월 자동 갱신 · 언제든 취소 가능';

  @override
  String get restorePurchases => '구매 복원';

  @override
  String get subscriptionDisclaimer =>
      '결제는 Apple ID로 청구됩니다. 기간 종료 24시간 전까지 취소하지 않으면 구독이 자동 갱신됩니다.';

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
  String get termsOfUse => '이용 약관 (EULA)';

  @override
  String get lifetimeAccess => '평생 이용';

  @override
  String get foundingMember => '창립 멤버';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable => '지금은 이 플랜을 이용할 수 없습니다. 나중에 다시 시도해 주세요.';

  @override
  String get purchaseFailed => '구매 실패';

  @override
  String get active => '사용 중';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => '다시 시도';
}

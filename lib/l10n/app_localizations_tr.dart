// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get watchNext => 'Sırada izle';

  @override
  String get seeAll => 'Tümünü gör';

  @override
  String get homeRecordedToday => 'Bugün çekilen videolar';

  @override
  String get homePlays => 'Oynatmalar';

  @override
  String get homeWatchActivity => 'İzleme etkinliği';

  @override
  String get homeWatchStreak => 'İzleme serisi';

  @override
  String get homeMostWatched => 'En çok izlenenler';

  @override
  String get homeTopFolders => 'Öne çıkan klasörler';

  @override
  String get homeVideoRecap => 'Video özeti';

  @override
  String get homeRecordedThisYear => 'Bu yıl çekilen videolar';

  @override
  String get homeNoWatchHistory =>
      'RollReel henüz izleme geçmişini kaydetmiyor.';

  @override
  String get homeFolderDetailsUnavailable =>
      'Bu arşiv için klasör ayrıntıları kullanılamıyor.';

  @override
  String get homeUnavailable => 'Kullanılamıyor';

  @override
  String get homeLoading => 'Yükleniyor…';

  @override
  String get homeCameraRoll => 'Senin\nvideoların';

  @override
  String get homeWatchTab => 'İzle';

  @override
  String get homeActivityTab => 'Etkinlik';

  @override
  String get homeYourActivity => 'Etkinliğin';

  @override
  String get homeEmptyTitle => 'İlk videon burada başlıyor';

  @override
  String get homeEmptyBody =>
      'Kameranla bir video çek. Geri döndüğünde burada olacak.';

  @override
  String get homeOpenCamera => 'Kamerayı aç';

  @override
  String get homeCaptureFailed => 'RollReel videoyu çekemedi veya kaydedemedi.';

  @override
  String get homeAccessTitle => 'Videolarını seç';

  @override
  String get homeAccessBody =>
      'Videolarını izlemek için Ayarlar’dan Fotoğraflar’a erişim izni ver.';

  @override
  String get homeLoadFailed => 'Videoların yüklenemedi';

  @override
  String get homeLoadFailedBody =>
      'Arşivin hâlâ eşitleniyor olabilir. Tekrar dene.';

  @override
  String get homeNoMemories => 'Geçmiş yıllarda bu tarihte çekilmiş video yok.';

  @override
  String homePlayClip(String title) {
    return '$title videosunu oynat';
  }

  @override
  String get homePlaybackFailed => 'Bu video oynatılamadı.';

  @override
  String get homePause => 'Duraklat';

  @override
  String get homePlay => 'Oynat';

  @override
  String get onboardingTitle => 'Kamera rulona\ngeri dön.';

  @override
  String favoritesSavedCount(int count) {
    return '$count kayıtlı';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return '$title videosunu Favorilerden çıkar';
  }

  @override
  String get favoritesRemoved => 'Favorilerden çıkarıldı';

  @override
  String get favoritesUndo => 'Geri al';

  @override
  String get favoritesLoadFailed => 'Favoriler yüklenemedi';

  @override
  String get favoritesRetryBody => 'Kayıtlı videolarını tekrar yüklemeyi dene.';

  @override
  String get favoritesAccessBody =>
      'Kayıtlı videolarını görmek için Fotoğraflar’a erişim ver.';

  @override
  String get favoritesUpdateFailed => 'Favoriler güncellenemedi.';

  @override
  String get onboardingSwipeTitle => 'Sonraki video için\nyukarı kaydır.';

  @override
  String get onboardingSwipeSubtitle => 'Aşağıdaki önizlemede dene.';

  @override
  String get onboardingTrySwipe => 'Kaydırmayı dene';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Örnek video $current / $total';
  }

  @override
  String get onboardingNextSample => 'Sonraki örnek videoyu göster';

  @override
  String get onboardingLimitedTitle => 'Belirli videoları seç';

  @override
  String get onboardingLimitedBody =>
      'Sistem seçicisinde RollReel’in görebileceği öğeleri seç.';

  @override
  String get onboardingFullTitle => 'Tüm arşive izin ver';

  @override
  String get onboardingFullBody =>
      'Tüm videolarına göz at. Erişimi Ayarlar’dan değiştirebilirsin.';

  @override
  String get onboardingChooseVideos => 'Videoları seç';

  @override
  String get onboardingNotNow => 'Şimdi değil';

  @override
  String get onboardingSubtitle =>
      'Çektiğin küçük anları tek tek yeniden izle.';

  @override
  String get onboardingPrivacyBody =>
      'Videoların cihazında oynatılır. Hesap açman veya arşivini yüklemen gerekmez.';

  @override
  String get onboardingPermissionBody =>
      'RollReel’in videolarınızı bulup oynatabilmesi için fotoğraf arşivine erişim izni verin.';

  @override
  String get onboardingAccessBody =>
      'RollReel, kamera rulondaki videoları göstermek için Fotoğraflar erişimini kullanır.';

  @override
  String get onboardingPermissionNote =>
      'Erişim iznini Ayarlar’dan istediğiniz zaman değiştirebilirsiniz.';

  @override
  String get onboardingPermissionError =>
      'Erişim istenemedi. Tekrar deneyin veya şimdilik bu adımı atlayın.';

  @override
  String onboardingStep(int step, int total) {
    return '$total adımdan $step. adım';
  }

  @override
  String get onboardingPrivacyTitle => 'Sadece sizin için.';

  @override
  String get onboardingPermissionTitle => 'Hangi videoları\noynatabiliriz?';

  @override
  String get onboardingNoCloud => 'Bulut Yok';

  @override
  String get onboardingNoAccount => 'Hesap Yok';

  @override
  String get onboardingNoTracking => 'Takip Yok';

  @override
  String get swipeHint => 'KAYDIR';

  @override
  String get skip => 'Atla';

  @override
  String get getStarted => 'Başla';

  @override
  String get continueLabel => 'Devam Et';

  @override
  String get requesting => 'İsteniyor…';

  @override
  String get allowAccess => 'Erişime İzin Ver';

  @override
  String get noVideosYetTitle => 'Henüz Video Yok';

  @override
  String get noVideosYetBody => 'Kamera rulondaki videolar burada görünecek.';

  @override
  String get openPhotosApp => 'Fotoğraflar Uygulamasını Aç';

  @override
  String get loadingLibrary => 'Arşivin yükleniyor...';

  @override
  String get permissionDeniedTitle => 'Fotoğraflar\nerişimi kapalı.';

  @override
  String get permissionDeniedBody =>
      'Hazır olduğunda Ayarlar’dan videoları seç. RollReel’i keşfetmeye devam edebilirsin.';

  @override
  String get openSettings => 'Ayarları Aç';

  @override
  String get continueAnyway => 'Yine de Devam Et';

  @override
  String get today => 'Bugün';

  @override
  String get yesterday => 'Dün';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get ok => 'Tamam';

  @override
  String get back => 'Geri';

  @override
  String get remove => 'Kaldır';

  @override
  String get manage => 'Yönet';

  @override
  String get videoFallbackTitle => 'Video';

  @override
  String get filterAll => 'Tümü';

  @override
  String get filterToday => 'Bugün';

  @override
  String get filterShorts => 'Kısa';

  @override
  String get filterLong => 'Uzun';

  @override
  String get filterRecent => 'Son';

  @override
  String get videoDeleted => 'Video silindi';

  @override
  String get getInfo => 'Bilgi Al';

  @override
  String get addToVault => 'Kasaya Ekle';

  @override
  String get removeFromVault => 'Kasadan Kaldır';

  @override
  String get deleteVideo => 'Videoyu Sil';

  @override
  String get deleteVideoWarning =>
      'Bu video arşivinden kalıcı olarak silinecek.';

  @override
  String get thisVideo => 'Bu video';

  @override
  String get share => 'Paylaş';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Genişlet';

  @override
  String get photoLibraryAccess => 'Fotoğraf Arşivi Erişimi';

  @override
  String get limitedAccessMessage =>
      'Şu anda sınırlı sayıda video paylaşıyorsun.';

  @override
  String get selectMoreVideos => 'Daha Fazla Video Seç';

  @override
  String get allowFullAccess => 'Tam Erişime İzin Ver';

  @override
  String managingCount(int count) {
    return 'Videolarının $count tanesi yönetiliyor';
  }

  @override
  String get infoDate => 'Tarih';

  @override
  String get infoDuration => 'Süre';

  @override
  String get infoResolution => 'Çözünürlük';

  @override
  String get infoFileSize => 'Dosya Boyutu';

  @override
  String get infoFormat => 'Biçim';

  @override
  String get feed => 'Akış';

  @override
  String get library => 'Arşiv';

  @override
  String get libraryFilters => 'Filtreler';

  @override
  String get libraryClose => 'Kapat';

  @override
  String get libraryEmptyTitle => 'Henüz video yok';

  @override
  String get libraryAccessOff => 'Fotoğraflar erişimi kapalı';

  @override
  String get libraryNoMatches => 'Eşleşen video yok';

  @override
  String get librarySearchHelp => 'Başka bir başlık dene veya aramayı temizle.';

  @override
  String get libraryNoFilterMatches => 'Bu filtrelere uyan video yok';

  @override
  String get libraryFilterHelp =>
      'Tüm videolarını görmek için filtreleri temizle.';

  @override
  String get libraryUnknownDate => 'Tarih bilinmiyor';

  @override
  String get libraryDeleteFailed => 'RollReel videoyu silemedi.';

  @override
  String libraryDeviceCount(int count) {
    return 'Bu cihazda $count video';
  }

  @override
  String libraryMemoriesCount(int count) {
    return 'Geçmiş yıllardan $count video';
  }

  @override
  String libraryVideoOptions(String title) {
    return '$title seçenekleri';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => 'Henüz favori yok';

  @override
  String get favoritesEmptyBody =>
      'Bir video izlerken kalbe dokunarak videoyu buraya kaydedebilirsin.';

  @override
  String get goToLibrary => 'Arşive göz at';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'Video ara…';

  @override
  String get videosTitle => 'Videolar';

  @override
  String videosCount(int count) {
    return '$count Video';
  }

  @override
  String get yourLibrary => 'Arşivin';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Yerel';

  @override
  String get noResults => 'Sonuç Yok';

  @override
  String get noVideosFound => 'Video Bulunamadı';

  @override
  String noSearchMatches(String query) {
    return '\"$query\" ile eşleşen video yok.';
  }

  @override
  String get tryDifferentFilter => 'Farklı bir filtre dene.';

  @override
  String get clearSearch => 'Aramayı Temizle';

  @override
  String get clearFilters => 'Filtreleri Temizle';

  @override
  String get filter => 'Filtre';

  @override
  String get reset => 'Sıfırla';

  @override
  String get timePeriod => 'ZAMAN ARALIĞI';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String get duration => 'SÜRE';

  @override
  String get any => 'Tümü';

  @override
  String get durationShort => '< 1 dk';

  @override
  String get durationMedium => '1–5 dk';

  @override
  String get durationLong => '> 5 dk';

  @override
  String get sortBy => 'SIRALA';

  @override
  String get newestFirst => 'Önce En Yeni';

  @override
  String get oldestFirst => 'Önce En Eski';

  @override
  String get shortestFirst => 'Önce En Kısa';

  @override
  String get longestFirst => 'Önce En Uzun';

  @override
  String get applyFilters => 'Filtreleri Uygula';

  @override
  String get onThisDay => 'Geçmişte Bugün';

  @override
  String onThisDaySubtitleOne(String years) {
    return '$years 1 anı';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return 'Geçmiş yıllardan $count anı';
  }

  @override
  String get yearsAgoOne => '1 yıl önce';

  @override
  String yearsAgoMany(int years) {
    return '$years yıl önce';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'Geçmişte Bugün · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current / $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'Anılar yüklenemedi: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'Videolar yüklenemedi: $error';
  }

  @override
  String get settings => 'Ayarlar';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favoriler';

  @override
  String get playbackSection => 'Oynatma';

  @override
  String get loopShortVideos => 'Kısa Videoları Döngüye Al';

  @override
  String get loopShortVideosSub => '30 saniyeden kısa klipleri tekrarla';

  @override
  String get autoPlayOnLaunch => 'Açılışta Otomatik Oynat';

  @override
  String get autoPlayOnLaunchSub => 'Akış açıldığında oynatmaya başla';

  @override
  String get defaultFilter => 'Varsayılan Filtre';

  @override
  String get defaultFilterSub => 'Akışta nelerin görüneceğini seç';

  @override
  String get appearanceSection => 'Görünüm';

  @override
  String get darkMode => 'Koyu Mod';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Tarih Etiketlerini Göster';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Süre Rozetlerini Göster';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'Gi̇zli̇li̇k';

  @override
  String get privacyVault => 'Gizli Kasa';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'Hakkinda';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get privacyPolicyBody =>
      'RollReel videolarını cihazının dışına yüklemez, iletmez veya depolamaz. Hesap gerekmez. Hiçbir kişisel veri üçüncü taraflarla paylaşılmaz.';

  @override
  String get rateApp => 'RollReel\'i Değerlendir';

  @override
  String get shareApp => 'RollReel\'i Paylaş';

  @override
  String get version => 'Sürüm';

  @override
  String get settingsFilterDescription =>
      'Akışı açtığında hangi videoları göreceğini seç.';

  @override
  String get settingsProDescription => 'Reklamsız oynatma ve Gizli Kasa';

  @override
  String get settingsProActive => 'Pro etkin';

  @override
  String get settingsVaultDescription => 'Özel videolarını aç';

  @override
  String get settingsRestoreComplete =>
      'Önceki satın alımların kontrolü tamamlandı.';

  @override
  String get settingsRestoreFailed =>
      'Satın alımlar geri yüklenemedi. Tekrar dene.';

  @override
  String get proCardSubtitle => 'Reklamsız · Kasa · Hız · Koleksiyonlar';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'RollReel\'i keşfet – kamera rulondaki videoları %100 çevrimdışı kaydır!';

  @override
  String get vaultTitle => 'Gizli Kasa';

  @override
  String get vaultLocked => 'Kasa Kilitli';

  @override
  String get vaultLockedSubtitle => 'Gizli videoların burada güvende';

  @override
  String get unlockWithFaceId => 'Face ID ile Aç';

  @override
  String get unlockVaultReason => 'Gizli Kasanı aç';

  @override
  String get faceIdUnavailable => 'Face ID bu cihazda kullanılamıyor.';

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
  String get authFailed => 'Kimlik doğrulama başarısız. Lütfen tekrar dene.';

  @override
  String get vaultLoadFailed => 'Kasa yüklenemedi';

  @override
  String get vaultEmpty => 'Kasa boş';

  @override
  String get vaultEmptyHint =>
      'Eklemek için herhangi bir videoda ••• simgesine dokun';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'Kasadan kaldırılsın mı?';

  @override
  String get removeFromVaultBody => 'Bu video ana arşivine geri dönecek.';

  @override
  String get vaultRecoveryLocked =>
      'Videolarını arşive geri almak için kasanın kilidini aç.';

  @override
  String get vaultReturnAll => 'Videoları arşive geri al';

  @override
  String get vaultRecoveryBody =>
      'Kasadaki videoları istediğin zaman arşive geri alabilirsin.';

  @override
  String get vaultRecoveryConfirm =>
      'Kasadaki tüm videolar RollReel arşivinde tekrar görünecek.';

  @override
  String get vaultRecoveryDone => 'Videolar arşive geri alındı.';

  @override
  String get vaultUpdateFailed => 'Kasa güncellenemedi. Tekrar dene.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallPlaybackTitle => 'İzlemeye devam et.';

  @override
  String get paywallPlaybackBody => 'Videolarını reklam arası olmadan izle.';

  @override
  String get paywallVaultTitle => 'Sadece sana özel.';

  @override
  String get paywallVaultBody => 'Özel videoların için kilitli bir alan.';

  @override
  String get paywallMemoriesTitle => 'Bugünü yeniden yaşa.';

  @override
  String get paywallMemoriesBody =>
      'Geçmiş yıllarda bugün çektiğin videoları bul.';

  @override
  String get paywallSpeedTitle => 'Kendi hızında izle.';

  @override
  String get paywallAdFree => 'Reklamsız oynatma';

  @override
  String get paywallAdFreeBody => 'Klipleri reklam arası olmadan tekrar izle';

  @override
  String get paywallVaultBenefit => 'Seçtiğin klipleri kilitle';

  @override
  String get paywallSpeed => '2× hız için basılı tut';

  @override
  String get paywallSpeedBenefit => 'İleri sarmak için basılı tut';

  @override
  String get paywallMemoriesBenefit =>
      'Geçmiş yıllardan klipleri yeniden keşfet';

  @override
  String get paywallChoosePlan => 'Bir plan seç';

  @override
  String get paywallLifetime => 'Ömür boyu';

  @override
  String get paywallMonthly => 'Aylık';

  @override
  String get paywallRenewsMonthly => 'Her ay otomatik yenilenir';

  @override
  String get paywallGetLifetime => 'Ömür boyu erişim al';

  @override
  String get paywallSubscribeMonthly => 'Aylık abone ol';

  @override
  String paywallMonthlyPrice(String price) {
    return '$price/ay';
  }

  @override
  String paywallLifetimeBilling(String price) {
    return 'Tek seferlik $price ödemesi. Abonelik yok.';
  }

  @override
  String paywallMonthlyBilling(String price) {
    return '$price/ay. Her ay otomatik yenilenir. App Store ayarlarından iptal edebilirsin.';
  }

  @override
  String get paywallLoadingPrices => 'Fiyatlar yükleniyor…';

  @override
  String get paywallPricesUnavailable => 'Planlar kullanılamıyor';

  @override
  String get paywallLinkUnavailable => 'Bağlantı açılamadı. Tekrar dene.';

  @override
  String get paywallTagline => 'Daha fazla izle. Dert etme.';

  @override
  String get featureAdFree => 'Reklamsız Deneyim';

  @override
  String get featureAdFreeSub => 'Kesinti yok, asla';

  @override
  String get featureVault => 'Gizli Kasa';

  @override
  String get featureVaultSub => 'Hassas videoları Face ID ile kilitle';

  @override
  String get featureSpeed => 'Oynatma Hızı Kontrolü';

  @override
  String get featureSpeedSub => 'Basılı tutunca 2× ileri sarma';

  @override
  String get featureOnThisDay => 'Geçmişte Bugün';

  @override
  String get featureOnThisDaySub => 'Geçmiş yılların videolarını yeniden yaşa';

  @override
  String get unlockPro => 'RollReel Pro\'nun Kilidini Aç';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'Artık Pro\'sun!';

  @override
  String get lifetimeFooter => 'Tek seferlik satın alma · Abonelik yok';

  @override
  String get monthlyFooter =>
      'Aylık otomatik yenilenir · İstediğin zaman iptal et';

  @override
  String get restorePurchases => 'Satın Alımları Geri Yükle';

  @override
  String get subscriptionDisclaimer =>
      'Ödeme Apple Kimliğinden tahsil edilir. Abonelik, dönem bitiminden 24 saat önce iptal edilmezse otomatik olarak yenilenir.';

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
  String get termsOfUse => 'Kullanım Koşulları (EULA)';

  @override
  String get lifetimeAccess => 'Ömür Boyu Erişim';

  @override
  String get foundingMember => 'Kurucu üye';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'Bu plan şu anda kullanılamıyor. Lütfen daha sonra tekrar dene.';

  @override
  String get purchaseFailed => 'Satın alma başarısız';

  @override
  String get active => 'ETKİN';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Tekrar Dene';
}

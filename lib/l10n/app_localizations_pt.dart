// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get watchNext => 'Assistir a seguir';

  @override
  String get seeAll => 'Ver tudo';

  @override
  String get homeRecordedToday => 'Vídeos gravados hoje';

  @override
  String get homePlays => 'Reproduções';

  @override
  String get homeWatchActivity => 'Atividade de visualização';

  @override
  String get homeWatchStreak => 'Dias seguidos assistindo';

  @override
  String get homeMostWatched => 'Mais assistidos';

  @override
  String get homeTopFolders => 'Pastas principais';

  @override
  String get homeVideoRecap => 'Resumo de vídeos';

  @override
  String get homeRecordedThisYear => 'Vídeos gravados este ano';

  @override
  String get homeNoWatchHistory =>
      'O RollReel ainda não registra o histórico de visualização.';

  @override
  String get homeFolderDetailsUnavailable =>
      'Os detalhes das pastas não estão disponíveis para esta fototeca.';

  @override
  String get homeUnavailable => 'Indisponível';

  @override
  String get homeLoading => 'Carregando…';

  @override
  String get homeCameraRoll => 'Seus\nvídeos';

  @override
  String get homeWatchTab => 'Assistir';

  @override
  String get homeActivityTab => 'Atividade';

  @override
  String get homeYourActivity => 'Sua atividade';

  @override
  String get homeEmptyTitle => 'Seu primeiro vídeo começa aqui';

  @override
  String get homeEmptyBody =>
      'Grave um vídeo com a câmera. Ele estará aqui quando você voltar.';

  @override
  String get homeOpenCamera => 'Abrir câmera';

  @override
  String get homeCaptureFailed =>
      'O RollReel não conseguiu gravar ou salvar o vídeo.';

  @override
  String get homeAccessTitle => 'Escolha seus vídeos';

  @override
  String get homeAccessBody =>
      'Permita o acesso ao app Fotos nos Ajustes para assistir aos seus vídeos.';

  @override
  String get homeLoadFailed => 'Não foi possível carregar seus vídeos';

  @override
  String get homeLoadFailedBody =>
      'Sua biblioteca talvez ainda esteja sincronizando. Tente de novo.';

  @override
  String get homeNoMemories => 'Nenhum vídeo desta data em anos anteriores.';

  @override
  String homePlayClip(String title) {
    return 'Reproduzir $title';
  }

  @override
  String get homePlaybackFailed => 'Não foi possível reproduzir este vídeo.';

  @override
  String get homePause => 'Pausar';

  @override
  String get homePlay => 'Reproduzir';

  @override
  String get onboardingTitle => 'Volte ao seu\nrolo da câmera.';

  @override
  String get onboardingSwipeTitle => 'Deslize para cima\npara o próximo vídeo.';

  @override
  String get onboardingSwipeSubtitle => 'Experimente na prévia abaixo.';

  @override
  String get onboardingTrySwipe => 'Experimente deslizar';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Vídeo de exemplo $current de $total';
  }

  @override
  String get onboardingNextSample => 'Mostrar o próximo vídeo de exemplo';

  @override
  String get onboardingLimitedTitle => 'Escolha vídeos específicos';

  @override
  String get onboardingLimitedBody =>
      'No seletor do sistema, escolha os itens que o RollReel pode ver.';

  @override
  String get onboardingFullTitle => 'Permita a biblioteca inteira';

  @override
  String get onboardingFullBody =>
      'Explore todos os vídeos. Você pode alterar o acesso nos Ajustes.';

  @override
  String get onboardingChooseVideos => 'Escolher vídeos';

  @override
  String get onboardingNotNow => 'Agora não';

  @override
  String get onboardingSubtitle =>
      'Reveja os pequenos momentos que você gravou, um vídeo de cada vez.';

  @override
  String get onboardingPrivacyBody =>
      'Seus vídeos são reproduzidos no seu dispositivo. Você não precisa criar uma conta nem enviar a biblioteca.';

  @override
  String get onboardingPermissionBody =>
      'Permita o acesso à fototeca para que o RollReel possa encontrar e reproduzir seus vídeos.';

  @override
  String get onboardingAccessBody =>
      'O RollReel acessa o app Fotos para mostrar os vídeos do seu rolo da câmera.';

  @override
  String get onboardingPermissionNote =>
      'Você pode alterar o acesso a qualquer momento nos Ajustes.';

  @override
  String get onboardingPermissionError =>
      'Não foi possível solicitar acesso. Tente novamente ou pule esta etapa.';

  @override
  String onboardingStep(int step, int total) {
    return 'Etapa $step de $total';
  }

  @override
  String get onboardingPrivacyTitle => 'Só para você.';

  @override
  String get onboardingPermissionTitle => 'Quais vídeos\npodemos reproduzir?';

  @override
  String get onboardingNoCloud => 'Sem nuvem';

  @override
  String get onboardingNoAccount => 'Sem conta';

  @override
  String get onboardingNoTracking => 'Sem rastreamento';

  @override
  String get swipeHint => 'DESLIZE';

  @override
  String get skip => 'Pular';

  @override
  String get getStarted => 'Começar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get requesting => 'Solicitando…';

  @override
  String get allowAccess => 'Permitir acesso';

  @override
  String get noVideosYetTitle => 'Nenhum vídeo ainda';

  @override
  String get noVideosYetBody =>
      'Os vídeos do seu rolo da câmera aparecerão aqui.';

  @override
  String get openPhotosApp => 'Abrir app Fotos';

  @override
  String get loadingLibrary => 'Carregando sua biblioteca...';

  @override
  String get permissionDeniedTitle => 'O acesso ao app\nFotos está desativado.';

  @override
  String get permissionDeniedBody =>
      'Escolha vídeos nos Ajustes quando quiser. Você ainda pode explorar o RollReel.';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get continueAnyway => 'Continuar mesmo assim';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Voltar';

  @override
  String get remove => 'Remover';

  @override
  String get manage => 'Gerenciar';

  @override
  String get videoFallbackTitle => 'Vídeo';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterToday => 'Hoje';

  @override
  String get filterShorts => 'Curtos';

  @override
  String get filterLong => 'Longos';

  @override
  String get filterRecent => 'Recentes';

  @override
  String get videoDeleted => 'Vídeo apagado';

  @override
  String get getInfo => 'Ver informações';

  @override
  String get addToVault => 'Adicionar ao cofre';

  @override
  String get removeFromVault => 'Remover do cofre';

  @override
  String get deleteVideo => 'Apagar vídeo';

  @override
  String get deleteVideoWarning =>
      'Isto apagará permanentemente o vídeo da sua biblioteca.';

  @override
  String get thisVideo => 'Este vídeo';

  @override
  String get share => 'Compartilhar';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Expandir';

  @override
  String get photoLibraryAccess => 'Acesso à fototeca';

  @override
  String get limitedAccessMessage =>
      'Você está compartilhando uma seleção limitada de vídeos.';

  @override
  String get selectMoreVideos => 'Selecionar mais vídeos';

  @override
  String get allowFullAccess => 'Permitir acesso total';

  @override
  String managingCount(int count) {
    return 'Gerenciando $count dos seus vídeos';
  }

  @override
  String get infoDate => 'Data';

  @override
  String get infoDuration => 'Duração';

  @override
  String get infoResolution => 'Resolução';

  @override
  String get infoFileSize => 'Tamanho';

  @override
  String get infoFormat => 'Formato';

  @override
  String get feed => 'Feed';

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
  String get searchVideos => 'Buscar vídeos…';

  @override
  String get videosTitle => 'Vídeos';

  @override
  String videosCount(int count) {
    return '$count vídeos';
  }

  @override
  String get yourLibrary => 'Sua biblioteca';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Local';

  @override
  String get noResults => 'Sem resultados';

  @override
  String get noVideosFound => 'Nenhum vídeo encontrado';

  @override
  String noSearchMatches(String query) {
    return 'Nenhum vídeo corresponde a \"$query\".';
  }

  @override
  String get tryDifferentFilter => 'Tente outro filtro.';

  @override
  String get clearSearch => 'Limpar busca';

  @override
  String get clearFilters => 'Limpar filtros';

  @override
  String get filter => 'Filtrar';

  @override
  String get reset => 'Redefinir';

  @override
  String get timePeriod => 'PERÍODO';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mês';

  @override
  String get duration => 'DURAÇÃO';

  @override
  String get any => 'Qualquer';

  @override
  String get durationShort => '< 1 min';

  @override
  String get durationMedium => '1–5 min';

  @override
  String get durationLong => '> 5 min';

  @override
  String get sortBy => 'ORDENAR POR';

  @override
  String get newestFirst => 'Mais recentes primeiro';

  @override
  String get oldestFirst => 'Mais antigos primeiro';

  @override
  String get shortestFirst => 'Mais curtos primeiro';

  @override
  String get longestFirst => 'Mais longos primeiro';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get onThisDay => 'Neste dia';

  @override
  String onThisDaySubtitleOne(String years) {
    return '1 memória de $years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '$count memórias de anos anteriores';
  }

  @override
  String get yearsAgoOne => 'Há 1 ano';

  @override
  String yearsAgoMany(int years) {
    return 'Há $years anos';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'Neste dia · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current de $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'Não foi possível carregar as memórias: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'Não foi possível carregar os vídeos: $error';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favorites';

  @override
  String get playbackSection => 'REPRODUÇÃO';

  @override
  String get loopShortVideos => 'Repetir vídeos curtos';

  @override
  String get loopShortVideosSub => 'Automatically loop to the next video';

  @override
  String get autoPlayOnLaunch => 'Reproduzir ao abrir';

  @override
  String get autoPlayOnLaunchSub => 'Start playing videos automatically';

  @override
  String get defaultFilter => 'Filtro padrão';

  @override
  String get defaultFilterSub => 'Set your default video filter';

  @override
  String get appearanceSection => 'APARÊNCIA';

  @override
  String get darkMode => 'Modo escuro';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Mostrar datas';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Mostrar duração';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'PRIVACIDADE';

  @override
  String get privacyVault => 'Cofre de privacidade';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'SOBRE';

  @override
  String get privacyPolicy => 'Política de Privacidade';

  @override
  String get privacyPolicyBody =>
      'O RollReel não envia, transmite nem armazena nenhum dos seus vídeos fora do seu dispositivo. Nenhuma conta é necessária. Nenhum dado pessoal é compartilhado com terceiros.';

  @override
  String get rateApp => 'Avaliar o RollReel';

  @override
  String get shareApp => 'Compartilhar o RollReel';

  @override
  String get version => 'Versão';

  @override
  String get proCardSubtitle => 'Sem anúncios · Cofre · Velocidade · Coleções';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'Conheça o RollReel – deslize pelos vídeos do seu rolo da câmera, 100% offline!';

  @override
  String get vaultTitle => 'Cofre privado';

  @override
  String get vaultLocked => 'Cofre bloqueado';

  @override
  String get vaultLockedSubtitle => 'Seus vídeos privados estão seguros aqui';

  @override
  String get unlockWithFaceId => 'Desbloquear com Face ID';

  @override
  String get unlockVaultReason => 'Desbloqueie seu cofre privado';

  @override
  String get faceIdUnavailable =>
      'O Face ID não está disponível neste dispositivo.';

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
  String get authFailed => 'Falha na autenticação. Tente novamente.';

  @override
  String get vaultLoadFailed => 'Falha ao carregar o cofre';

  @override
  String get vaultEmpty => 'O cofre está vazio';

  @override
  String get vaultEmptyHint =>
      'Toque em ••• em qualquer vídeo para adicioná-lo aqui';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => 'Remover do cofre?';

  @override
  String get removeFromVaultBody =>
      'Este vídeo voltará à sua biblioteca principal.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallTagline => 'Assista mais. Preocupe-se menos.';

  @override
  String get featureAdFree => 'Experiência sem anúncios';

  @override
  String get featureAdFreeSub => 'Sem interrupções, nunca';

  @override
  String get featureVault => 'Cofre de privacidade';

  @override
  String get featureVaultSub => 'Proteja vídeos sensíveis com Face ID';

  @override
  String get featureSpeed => 'Controle de velocidade';

  @override
  String get featureSpeedSub => 'Avanço rápido 2× ao manter pressionado';

  @override
  String get featureOnThisDay => 'Neste dia';

  @override
  String get featureOnThisDaySub => 'Reviva vídeos de anos anteriores';

  @override
  String get unlockPro => 'Desbloquear o RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => 'Você é Pro!';

  @override
  String get lifetimeFooter => 'Compra única · Sem assinatura';

  @override
  String get monthlyFooter =>
      'Renovação mensal automática · Cancele quando quiser';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get subscriptionDisclaimer =>
      'O pagamento é cobrado no Apple ID. A assinatura é renovada automaticamente, a menos que seja cancelada 24 h antes do fim do período.';

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
  String get termsOfUse => 'Termos de Uso (EULA)';

  @override
  String get lifetimeAccess => 'Acesso vitalício';

  @override
  String get foundingMember => 'Membro fundador';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'Este plano não está disponível no momento. Tente novamente mais tarde.';

  @override
  String get purchaseFailed => 'Falha na compra';

  @override
  String get active => 'ATIVO';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Tentar novamente';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get watchNext => 'Para ver ahora';

  @override
  String get seeAll => 'Ver todo';

  @override
  String get homeRecordedToday => 'Vídeos grabados hoy';

  @override
  String get homePlays => 'Reproducciones';

  @override
  String get homeWatchActivity => 'Actividad de visualización';

  @override
  String get homeWatchStreak => 'Racha de visualización';

  @override
  String get homeMostWatched => 'Más vistos';

  @override
  String get homeTopFolders => 'Carpetas destacadas';

  @override
  String get homeVideoRecap => 'Resumen de vídeos';

  @override
  String get homeRecordedThisYear => 'Vídeos grabados este año';

  @override
  String get homeNoWatchHistory =>
      'RollReel todavía no guarda el historial de visualización.';

  @override
  String get homeFolderDetailsUnavailable =>
      'Los detalles de las carpetas no están disponibles para esta fototeca.';

  @override
  String get homeUnavailable => 'No disponible';

  @override
  String get homeLoading => 'Cargando…';

  @override
  String get homeCameraRoll => 'Tus\nvídeos';

  @override
  String get homeWatchTab => 'Ver';

  @override
  String get homeActivityTab => 'Actividad';

  @override
  String get homeYourActivity => 'Tu actividad';

  @override
  String get homeEmptyTitle => 'Tu primer vídeo empieza aquí';

  @override
  String get homeEmptyBody =>
      'Graba un vídeo con tu cámara. Lo verás aquí cuando vuelvas.';

  @override
  String get homeOpenCamera => 'Abrir cámara';

  @override
  String get homeCaptureFailed => 'RollReel no pudo grabar o guardar el vídeo.';

  @override
  String get homeAccessTitle => 'Elige tus vídeos';

  @override
  String get homeAccessBody =>
      'Permite el acceso a Fotos en Ajustes para ver los vídeos de tu carrete.';

  @override
  String get homeLoadFailed => 'No se pudieron cargar tus vídeos';

  @override
  String get homeLoadFailedBody =>
      'Puede que tu carrete aún se esté sincronizando. Inténtalo de nuevo.';

  @override
  String get homeNoMemories =>
      'No hay vídeos de esta fecha en años anteriores.';

  @override
  String homePlayClip(String title) {
    return 'Reproducir $title';
  }

  @override
  String get homePlaybackFailed => 'No se pudo reproducir este vídeo.';

  @override
  String get homePause => 'Pausar';

  @override
  String get homePlay => 'Reproducir';

  @override
  String get onboardingTitle => 'Vuelve a tu\ncarrete.';

  @override
  String favoritesSavedCount(int count) {
    return '$count guardados';
  }

  @override
  String favoritesRemoveVideo(String title) {
    return 'Quitar $title de Favoritos';
  }

  @override
  String get favoritesRemoved => 'Quitado de Favoritos';

  @override
  String get favoritesUndo => 'Deshacer';

  @override
  String get favoritesLoadFailed => 'No se pudieron cargar los favoritos';

  @override
  String get favoritesRetryBody =>
      'Intenta cargar tus vídeos guardados de nuevo.';

  @override
  String get favoritesAccessBody =>
      'Permite el acceso a Fotos para ver tus vídeos guardados.';

  @override
  String get favoritesUpdateFailed =>
      'No se pudieron actualizar los favoritos.';

  @override
  String get onboardingSwipeTitle =>
      'Desliza hacia arriba\npara ver otro vídeo.';

  @override
  String get onboardingSwipeSubtitle => 'Pruébalo en la vista previa.';

  @override
  String get onboardingTrySwipe => 'Prueba a deslizar';

  @override
  String onboardingSampleClip(int current, int total) {
    return 'Vídeo de ejemplo $current de $total';
  }

  @override
  String get onboardingNextSample => 'Ver el siguiente vídeo de ejemplo';

  @override
  String get onboardingLimitedTitle => 'Elige vídeos concretos';

  @override
  String get onboardingLimitedBody =>
      'Selecciona en el sistema qué elementos puede ver RollReel.';

  @override
  String get onboardingFullTitle => 'Permite toda la biblioteca';

  @override
  String get onboardingFullBody =>
      'Explora todos tus vídeos. Puedes cambiar el acceso en Ajustes.';

  @override
  String get onboardingChooseVideos => 'Elegir vídeos';

  @override
  String get onboardingNotNow => 'Ahora no';

  @override
  String get onboardingSubtitle =>
      'Revive los pequeños momentos que grabaste, un vídeo a la vez.';

  @override
  String get onboardingPrivacyBody =>
      'Tus vídeos se reproducen en tu dispositivo. No tienes que crear una cuenta ni subir tu biblioteca.';

  @override
  String get onboardingPermissionBody =>
      'Permite el acceso a tu fototeca para que RollReel pueda encontrar y reproducir tus vídeos.';

  @override
  String get onboardingAccessBody =>
      'RollReel usa el acceso a Fotos para mostrar los vídeos del carrete.';

  @override
  String get onboardingPermissionNote =>
      'Puedes cambiar el acceso en Ajustes en cualquier momento.';

  @override
  String get onboardingPermissionError =>
      'No se pudo solicitar el acceso. Inténtalo de nuevo u omite este paso.';

  @override
  String onboardingStep(int step, int total) {
    return 'Paso $step de $total';
  }

  @override
  String get onboardingPrivacyTitle => 'Solo para ti.';

  @override
  String get onboardingPermissionTitle => '¿Qué vídeos\npodemos reproducir?';

  @override
  String get onboardingNoCloud => 'Sin nube';

  @override
  String get onboardingNoAccount => 'Sin cuenta';

  @override
  String get onboardingNoTracking => 'Sin rastreo';

  @override
  String get swipeHint => 'DESLIZA';

  @override
  String get skip => 'Omitir';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get continueLabel => 'Continuar';

  @override
  String get requesting => 'Solicitando…';

  @override
  String get allowAccess => 'Permitir acceso';

  @override
  String get noVideosYetTitle => 'Aún no hay videos';

  @override
  String get noVideosYetBody => 'Los videos de tu carrete aparecerán aquí.';

  @override
  String get openPhotosApp => 'Abrir app Fotos';

  @override
  String get loadingLibrary => 'Cargando tu biblioteca...';

  @override
  String get permissionDeniedTitle => 'El acceso a Fotos\nestá desactivado.';

  @override
  String get permissionDeniedBody =>
      'Elige tus vídeos en Ajustes cuando quieras. Puedes seguir explorando RollReel.';

  @override
  String get openSettings => 'Abrir Ajustes';

  @override
  String get continueAnyway => 'Continuar de todos modos';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get back => 'Atrás';

  @override
  String get remove => 'Eliminar';

  @override
  String get manage => 'Gestionar';

  @override
  String get videoFallbackTitle => 'Video';

  @override
  String get filterAll => 'Todos';

  @override
  String get filterToday => 'Hoy';

  @override
  String get filterShorts => 'Cortos';

  @override
  String get filterLong => 'Largos';

  @override
  String get filterRecent => 'Recientes';

  @override
  String get videoDeleted => 'Video eliminado';

  @override
  String get getInfo => 'Obtener información';

  @override
  String get addToVault => 'Añadir a la bóveda';

  @override
  String get removeFromVault => 'Quitar de la bóveda';

  @override
  String get deleteVideo => 'Eliminar video';

  @override
  String get deleteVideoWarning =>
      'Esto eliminará permanentemente el video de tu biblioteca.';

  @override
  String get thisVideo => 'Este video';

  @override
  String get share => 'Compartir';

  @override
  String get like => 'Like';

  @override
  String get expand => 'Expandir';

  @override
  String get photoLibraryAccess => 'Acceso a la fototeca';

  @override
  String get limitedAccessMessage =>
      'Actualmente compartes una selección limitada de videos.';

  @override
  String get selectMoreVideos => 'Seleccionar más videos';

  @override
  String get allowFullAccess => 'Permitir acceso completo';

  @override
  String managingCount(int count) {
    return 'Gestionando $count de tus videos';
  }

  @override
  String get infoDate => 'Fecha';

  @override
  String get infoDuration => 'Duración';

  @override
  String get infoResolution => 'Resolución';

  @override
  String get infoFileSize => 'Tamaño';

  @override
  String get infoFormat => 'Formato';

  @override
  String get feed => 'Feed';

  @override
  String get library => 'Biblioteca';

  @override
  String get libraryFilters => 'Filtros';

  @override
  String get libraryClose => 'Cerrar';

  @override
  String get libraryEmptyTitle => 'Todavía no hay vídeos';

  @override
  String get libraryAccessOff => 'El acceso a Fotos está desactivado';

  @override
  String get libraryNoMatches => 'No hay vídeos que coincidan';

  @override
  String get librarySearchHelp => 'Prueba con otro título o borra la búsqueda.';

  @override
  String get libraryNoFilterMatches =>
      'Ningún vídeo coincide con estos filtros';

  @override
  String get libraryFilterHelp =>
      'Borra los filtros para ver todos tus vídeos.';

  @override
  String get libraryUnknownDate => 'Fecha desconocida';

  @override
  String get libraryDeleteFailed => 'RollReel no pudo eliminar el vídeo.';

  @override
  String libraryDeviceCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vídeos',
      one: '1 vídeo',
    );
    return '$_temp0 en este dispositivo';
  }

  @override
  String libraryMemoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vídeos',
      one: '1 vídeo',
    );
    return '$_temp0 de años anteriores';
  }

  @override
  String libraryVideoOptions(String title) {
    return 'Opciones para $title';
  }

  @override
  String libraryVideoRow(String title, String date, String duration) {
    return '$title · $date · $duration';
  }

  @override
  String get favoritesEmptyTitle => 'Todavía no hay favoritos';

  @override
  String get favoritesEmptyBody =>
      'Toca el corazón mientras ves un vídeo para guardarlo aquí.';

  @override
  String get goToLibrary => 'Ver biblioteca';

  @override
  String get infoTab => 'Info';

  @override
  String get searchVideos => 'Buscar videos…';

  @override
  String get videosTitle => 'Videos';

  @override
  String videosCount(int count) {
    return '$count videos';
  }

  @override
  String get yourLibrary => 'Tu biblioteca';

  @override
  String get libraryTitle => 'Library';

  @override
  String get librarySubtitle => 'Your personal video collection';

  @override
  String get totalInLibrary => 'Total in your library';

  @override
  String get localBadge => 'Local';

  @override
  String get noResults => 'Sin resultados';

  @override
  String get noVideosFound => 'No se encontraron videos';

  @override
  String noSearchMatches(String query) {
    return 'Ningún video coincide con \"$query\".';
  }

  @override
  String get tryDifferentFilter => 'Prueba con otro filtro.';

  @override
  String get clearSearch => 'Borrar búsqueda';

  @override
  String get clearFilters => 'Borrar filtros';

  @override
  String get filter => 'Filtrar';

  @override
  String get reset => 'Restablecer';

  @override
  String get timePeriod => 'PERÍODO';

  @override
  String get thisWeek => 'Esta semana';

  @override
  String get thisMonth => 'Este mes';

  @override
  String get duration => 'DURACIÓN';

  @override
  String get any => 'Cualquiera';

  @override
  String get durationShort => '< 1 min';

  @override
  String get durationMedium => '1–5 min';

  @override
  String get durationLong => '> 5 min';

  @override
  String get sortBy => 'ORDENAR POR';

  @override
  String get newestFirst => 'Más recientes primero';

  @override
  String get oldestFirst => 'Más antiguos primero';

  @override
  String get shortestFirst => 'Más cortos primero';

  @override
  String get longestFirst => 'Más largos primero';

  @override
  String get applyFilters => 'Aplicar filtros';

  @override
  String get onThisDay => 'Tal día como hoy';

  @override
  String onThisDaySubtitleOne(String years) {
    return '1 recuerdo de $years';
  }

  @override
  String onThisDaySubtitleMany(int count) {
    return '$count recuerdos de años pasados';
  }

  @override
  String get yearsAgoOne => 'Hace 1 año';

  @override
  String yearsAgoMany(int years) {
    return 'Hace $years años';
  }

  @override
  String onThisDayHeader(String yearsAgo) {
    return 'Tal día como hoy · $yearsAgo';
  }

  @override
  String positionCounter(int current, int total) {
    return '$current de $total';
  }

  @override
  String couldNotLoadMemories(String error) {
    return 'No se pudieron cargar los recuerdos: $error';
  }

  @override
  String couldNotLoadVideos(String error) {
    return 'No se pudieron cargar los videos: $error';
  }

  @override
  String get settings => 'Ajustes';

  @override
  String get home => 'Home';

  @override
  String get favorites => 'Favoritos';

  @override
  String get playbackSection => 'REPRODUCCIÓN';

  @override
  String get loopShortVideos => 'Repetir videos cortos';

  @override
  String get loopShortVideosSub => 'Automatically loop to the next video';

  @override
  String get autoPlayOnLaunch => 'Reproducir al abrir';

  @override
  String get autoPlayOnLaunchSub => 'Start playing videos automatically';

  @override
  String get defaultFilter => 'Filtro predeterminado';

  @override
  String get defaultFilterSub => 'Set your default video filter';

  @override
  String get appearanceSection => 'APARIENCIA';

  @override
  String get darkMode => 'Modo oscuro';

  @override
  String get darkModeSub => 'Use dark theme for the app';

  @override
  String get showDateLabels => 'Mostrar fechas';

  @override
  String get showDateLabelsSub => 'Display date on video thumbnails';

  @override
  String get showDurationBadges => 'Mostrar duración';

  @override
  String get showDurationBadgesSub => 'Show video duration on thumbnails';

  @override
  String get privacySection => 'PRIVACIDAD';

  @override
  String get privacyVault => 'Bóveda privada';

  @override
  String get privacySettingsTitle => 'Privacy Settings';

  @override
  String get privacySettingsSub => 'Manage your data and permissions';

  @override
  String get proBadge => 'Pro';

  @override
  String get aboutSection => 'ACERCA DE';

  @override
  String get privacyPolicy => 'Política de privacidad';

  @override
  String get privacyPolicyBody =>
      'RollReel no sube, transmite ni almacena ninguno de tus videos fuera de tu dispositivo. No se requiere cuenta. No se comparten datos personales con terceros.';

  @override
  String get rateApp => 'Calificar RollReel';

  @override
  String get shareApp => 'Compartir RollReel';

  @override
  String get version => 'Versión';

  @override
  String get proCardSubtitle =>
      'Sin anuncios · Bóveda · Velocidad · Colecciones';

  @override
  String get proCardTagline => 'Elevate your viewing experience';

  @override
  String get shareAppMessage =>
      'Mira RollReel: desliza por los videos de tu carrete, ¡100% sin conexión!';

  @override
  String get vaultTitle => 'Bóveda privada';

  @override
  String get vaultLocked => 'Bóveda bloqueada';

  @override
  String get vaultLockedSubtitle => 'Tus videos privados están seguros aquí';

  @override
  String get unlockWithFaceId => 'Desbloquear con Face ID';

  @override
  String get unlockVaultReason => 'Desbloquea tu bóveda privada';

  @override
  String get faceIdUnavailable =>
      'Face ID no está disponible en este dispositivo.';

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
  String get authFailed => 'Falló la autenticación. Inténtalo de nuevo.';

  @override
  String get vaultLoadFailed => 'No se pudo cargar la bóveda';

  @override
  String get vaultEmpty => 'La bóveda está vacía';

  @override
  String get vaultEmptyHint => 'Toca ••• en cualquier video para añadirlo aquí';

  @override
  String get vaultEmptySubtitle =>
      'Keep your private videos safe and secure in one place.';

  @override
  String get addVideosToVault => 'Add Videos to Vault';

  @override
  String get howItWorks => 'How it works';

  @override
  String get removeFromVaultTitle => '¿Quitar de la bóveda?';

  @override
  String get removeFromVaultBody =>
      'Este video volverá a tu biblioteca principal.';

  @override
  String get paywallTitle => 'RollReel Pro';

  @override
  String get paywallTagline => 'Mira más. Preocúpate menos.';

  @override
  String get featureAdFree => 'Experiencia sin anuncios';

  @override
  String get featureAdFreeSub => 'Sin interrupciones, nunca';

  @override
  String get featureVault => 'Bóveda privada';

  @override
  String get featureVaultSub => 'Protege videos sensibles con Face ID';

  @override
  String get featureSpeed => 'Control de velocidad';

  @override
  String get featureSpeedSub => 'Avance rápido 2× manteniendo pulsado';

  @override
  String get featureOnThisDay => 'Tal día como hoy';

  @override
  String get featureOnThisDaySub => 'Revive videos de años pasados';

  @override
  String get unlockPro => 'Desbloquear RollReel Pro';

  @override
  String get unlockProForever => 'Unlock Pro Forever';

  @override
  String get youArePro => '¡Ya eres Pro!';

  @override
  String get lifetimeFooter => 'Pago único · Sin suscripción';

  @override
  String get monthlyFooter =>
      'Renovación mensual automática · Cancela cuando quieras';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String get subscriptionDisclaimer =>
      'El pago se carga a tu Apple ID. La suscripción se renueva automáticamente a menos que se cancele 24 h antes del fin del período.';

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
  String get termsOfUse => 'Términos de uso (EULA)';

  @override
  String get lifetimeAccess => 'Acceso de por vida';

  @override
  String get foundingMember => 'Miembro fundador';

  @override
  String get bestValue => 'Best Value';

  @override
  String get planNotAvailable =>
      'Este plan no está disponible ahora. Inténtalo más tarde.';

  @override
  String get purchaseFailed => 'Error en la compra';

  @override
  String get active => 'ACTIVO';

  @override
  String get pro => 'PRO';

  @override
  String get plus => 'PLUS';

  @override
  String get retry => 'Reintentar';
}

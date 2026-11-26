import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('tr'),
    Locale('zh'),
  ];

  /// No description provided for @watchNext.
  ///
  /// In en, this message translates to:
  /// **'Watch next'**
  String get watchNext;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @homeRecordedToday.
  ///
  /// In en, this message translates to:
  /// **'Recorded today'**
  String get homeRecordedToday;

  /// No description provided for @homePlays.
  ///
  /// In en, this message translates to:
  /// **'Plays'**
  String get homePlays;

  /// No description provided for @homeWatchActivity.
  ///
  /// In en, this message translates to:
  /// **'Watch activity'**
  String get homeWatchActivity;

  /// No description provided for @homeWatchStreak.
  ///
  /// In en, this message translates to:
  /// **'Watch streak'**
  String get homeWatchStreak;

  /// No description provided for @homeMostWatched.
  ///
  /// In en, this message translates to:
  /// **'Most Watched'**
  String get homeMostWatched;

  /// No description provided for @homeTopFolders.
  ///
  /// In en, this message translates to:
  /// **'Top folders'**
  String get homeTopFolders;

  /// No description provided for @homeVideoRecap.
  ///
  /// In en, this message translates to:
  /// **'Year in review'**
  String get homeVideoRecap;

  /// No description provided for @homeRecordedThisYear.
  ///
  /// In en, this message translates to:
  /// **'Recorded this year'**
  String get homeRecordedThisYear;

  /// No description provided for @homeWatchedToday.
  ///
  /// In en, this message translates to:
  /// **'Watched today'**
  String get homeWatchedToday;

  /// No description provided for @homeTopAlbums.
  ///
  /// In en, this message translates to:
  /// **'Top albums'**
  String get homeTopAlbums;

  /// No description provided for @playerGuideSwipe.
  ///
  /// In en, this message translates to:
  /// **'Swipe up'**
  String get playerGuideSwipe;

  /// No description provided for @playerGuideSwipeBody.
  ///
  /// In en, this message translates to:
  /// **'Move to the next video in your camera roll.'**
  String get playerGuideSwipeBody;

  /// No description provided for @playerGuideTap.
  ///
  /// In en, this message translates to:
  /// **'Tap to play or pause'**
  String get playerGuideTap;

  /// No description provided for @playerGuideTapBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the video once to pause. Tap again to resume.'**
  String get playerGuideTapBody;

  /// No description provided for @playerGuideSeek.
  ///
  /// In en, this message translates to:
  /// **'Double-tap to seek'**
  String get playerGuideSeek;

  /// No description provided for @playerGuideSeekBody.
  ///
  /// In en, this message translates to:
  /// **'Double-tap the left side to go back 10 seconds or the right side to skip ahead 10 seconds.'**
  String get playerGuideSeekBody;

  /// No description provided for @playerGuideEdges.
  ///
  /// In en, this message translates to:
  /// **'Drag along the edges'**
  String get playerGuideEdges;

  /// No description provided for @playerGuideEdgesBody.
  ///
  /// In en, this message translates to:
  /// **'Slide up or down on the left edge for brightness and on the right edge for volume.'**
  String get playerGuideEdgesBody;

  /// No description provided for @playerGuideDone.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get playerGuideDone;

  /// No description provided for @homeNoWatchHistory.
  ///
  /// In en, this message translates to:
  /// **'Watch a video to start your history.'**
  String get homeNoWatchHistory;

  /// No description provided for @homeNoVideoAlbums.
  ///
  /// In en, this message translates to:
  /// **'Albums with videos will appear here.'**
  String get homeNoVideoAlbums;

  /// No description provided for @homeNoVideoFolders.
  ///
  /// In en, this message translates to:
  /// **'Folders with videos will appear here.'**
  String get homeNoVideoFolders;

  /// No description provided for @homeLimitedVideoCollections.
  ///
  /// In en, this message translates to:
  /// **'Limited access can hide some albums or folders.'**
  String get homeLimitedVideoCollections;

  /// No description provided for @homeWatchDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} day} other{{count} days}}'**
  String homeWatchDays(int count);

  /// No description provided for @homePlayCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} play} other{{count} plays}}'**
  String homePlayCount(int count);

  /// No description provided for @homeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get homeUnavailable;

  /// No description provided for @homeLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get homeLoading;

  /// No description provided for @homeCameraRoll.
  ///
  /// In en, this message translates to:
  /// **'Your\ncamera roll.'**
  String get homeCameraRoll;

  /// No description provided for @homeWatchTab.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get homeWatchTab;

  /// No description provided for @homeActivityTab.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get homeActivityTab;

  /// No description provided for @homeYourActivity.
  ///
  /// In en, this message translates to:
  /// **'Your activity'**
  String get homeYourActivity;

  /// No description provided for @homeEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your first reel starts here'**
  String get homeEmptyTitle;

  /// No description provided for @homeEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Record a video with your camera. It’ll be here when you come back.'**
  String get homeEmptyBody;

  /// No description provided for @homeOpenCamera.
  ///
  /// In en, this message translates to:
  /// **'Open Camera'**
  String get homeOpenCamera;

  /// No description provided for @homeCaptureFailed.
  ///
  /// In en, this message translates to:
  /// **'RollReel couldn’t record or save the video.'**
  String get homeCaptureFailed;

  /// No description provided for @homeAccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your videos'**
  String get homeAccessTitle;

  /// No description provided for @homeAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Allow Photos access in Settings to watch videos from your camera roll.'**
  String get homeAccessBody;

  /// No description provided for @homeLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Your videos couldn’t load'**
  String get homeLoadFailed;

  /// No description provided for @homeLoadFailedBody.
  ///
  /// In en, this message translates to:
  /// **'Your camera roll may still be syncing. Give it another try.'**
  String get homeLoadFailedBody;

  /// No description provided for @homeNoMemories.
  ///
  /// In en, this message translates to:
  /// **'No videos from this date in past years.'**
  String get homeNoMemories;

  /// No description provided for @homePlayClip.
  ///
  /// In en, this message translates to:
  /// **'Play {title}'**
  String homePlayClip(String title);

  /// No description provided for @homePlaybackFailed.
  ///
  /// In en, this message translates to:
  /// **'This video couldn’t play.'**
  String get homePlaybackFailed;

  /// No description provided for @homePause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get homePause;

  /// No description provided for @homePlay.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get homePlay;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Back to your\ncamera roll.'**
  String get onboardingTitle;

  /// No description provided for @favoritesSavedCount.
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String favoritesSavedCount(int count);

  /// No description provided for @favoritesRemoveVideo.
  ///
  /// In en, this message translates to:
  /// **'Remove {title} from Favorites'**
  String favoritesRemoveVideo(String title);

  /// No description provided for @favoritesRemoved.
  ///
  /// In en, this message translates to:
  /// **'Removed from Favorites'**
  String get favoritesRemoved;

  /// No description provided for @favoritesUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get favoritesUndo;

  /// No description provided for @favoritesLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Favorites couldn’t load'**
  String get favoritesLoadFailed;

  /// No description provided for @favoritesRetryBody.
  ///
  /// In en, this message translates to:
  /// **'Try fetching your saved videos again.'**
  String get favoritesRetryBody;

  /// No description provided for @favoritesAccessBody.
  ///
  /// In en, this message translates to:
  /// **'Allow Photos access to see your saved videos.'**
  String get favoritesAccessBody;

  /// No description provided for @favoritesUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t update Favorites.'**
  String get favoritesUpdateFailed;

  /// No description provided for @onboardingSwipeTitle.
  ///
  /// In en, this message translates to:
  /// **'Swipe up for\nthe next video.'**
  String get onboardingSwipeTitle;

  /// No description provided for @onboardingSwipeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try it on the preview below.'**
  String get onboardingSwipeSubtitle;

  /// No description provided for @onboardingTrySwipe.
  ///
  /// In en, this message translates to:
  /// **'Try a swipe'**
  String get onboardingTrySwipe;

  /// No description provided for @onboardingSampleClip.
  ///
  /// In en, this message translates to:
  /// **'Sample clip {current} of {total}'**
  String onboardingSampleClip(int current, int total);

  /// No description provided for @onboardingNextSample.
  ///
  /// In en, this message translates to:
  /// **'Show next sample clip'**
  String get onboardingNextSample;

  /// No description provided for @onboardingLimitedTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick specific videos'**
  String get onboardingLimitedTitle;

  /// No description provided for @onboardingLimitedBody.
  ///
  /// In en, this message translates to:
  /// **'Choose the items RollReel can see in the system picker.'**
  String get onboardingLimitedBody;

  /// No description provided for @onboardingFullTitle.
  ///
  /// In en, this message translates to:
  /// **'Allow your whole library'**
  String get onboardingFullTitle;

  /// No description provided for @onboardingFullBody.
  ///
  /// In en, this message translates to:
  /// **'Browse all your camera-roll videos. You can change access in Settings.'**
  String get onboardingFullBody;

  /// No description provided for @onboardingChooseVideos.
  ///
  /// In en, this message translates to:
  /// **'Choose videos'**
  String get onboardingChooseVideos;

  /// No description provided for @onboardingNotNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get onboardingNotNow;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Watch the little moments you filmed, one video at a time.'**
  String get onboardingSubtitle;

  /// No description provided for @onboardingPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Your own videos play on your device. There’s no account to create or library to upload.'**
  String get onboardingPrivacyBody;

  /// No description provided for @onboardingPermissionBody.
  ///
  /// In en, this message translates to:
  /// **'Allow photo library access so RollReel can find and play your videos.'**
  String get onboardingPermissionBody;

  /// No description provided for @onboardingAccessBody.
  ///
  /// In en, this message translates to:
  /// **'RollReel uses Photos access to show videos from your camera roll.'**
  String get onboardingAccessBody;

  /// No description provided for @onboardingPermissionNote.
  ///
  /// In en, this message translates to:
  /// **'You can change access anytime in Settings.'**
  String get onboardingPermissionNote;

  /// No description provided for @onboardingPermissionError.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t request access. Try again or skip for now.'**
  String get onboardingPermissionError;

  /// No description provided for @onboardingStep.
  ///
  /// In en, this message translates to:
  /// **'Step {step} of {total}'**
  String onboardingStep(int step, int total);

  /// No description provided for @onboardingPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'For your eyes only.'**
  String get onboardingPrivacyTitle;

  /// No description provided for @onboardingPermissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Which videos\ncan we play?'**
  String get onboardingPermissionTitle;

  /// No description provided for @onboardingNoCloud.
  ///
  /// In en, this message translates to:
  /// **'No Cloud'**
  String get onboardingNoCloud;

  /// No description provided for @onboardingNoAccount.
  ///
  /// In en, this message translates to:
  /// **'No Account'**
  String get onboardingNoAccount;

  /// No description provided for @onboardingNoTracking.
  ///
  /// In en, this message translates to:
  /// **'No Tracking'**
  String get onboardingNoTracking;

  /// No description provided for @swipeHint.
  ///
  /// In en, this message translates to:
  /// **'SWIPE'**
  String get swipeHint;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @continueLabel.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueLabel;

  /// No description provided for @requesting.
  ///
  /// In en, this message translates to:
  /// **'Requesting…'**
  String get requesting;

  /// No description provided for @allowAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Access'**
  String get allowAccess;

  /// No description provided for @noVideosYetTitle.
  ///
  /// In en, this message translates to:
  /// **'No Videos Yet'**
  String get noVideosYetTitle;

  /// No description provided for @noVideosYetBody.
  ///
  /// In en, this message translates to:
  /// **'Your camera roll videos will appear here.'**
  String get noVideosYetBody;

  /// No description provided for @openPhotosApp.
  ///
  /// In en, this message translates to:
  /// **'Open Photos App'**
  String get openPhotosApp;

  /// No description provided for @loadingLibrary.
  ///
  /// In en, this message translates to:
  /// **'Loading your library...'**
  String get loadingLibrary;

  /// No description provided for @permissionDeniedTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos access\nis off.'**
  String get permissionDeniedTitle;

  /// No description provided for @permissionDeniedBody.
  ///
  /// In en, this message translates to:
  /// **'Choose videos in Settings when you’re ready. You can still explore RollReel.'**
  String get permissionDeniedBody;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @continueAnyway.
  ///
  /// In en, this message translates to:
  /// **'Continue Anyway'**
  String get continueAnyway;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @yesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterday;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @videoFallbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get videoFallbackTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get filterToday;

  /// No description provided for @filterShorts.
  ///
  /// In en, this message translates to:
  /// **'Shorts'**
  String get filterShorts;

  /// No description provided for @filterLong.
  ///
  /// In en, this message translates to:
  /// **'Long'**
  String get filterLong;

  /// No description provided for @filterRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent'**
  String get filterRecent;

  /// No description provided for @videoDeleted.
  ///
  /// In en, this message translates to:
  /// **'Video deleted'**
  String get videoDeleted;

  /// No description provided for @getInfo.
  ///
  /// In en, this message translates to:
  /// **'Get Info'**
  String get getInfo;

  /// No description provided for @addToVault.
  ///
  /// In en, this message translates to:
  /// **'Add to Vault'**
  String get addToVault;

  /// No description provided for @removeFromVault.
  ///
  /// In en, this message translates to:
  /// **'Remove from Vault'**
  String get removeFromVault;

  /// No description provided for @deleteVideo.
  ///
  /// In en, this message translates to:
  /// **'Delete Video'**
  String get deleteVideo;

  /// No description provided for @deleteVideoWarning.
  ///
  /// In en, this message translates to:
  /// **'This will permanently delete the video from your library.'**
  String get deleteVideoWarning;

  /// No description provided for @thisVideo.
  ///
  /// In en, this message translates to:
  /// **'This video'**
  String get thisVideo;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @expand.
  ///
  /// In en, this message translates to:
  /// **'Expand'**
  String get expand;

  /// No description provided for @photoLibraryAccess.
  ///
  /// In en, this message translates to:
  /// **'Photo Library Access'**
  String get photoLibraryAccess;

  /// No description provided for @limitedAccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'re currently sharing a limited selection of videos.'**
  String get limitedAccessMessage;

  /// No description provided for @selectMoreVideos.
  ///
  /// In en, this message translates to:
  /// **'Select More Videos'**
  String get selectMoreVideos;

  /// No description provided for @allowFullAccess.
  ///
  /// In en, this message translates to:
  /// **'Allow Full Access'**
  String get allowFullAccess;

  /// No description provided for @managingCount.
  ///
  /// In en, this message translates to:
  /// **'Managing {count} of your videos'**
  String managingCount(int count);

  /// No description provided for @infoDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get infoDate;

  /// No description provided for @infoDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get infoDuration;

  /// No description provided for @infoResolution.
  ///
  /// In en, this message translates to:
  /// **'Resolution'**
  String get infoResolution;

  /// No description provided for @infoFileSize.
  ///
  /// In en, this message translates to:
  /// **'File Size'**
  String get infoFileSize;

  /// No description provided for @infoFormat.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get infoFormat;

  /// No description provided for @feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feed;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @libraryFilters.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get libraryFilters;

  /// No description provided for @libraryClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get libraryClose;

  /// No description provided for @libraryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No videos yet'**
  String get libraryEmptyTitle;

  /// No description provided for @libraryAccessOff.
  ///
  /// In en, this message translates to:
  /// **'Photos access is off'**
  String get libraryAccessOff;

  /// No description provided for @libraryNoMatches.
  ///
  /// In en, this message translates to:
  /// **'No matching videos'**
  String get libraryNoMatches;

  /// No description provided for @librarySearchHelp.
  ///
  /// In en, this message translates to:
  /// **'Try a different title or clear your search.'**
  String get librarySearchHelp;

  /// No description provided for @libraryNoFilterMatches.
  ///
  /// In en, this message translates to:
  /// **'No videos match these filters'**
  String get libraryNoFilterMatches;

  /// No description provided for @libraryFilterHelp.
  ///
  /// In en, this message translates to:
  /// **'Clear the filters to see all of your videos.'**
  String get libraryFilterHelp;

  /// No description provided for @libraryUnknownDate.
  ///
  /// In en, this message translates to:
  /// **'Date unknown'**
  String get libraryUnknownDate;

  /// No description provided for @libraryDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'RollReel couldn’t delete the video.'**
  String get libraryDeleteFailed;

  /// No description provided for @libraryDeviceCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 video} other{{count} videos}} on this device'**
  String libraryDeviceCount(int count);

  /// No description provided for @libraryMemoriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 video} other{{count} videos}} from past years'**
  String libraryMemoriesCount(int count);

  /// No description provided for @libraryVideoOptions.
  ///
  /// In en, this message translates to:
  /// **'Options for {title}'**
  String libraryVideoOptions(String title);

  /// No description provided for @libraryVideoRow.
  ///
  /// In en, this message translates to:
  /// **'{title} · {date} · {duration}'**
  String libraryVideoRow(String title, String date, String duration);

  /// No description provided for @favoritesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet'**
  String get favoritesEmptyTitle;

  /// No description provided for @favoritesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart while watching a video to save it here.'**
  String get favoritesEmptyBody;

  /// No description provided for @goToLibrary.
  ///
  /// In en, this message translates to:
  /// **'Browse Library'**
  String get goToLibrary;

  /// No description provided for @infoTab.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoTab;

  /// No description provided for @searchVideos.
  ///
  /// In en, this message translates to:
  /// **'Search videos…'**
  String get searchVideos;

  /// No description provided for @videosTitle.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videosTitle;

  /// No description provided for @videosCount.
  ///
  /// In en, this message translates to:
  /// **'{count} Videos'**
  String videosCount(int count);

  /// No description provided for @yourLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your Library'**
  String get yourLibrary;

  /// No description provided for @libraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get libraryTitle;

  /// No description provided for @librarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your personal video collection'**
  String get librarySubtitle;

  /// No description provided for @totalInLibrary.
  ///
  /// In en, this message translates to:
  /// **'Total in your library'**
  String get totalInLibrary;

  /// No description provided for @localBadge.
  ///
  /// In en, this message translates to:
  /// **'Local'**
  String get localBadge;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No Results'**
  String get noResults;

  /// No description provided for @noVideosFound.
  ///
  /// In en, this message translates to:
  /// **'No Videos Found'**
  String get noVideosFound;

  /// No description provided for @noSearchMatches.
  ///
  /// In en, this message translates to:
  /// **'No videos match \"{query}\".'**
  String noSearchMatches(String query);

  /// No description provided for @tryDifferentFilter.
  ///
  /// In en, this message translates to:
  /// **'Try a different filter.'**
  String get tryDifferentFilter;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @timePeriod.
  ///
  /// In en, this message translates to:
  /// **'Time period'**
  String get timePeriod;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @any.
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get any;

  /// No description provided for @durationShort.
  ///
  /// In en, this message translates to:
  /// **'Under 1 min'**
  String get durationShort;

  /// No description provided for @durationMedium.
  ///
  /// In en, this message translates to:
  /// **'1–5 min'**
  String get durationMedium;

  /// No description provided for @durationLong.
  ///
  /// In en, this message translates to:
  /// **'Over 5 min'**
  String get durationLong;

  /// No description provided for @sortBy.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortBy;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'Newest First'**
  String get newestFirst;

  /// No description provided for @oldestFirst.
  ///
  /// In en, this message translates to:
  /// **'Oldest First'**
  String get oldestFirst;

  /// No description provided for @shortestFirst.
  ///
  /// In en, this message translates to:
  /// **'Shortest First'**
  String get shortestFirst;

  /// No description provided for @longestFirst.
  ///
  /// In en, this message translates to:
  /// **'Longest First'**
  String get longestFirst;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @onThisDay.
  ///
  /// In en, this message translates to:
  /// **'On This Day'**
  String get onThisDay;

  /// No description provided for @onThisDaySubtitleOne.
  ///
  /// In en, this message translates to:
  /// **'1 memory from {years}'**
  String onThisDaySubtitleOne(String years);

  /// No description provided for @onThisDaySubtitleMany.
  ///
  /// In en, this message translates to:
  /// **'{count} memories from past years'**
  String onThisDaySubtitleMany(int count);

  /// No description provided for @yearsAgoOne.
  ///
  /// In en, this message translates to:
  /// **'1 year ago'**
  String get yearsAgoOne;

  /// No description provided for @yearsAgoMany.
  ///
  /// In en, this message translates to:
  /// **'{years} years ago'**
  String yearsAgoMany(int years);

  /// No description provided for @onThisDayHeader.
  ///
  /// In en, this message translates to:
  /// **'On This Day · {yearsAgo}'**
  String onThisDayHeader(String yearsAgo);

  /// No description provided for @positionCounter.
  ///
  /// In en, this message translates to:
  /// **'{current} of {total}'**
  String positionCounter(int current, int total);

  /// No description provided for @couldNotLoadMemories.
  ///
  /// In en, this message translates to:
  /// **'Could not load memories: {error}'**
  String couldNotLoadMemories(String error);

  /// No description provided for @couldNotLoadVideos.
  ///
  /// In en, this message translates to:
  /// **'Could not load videos: {error}'**
  String couldNotLoadVideos(String error);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @playbackSection.
  ///
  /// In en, this message translates to:
  /// **'Playback'**
  String get playbackSection;

  /// No description provided for @loopShortVideos.
  ///
  /// In en, this message translates to:
  /// **'Loop short videos'**
  String get loopShortVideos;

  /// No description provided for @loopShortVideosSub.
  ///
  /// In en, this message translates to:
  /// **'Replay clips under 30 seconds'**
  String get loopShortVideosSub;

  /// No description provided for @autoPlayOnLaunch.
  ///
  /// In en, this message translates to:
  /// **'Auto-play on launch'**
  String get autoPlayOnLaunch;

  /// No description provided for @autoPlayOnLaunchSub.
  ///
  /// In en, this message translates to:
  /// **'Start playback when the feed opens'**
  String get autoPlayOnLaunchSub;

  /// No description provided for @defaultFilter.
  ///
  /// In en, this message translates to:
  /// **'Default filter'**
  String get defaultFilter;

  /// No description provided for @defaultFilterSub.
  ///
  /// In en, this message translates to:
  /// **'Choose what opens in the feed'**
  String get defaultFilterSub;

  /// No description provided for @appearanceSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceSection;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get darkMode;

  /// No description provided for @darkModeSub.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme for the app'**
  String get darkModeSub;

  /// No description provided for @showDateLabels.
  ///
  /// In en, this message translates to:
  /// **'Show date labels'**
  String get showDateLabels;

  /// No description provided for @showDateLabelsSub.
  ///
  /// In en, this message translates to:
  /// **'Display date on video thumbnails'**
  String get showDateLabelsSub;

  /// No description provided for @showDurationBadges.
  ///
  /// In en, this message translates to:
  /// **'Show duration badges'**
  String get showDurationBadges;

  /// No description provided for @showDurationBadgesSub.
  ///
  /// In en, this message translates to:
  /// **'Show video duration on thumbnails'**
  String get showDurationBadgesSub;

  /// No description provided for @privacySection.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacySection;

  /// No description provided for @privacyVault.
  ///
  /// In en, this message translates to:
  /// **'Privacy Vault'**
  String get privacyVault;

  /// No description provided for @privacySettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Settings'**
  String get privacySettingsTitle;

  /// No description provided for @privacySettingsSub.
  ///
  /// In en, this message translates to:
  /// **'Manage your data and permissions'**
  String get privacySettingsSub;

  /// No description provided for @proBadge.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get proBadge;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @privacyPolicyBody.
  ///
  /// In en, this message translates to:
  /// **'RollReel does not upload, transmit, or store any of your videos outside your device. No account is required. No personal data is shared with third parties.'**
  String get privacyPolicyBody;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate RollReel'**
  String get rateApp;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share RollReel'**
  String get shareApp;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @settingsFilterDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose which videos you see when you open the feed.'**
  String get settingsFilterDescription;

  /// No description provided for @settingsProDescription.
  ///
  /// In en, this message translates to:
  /// **'Ad-free playback and Privacy Vault'**
  String get settingsProDescription;

  /// No description provided for @settingsProActive.
  ///
  /// In en, this message translates to:
  /// **'Pro is active'**
  String get settingsProActive;

  /// No description provided for @settingsVaultDescription.
  ///
  /// In en, this message translates to:
  /// **'Open your private videos'**
  String get settingsVaultDescription;

  /// No description provided for @settingsRestoreComplete.
  ///
  /// In en, this message translates to:
  /// **'Finished checking for past purchases.'**
  String get settingsRestoreComplete;

  /// No description provided for @settingsRestoreFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t restore purchases. Please try again.'**
  String get settingsRestoreFailed;

  /// No description provided for @proCardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ad-free · Vault · Speed · Collections'**
  String get proCardSubtitle;

  /// No description provided for @proCardTagline.
  ///
  /// In en, this message translates to:
  /// **'Elevate your viewing experience'**
  String get proCardTagline;

  /// No description provided for @shareAppMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out RollReel – swipe through your camera roll videos, 100% offline!'**
  String get shareAppMessage;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Private Vault'**
  String get vaultTitle;

  /// No description provided for @vaultLocked.
  ///
  /// In en, this message translates to:
  /// **'Vault Locked'**
  String get vaultLocked;

  /// No description provided for @vaultLockedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your private videos are safely locked and only you can access them.'**
  String get vaultLockedSubtitle;

  /// No description provided for @unlockWithFaceId.
  ///
  /// In en, this message translates to:
  /// **'Unlock with Face ID'**
  String get unlockWithFaceId;

  /// No description provided for @unlockVaultReason.
  ///
  /// In en, this message translates to:
  /// **'Unlock your Private Vault'**
  String get unlockVaultReason;

  /// No description provided for @faceIdUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Face ID is not available on this device.'**
  String get faceIdUnavailable;

  /// No description provided for @orDivider.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orDivider;

  /// No description provided for @enterPasscode.
  ///
  /// In en, this message translates to:
  /// **'Enter Passcode'**
  String get enterPasscode;

  /// No description provided for @vaultBadgeSecureTitle.
  ///
  /// In en, this message translates to:
  /// **'Private & Secure'**
  String get vaultBadgeSecureTitle;

  /// No description provided for @vaultBadgeSecureSub.
  ///
  /// In en, this message translates to:
  /// **'Only you can access your vault'**
  String get vaultBadgeSecureSub;

  /// No description provided for @vaultBadgeEncryptedTitle.
  ///
  /// In en, this message translates to:
  /// **'End-to-End Encrypted'**
  String get vaultBadgeEncryptedTitle;

  /// No description provided for @vaultBadgeEncryptedSub.
  ///
  /// In en, this message translates to:
  /// **'Your videos stay fully encrypted'**
  String get vaultBadgeEncryptedSub;

  /// No description provided for @vaultBadgeHiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Hidden & Discreet'**
  String get vaultBadgeHiddenTitle;

  /// No description provided for @vaultBadgeHiddenSub.
  ///
  /// In en, this message translates to:
  /// **'Your privacy is our priority'**
  String get vaultBadgeHiddenSub;

  /// No description provided for @authFailed.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed. Please try again.'**
  String get authFailed;

  /// No description provided for @vaultLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load vault'**
  String get vaultLoadFailed;

  /// No description provided for @vaultEmpty.
  ///
  /// In en, this message translates to:
  /// **'Vault is empty'**
  String get vaultEmpty;

  /// No description provided for @vaultEmptyHint.
  ///
  /// In en, this message translates to:
  /// **'Tap ••• on any video to add it here'**
  String get vaultEmptyHint;

  /// No description provided for @vaultEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep your private videos safe and secure in one place.'**
  String get vaultEmptySubtitle;

  /// No description provided for @addVideosToVault.
  ///
  /// In en, this message translates to:
  /// **'Add Videos to Vault'**
  String get addVideosToVault;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get howItWorks;

  /// No description provided for @removeFromVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove from Vault?'**
  String get removeFromVaultTitle;

  /// No description provided for @removeFromVaultBody.
  ///
  /// In en, this message translates to:
  /// **'This video will return to your main library.'**
  String get removeFromVaultBody;

  /// No description provided for @vaultRecoveryLocked.
  ///
  /// In en, this message translates to:
  /// **'Unlock the Vault to return your videos to Library.'**
  String get vaultRecoveryLocked;

  /// No description provided for @vaultReturnAll.
  ///
  /// In en, this message translates to:
  /// **'Return videos to Library'**
  String get vaultReturnAll;

  /// No description provided for @vaultRecoveryBody.
  ///
  /// In en, this message translates to:
  /// **'You can return your vaulted videos to Library at any time.'**
  String get vaultRecoveryBody;

  /// No description provided for @vaultRecoveryConfirm.
  ///
  /// In en, this message translates to:
  /// **'All Vault videos will be visible again in your RollReel library.'**
  String get vaultRecoveryConfirm;

  /// No description provided for @vaultRecoveryDone.
  ///
  /// In en, this message translates to:
  /// **'Videos returned to Library.'**
  String get vaultRecoveryDone;

  /// No description provided for @vaultUpdateFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t update the Vault. Please try again.'**
  String get vaultUpdateFailed;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'RollReel Pro'**
  String get paywallTitle;

  /// No description provided for @paywallPlaybackTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep watching.'**
  String get paywallPlaybackTitle;

  /// No description provided for @paywallPlaybackBody.
  ///
  /// In en, this message translates to:
  /// **'Your videos, without ad breaks.'**
  String get paywallPlaybackBody;

  /// No description provided for @paywallVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep it to yourself.'**
  String get paywallVaultTitle;

  /// No description provided for @paywallVaultBody.
  ///
  /// In en, this message translates to:
  /// **'A locked space for your private videos.'**
  String get paywallVaultBody;

  /// No description provided for @paywallMemoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'See this\nday again.'**
  String get paywallMemoriesTitle;

  /// No description provided for @paywallMemoriesBody.
  ///
  /// In en, this message translates to:
  /// **'Find videos from this day in past years.'**
  String get paywallMemoriesBody;

  /// No description provided for @paywallSpeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Watch at your pace.'**
  String get paywallSpeedTitle;

  /// No description provided for @paywallAdFree.
  ///
  /// In en, this message translates to:
  /// **'Ad-free playback'**
  String get paywallAdFree;

  /// No description provided for @paywallAdFreeBody.
  ///
  /// In en, this message translates to:
  /// **'Replay clips without ad breaks'**
  String get paywallAdFreeBody;

  /// No description provided for @paywallVaultBenefit.
  ///
  /// In en, this message translates to:
  /// **'Lock the clips you choose'**
  String get paywallVaultBenefit;

  /// No description provided for @paywallSpeed.
  ///
  /// In en, this message translates to:
  /// **'Hold to play at 2×'**
  String get paywallSpeed;

  /// No description provided for @paywallSpeedBenefit.
  ///
  /// In en, this message translates to:
  /// **'Fast-forward with a press and hold'**
  String get paywallSpeedBenefit;

  /// No description provided for @paywallMemoriesBenefit.
  ///
  /// In en, this message translates to:
  /// **'Rediscover clips from past years'**
  String get paywallMemoriesBenefit;

  /// No description provided for @paywallChoosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose a plan'**
  String get paywallChoosePlan;

  /// No description provided for @paywallLifetime.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get paywallLifetime;

  /// No description provided for @paywallMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get paywallMonthly;

  /// No description provided for @paywallRenewsMonthly.
  ///
  /// In en, this message translates to:
  /// **'Auto-renews monthly'**
  String get paywallRenewsMonthly;

  /// No description provided for @paywallGetLifetime.
  ///
  /// In en, this message translates to:
  /// **'Get Lifetime'**
  String get paywallGetLifetime;

  /// No description provided for @paywallSubscribeMonthly.
  ///
  /// In en, this message translates to:
  /// **'Subscribe monthly'**
  String get paywallSubscribeMonthly;

  /// No description provided for @paywallMonthlyPrice.
  ///
  /// In en, this message translates to:
  /// **'{price}/month'**
  String paywallMonthlyPrice(String price);

  /// No description provided for @paywallLifetimeBilling.
  ///
  /// In en, this message translates to:
  /// **'{price} once. No subscription.'**
  String paywallLifetimeBilling(String price);

  /// No description provided for @paywallMonthlyBilling.
  ///
  /// In en, this message translates to:
  /// **'{price}/month. Auto-renews monthly. Cancel in App Store settings.'**
  String paywallMonthlyBilling(String price);

  /// No description provided for @paywallLoadingPrices.
  ///
  /// In en, this message translates to:
  /// **'Loading prices…'**
  String get paywallLoadingPrices;

  /// No description provided for @paywallPricesUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Plans unavailable'**
  String get paywallPricesUnavailable;

  /// No description provided for @paywallLinkUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t open this link. Please try again.'**
  String get paywallLinkUnavailable;

  /// No description provided for @paywallTagline.
  ///
  /// In en, this message translates to:
  /// **'Watch more. Worry less.'**
  String get paywallTagline;

  /// No description provided for @featureAdFree.
  ///
  /// In en, this message translates to:
  /// **'Ad-Free Experience'**
  String get featureAdFree;

  /// No description provided for @featureAdFreeSub.
  ///
  /// In en, this message translates to:
  /// **'No interruptions, ever'**
  String get featureAdFreeSub;

  /// No description provided for @featureVault.
  ///
  /// In en, this message translates to:
  /// **'Privacy Vault'**
  String get featureVault;

  /// No description provided for @featureVaultSub.
  ///
  /// In en, this message translates to:
  /// **'Lock sensitive videos with Face ID'**
  String get featureVaultSub;

  /// No description provided for @featureSpeed.
  ///
  /// In en, this message translates to:
  /// **'Playback Speed Control'**
  String get featureSpeed;

  /// No description provided for @featureSpeedSub.
  ///
  /// In en, this message translates to:
  /// **'2× fast-forward on long-press'**
  String get featureSpeedSub;

  /// No description provided for @featureOnThisDay.
  ///
  /// In en, this message translates to:
  /// **'On This Day'**
  String get featureOnThisDay;

  /// No description provided for @featureOnThisDaySub.
  ///
  /// In en, this message translates to:
  /// **'Relive videos from past years'**
  String get featureOnThisDaySub;

  /// No description provided for @unlockPro.
  ///
  /// In en, this message translates to:
  /// **'Unlock RollReel Pro'**
  String get unlockPro;

  /// No description provided for @unlockProForever.
  ///
  /// In en, this message translates to:
  /// **'Unlock Pro Forever'**
  String get unlockProForever;

  /// No description provided for @youArePro.
  ///
  /// In en, this message translates to:
  /// **'You\'re Pro!'**
  String get youArePro;

  /// No description provided for @lifetimeFooter.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase · No subscription · Forever yours'**
  String get lifetimeFooter;

  /// No description provided for @monthlyFooter.
  ///
  /// In en, this message translates to:
  /// **'Auto-renews monthly · Cancel anytime'**
  String get monthlyFooter;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @subscriptionDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Payment charged to Apple ID. Subscription auto-renews unless cancelled 24h before period ends.'**
  String get subscriptionDisclaimer;

  /// No description provided for @oneTimeDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Payment charged to Apple ID. No subscription. Your access is permanent.'**
  String get oneTimeDisclaimer;

  /// No description provided for @onePaymentLabel.
  ///
  /// In en, this message translates to:
  /// **'One-time payment'**
  String get onePaymentLabel;

  /// No description provided for @bulletLifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'Lifetime access'**
  String get bulletLifetimeAccess;

  /// No description provided for @bulletAllProFeatures.
  ///
  /// In en, this message translates to:
  /// **'All Pro features'**
  String get bulletAllProFeatures;

  /// No description provided for @bulletFutureUpdates.
  ///
  /// In en, this message translates to:
  /// **'Future updates'**
  String get bulletFutureUpdates;

  /// No description provided for @termsOfUse.
  ///
  /// In en, this message translates to:
  /// **'Terms of Use'**
  String get termsOfUse;

  /// No description provided for @lifetimeAccess.
  ///
  /// In en, this message translates to:
  /// **'Lifetime Access'**
  String get lifetimeAccess;

  /// No description provided for @foundingMember.
  ///
  /// In en, this message translates to:
  /// **'Founding member'**
  String get foundingMember;

  /// No description provided for @bestValue.
  ///
  /// In en, this message translates to:
  /// **'Best Value'**
  String get bestValue;

  /// No description provided for @planNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'This plan isn\'t available right now. Please try again later.'**
  String get planNotAvailable;

  /// No description provided for @purchaseFailed.
  ///
  /// In en, this message translates to:
  /// **'Purchase failed'**
  String get purchaseFailed;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @pro.
  ///
  /// In en, this message translates to:
  /// **'PRO'**
  String get pro;

  /// No description provided for @plus.
  ///
  /// In en, this message translates to:
  /// **'PLUS'**
  String get plus;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'it',
    'ja',
    'ko',
    'pt',
    'ru',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

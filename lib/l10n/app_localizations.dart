import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'ShortHub'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In fr, this message translates to:
  /// **'Gestion collaborative de YouTube Shorts'**
  String get appTagline;

  /// No description provided for @appTaglineSplash.
  ///
  /// In fr, this message translates to:
  /// **'Gestion Collaborative de Shorts'**
  String get appTaglineSplash;

  /// No description provided for @loading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get loading;

  /// No description provided for @loadingVideos.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des videos...'**
  String get loadingVideos;

  /// No description provided for @loadingNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des notifications...'**
  String get loadingNotifications;

  /// No description provided for @loadingProfile.
  ///
  /// In fr, this message translates to:
  /// **'Chargement du profil...'**
  String get loadingProfile;

  /// No description provided for @loadingShort.
  ///
  /// In fr, this message translates to:
  /// **'Chargement du short...'**
  String get loadingShort;

  /// No description provided for @loginUsername.
  ///
  /// In fr, this message translates to:
  /// **'Nom d\'utilisateur'**
  String get loginUsername;

  /// No description provided for @loginUsernameHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre nom d\'utilisateur'**
  String get loginUsernameHint;

  /// No description provided for @loginPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get loginPassword;

  /// No description provided for @loginPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Entrez votre mot de passe'**
  String get loginPasswordHint;

  /// No description provided for @loginButton.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get loginButton;

  /// No description provided for @loginError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de connexion. Vérifiez vos identifiants.'**
  String get loginError;

  /// No description provided for @loginUsernameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom d\'utilisateur est requis'**
  String get loginUsernameRequired;

  /// No description provided for @loginUsernameMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le nom d\'utilisateur doit contenir au moins 3 caractères'**
  String get loginUsernameMinLength;

  /// No description provided for @loginPasswordRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe est requis'**
  String get loginPasswordRequired;

  /// No description provided for @loginPasswordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get loginPasswordMinLength;

  /// No description provided for @noUserConnected.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur connecté'**
  String get noUserConnected;

  /// No description provided for @userNotConnected.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur non connecte'**
  String get userNotConnected;

  /// No description provided for @navNavigation.
  ///
  /// In fr, this message translates to:
  /// **'NAVIGATION'**
  String get navNavigation;

  /// No description provided for @navSettings.
  ///
  /// In fr, this message translates to:
  /// **'PARAMÈTRES'**
  String get navSettings;

  /// No description provided for @navTracking.
  ///
  /// In fr, this message translates to:
  /// **'Suivi'**
  String get navTracking;

  /// No description provided for @navRolling.
  ///
  /// In fr, this message translates to:
  /// **'Rolling'**
  String get navRolling;

  /// No description provided for @navChannels.
  ///
  /// In fr, this message translates to:
  /// **'Canaux'**
  String get navChannels;

  /// No description provided for @navTeam.
  ///
  /// In fr, this message translates to:
  /// **'Équipe'**
  String get navTeam;

  /// No description provided for @navAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assignées'**
  String get navAssigned;

  /// No description provided for @navInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get navInProgress;

  /// No description provided for @navCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminées'**
  String get navCompleted;

  /// No description provided for @navToValidate.
  ///
  /// In fr, this message translates to:
  /// **'À valider'**
  String get navToValidate;

  /// No description provided for @navValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validées'**
  String get navValidated;

  /// No description provided for @navRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejetées'**
  String get navRejected;

  /// No description provided for @drawerProfile.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get drawerProfile;

  /// No description provided for @drawerDarkMode.
  ///
  /// In fr, this message translates to:
  /// **'Mode sombre'**
  String get drawerDarkMode;

  /// No description provided for @drawerLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get drawerLanguage;

  /// No description provided for @drawerLogout.
  ///
  /// In fr, this message translates to:
  /// **'Déconnexion'**
  String get drawerLogout;

  /// No description provided for @drawerLogoutConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir vous déconnecter ?'**
  String get drawerLogoutConfirm;

  /// No description provided for @drawerNoEmail.
  ///
  /// In fr, this message translates to:
  /// **'Aucun email'**
  String get drawerNoEmail;

  /// No description provided for @roleAdmin.
  ///
  /// In fr, this message translates to:
  /// **'Administrateur'**
  String get roleAdmin;

  /// No description provided for @roleVideaste.
  ///
  /// In fr, this message translates to:
  /// **'Vidéaste'**
  String get roleVideaste;

  /// No description provided for @roleAssistant.
  ///
  /// In fr, this message translates to:
  /// **'Assistant'**
  String get roleAssistant;

  /// No description provided for @statusRolled.
  ///
  /// In fr, this message translates to:
  /// **'Rollé'**
  String get statusRolled;

  /// No description provided for @statusRetained.
  ///
  /// In fr, this message translates to:
  /// **'Retenu'**
  String get statusRetained;

  /// No description provided for @statusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejeté'**
  String get statusRejected;

  /// No description provided for @statusAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assigné'**
  String get statusAssigned;

  /// No description provided for @statusInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get statusInProgress;

  /// No description provided for @statusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminé'**
  String get statusCompleted;

  /// No description provided for @statusValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validé'**
  String get statusValidated;

  /// No description provided for @statusPublished.
  ///
  /// In fr, this message translates to:
  /// **'Publié'**
  String get statusPublished;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get commonConfirm;

  /// No description provided for @commonView.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get commonView;

  /// No description provided for @commonViewDetails.
  ///
  /// In fr, this message translates to:
  /// **'Voir les details'**
  String get commonViewDetails;

  /// No description provided for @commonRetry.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get commonRetry;

  /// No description provided for @commonOops.
  ///
  /// In fr, this message translates to:
  /// **'Oups !'**
  String get commonOops;

  /// No description provided for @commonYes.
  ///
  /// In fr, this message translates to:
  /// **'Oui'**
  String get commonYes;

  /// No description provided for @commonNo.
  ///
  /// In fr, this message translates to:
  /// **'Non'**
  String get commonNo;

  /// No description provided for @commonSearch.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un short...'**
  String get commonSearch;

  /// No description provided for @commonError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur'**
  String get commonError;

  /// No description provided for @commonErrorPrefix.
  ///
  /// In fr, this message translates to:
  /// **'Erreur: {error}'**
  String commonErrorPrefix(String error);

  /// No description provided for @actionValidate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get actionValidate;

  /// No description provided for @actionReject.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter'**
  String get actionReject;

  /// No description provided for @actionPublish.
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get actionPublish;

  /// No description provided for @actionWork.
  ///
  /// In fr, this message translates to:
  /// **'Travailler'**
  String get actionWork;

  /// No description provided for @actionComplete.
  ///
  /// In fr, this message translates to:
  /// **'Terminer'**
  String get actionComplete;

  /// No description provided for @actionStart.
  ///
  /// In fr, this message translates to:
  /// **'Commencer'**
  String get actionStart;

  /// No description provided for @shortLate.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get shortLate;

  /// No description provided for @shortChannels.
  ///
  /// In fr, this message translates to:
  /// **'Chaines'**
  String get shortChannels;

  /// No description provided for @shortSource.
  ///
  /// In fr, this message translates to:
  /// **'Source'**
  String get shortSource;

  /// No description provided for @shortPublication.
  ///
  /// In fr, this message translates to:
  /// **'Publication'**
  String get shortPublication;

  /// No description provided for @shortAssignment.
  ///
  /// In fr, this message translates to:
  /// **'Assignation'**
  String get shortAssignment;

  /// No description provided for @shortVideaste.
  ///
  /// In fr, this message translates to:
  /// **'Videaste'**
  String get shortVideaste;

  /// No description provided for @shortAssignedBy.
  ///
  /// In fr, this message translates to:
  /// **'Assigne par'**
  String get shortAssignedBy;

  /// No description provided for @shortDate.
  ///
  /// In fr, this message translates to:
  /// **'Date'**
  String get shortDate;

  /// No description provided for @shortDeadline.
  ///
  /// In fr, this message translates to:
  /// **'Deadline'**
  String get shortDeadline;

  /// No description provided for @shortDaysRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Jours restants'**
  String get shortDaysRemaining;

  /// No description provided for @shortTimeline.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get shortTimeline;

  /// No description provided for @shortTimelineRolled.
  ///
  /// In fr, this message translates to:
  /// **'Rolle'**
  String get shortTimelineRolled;

  /// No description provided for @shortTimelineRetained.
  ///
  /// In fr, this message translates to:
  /// **'Retenu'**
  String get shortTimelineRetained;

  /// No description provided for @shortTimelineAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assigne'**
  String get shortTimelineAssigned;

  /// No description provided for @shortTimelineCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Termine'**
  String get shortTimelineCompleted;

  /// No description provided for @shortTimelineValidated.
  ///
  /// In fr, this message translates to:
  /// **'Valide'**
  String get shortTimelineValidated;

  /// No description provided for @shortTimelinePublished.
  ///
  /// In fr, this message translates to:
  /// **'Publie'**
  String get shortTimelinePublished;

  /// No description provided for @shortTimelineRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejete'**
  String get shortTimelineRejected;

  /// No description provided for @shortCompletionTime.
  ///
  /// In fr, this message translates to:
  /// **'Temps de completion'**
  String get shortCompletionTime;

  /// No description provided for @shortCompletionTimeValue.
  ///
  /// In fr, this message translates to:
  /// **'{hours} heures'**
  String shortCompletionTimeValue(String hours);

  /// No description provided for @shortNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get shortNotes;

  /// No description provided for @shortAdminFeedback.
  ///
  /// In fr, this message translates to:
  /// **'Feedback admin'**
  String get shortAdminFeedback;

  /// No description provided for @shortVideoFile.
  ///
  /// In fr, this message translates to:
  /// **'Fichier video'**
  String get shortVideoFile;

  /// No description provided for @shortFileName.
  ///
  /// In fr, this message translates to:
  /// **'Nom'**
  String get shortFileName;

  /// No description provided for @shortFileSize.
  ///
  /// In fr, this message translates to:
  /// **'Taille'**
  String get shortFileSize;

  /// No description provided for @shortFileType.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get shortFileType;

  /// No description provided for @shortFileUpload.
  ///
  /// In fr, this message translates to:
  /// **'Upload'**
  String get shortFileUpload;

  /// No description provided for @shortTags.
  ///
  /// In fr, this message translates to:
  /// **'Tags'**
  String get shortTags;

  /// No description provided for @shortComments.
  ///
  /// In fr, this message translates to:
  /// **'Commentaires ({count})'**
  String shortComments(int count);

  /// No description provided for @shortErrorLoading.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement du short'**
  String get shortErrorLoading;

  /// No description provided for @dialogPublishTitle.
  ///
  /// In fr, this message translates to:
  /// **'Publier le short'**
  String get dialogPublishTitle;

  /// No description provided for @dialogPublishContent.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer la publication de \"{title}\" ?'**
  String dialogPublishContent(String title);

  /// No description provided for @dialogStartWorkTitle.
  ///
  /// In fr, this message translates to:
  /// **'Commencer le travail'**
  String get dialogStartWorkTitle;

  /// No description provided for @dialogStartWorkContent.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le debut du travail sur ce short ?'**
  String get dialogStartWorkContent;

  /// No description provided for @dialogStartWorkContentNamed.
  ///
  /// In fr, this message translates to:
  /// **'Commencer a travailler sur \"{title}\" ?'**
  String dialogStartWorkContentNamed(String title);

  /// No description provided for @dialogCompleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Terminer le travail'**
  String get dialogCompleteTitle;

  /// No description provided for @dialogCompleteContent.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer que le travail est termine ?'**
  String get dialogCompleteContent;

  /// No description provided for @dialogCompleteContentNamed.
  ///
  /// In fr, this message translates to:
  /// **'Marquer \"{title}\" comme termine ?'**
  String dialogCompleteContentNamed(String title);

  /// No description provided for @dialogValidateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Valider la video'**
  String get dialogValidateTitle;

  /// No description provided for @dialogValidateContent.
  ///
  /// In fr, this message translates to:
  /// **'Valider \"{title}\" ?'**
  String dialogValidateContent(String title);

  /// No description provided for @dialogRejectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter la video'**
  String get dialogRejectTitle;

  /// No description provided for @dialogRejectReasonLabel.
  ///
  /// In fr, this message translates to:
  /// **'Raison du rejet :'**
  String get dialogRejectReasonLabel;

  /// No description provided for @dialogRejectHint.
  ///
  /// In fr, this message translates to:
  /// **'Expliquez pourquoi vous rejetez cette video...'**
  String get dialogRejectHint;

  /// No description provided for @dialogRejectReasonRequired.
  ///
  /// In fr, this message translates to:
  /// **'La raison est obligatoire'**
  String get dialogRejectReasonRequired;

  /// No description provided for @dialogFeedbackHint.
  ///
  /// In fr, this message translates to:
  /// **'Feedback optionnel...'**
  String get dialogFeedbackHint;

  /// No description provided for @snackWorkStarted.
  ///
  /// In fr, this message translates to:
  /// **'Travail demarre !'**
  String get snackWorkStarted;

  /// No description provided for @snackVideoCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Video marquee comme terminee !'**
  String get snackVideoCompleted;

  /// No description provided for @snackVideoValidated.
  ///
  /// In fr, this message translates to:
  /// **'Video validee avec succes'**
  String get snackVideoValidated;

  /// No description provided for @snackVideoRejected.
  ///
  /// In fr, this message translates to:
  /// **'Video rejetee'**
  String get snackVideoRejected;

  /// No description provided for @emptyNoVideosToValidate.
  ///
  /// In fr, this message translates to:
  /// **'Aucune video a valider'**
  String get emptyNoVideosToValidate;

  /// No description provided for @emptyNoValidatedVideos.
  ///
  /// In fr, this message translates to:
  /// **'Aucune video validee'**
  String get emptyNoValidatedVideos;

  /// No description provided for @emptyNoRejectedVideos.
  ///
  /// In fr, this message translates to:
  /// **'Aucune video rejetee'**
  String get emptyNoRejectedVideos;

  /// No description provided for @emptyNoAssignedVideos.
  ///
  /// In fr, this message translates to:
  /// **'Aucune video assignee'**
  String get emptyNoAssignedVideos;

  /// No description provided for @emptyNoInProgressVideos.
  ///
  /// In fr, this message translates to:
  /// **'Aucune video en cours'**
  String get emptyNoInProgressVideos;

  /// No description provided for @emptyNoCompletedVideos.
  ///
  /// In fr, this message translates to:
  /// **'Aucune video terminee'**
  String get emptyNoCompletedVideos;

  /// No description provided for @errorLoadingVideos.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement des videos'**
  String get errorLoadingVideos;

  /// No description provided for @errorLoadingStats.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement des statistiques'**
  String get errorLoadingStats;

  /// No description provided for @errorLoadingShort.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement du short'**
  String get errorLoadingShort;

  /// No description provided for @errorLoadingProfile.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement du profil'**
  String get errorLoadingProfile;

  /// No description provided for @errorLoadingNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement des notifications'**
  String get errorLoadingNotifications;

  /// No description provided for @errorLoading.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement'**
  String get errorLoading;

  /// No description provided for @statsAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assignees'**
  String get statsAssigned;

  /// No description provided for @statsCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Completees'**
  String get statsCompleted;

  /// No description provided for @statsRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux'**
  String get statsRate;

  /// No description provided for @statsToValidate.
  ///
  /// In fr, this message translates to:
  /// **'A valider'**
  String get statsToValidate;

  /// No description provided for @statsValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validees'**
  String get statsValidated;

  /// No description provided for @statsRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejetees'**
  String get statsRejected;

  /// No description provided for @notificationsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In fr, this message translates to:
  /// **'Tout lire'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification'**
  String get notificationsEmpty;

  /// No description provided for @timeJustNow.
  ///
  /// In fr, this message translates to:
  /// **'A l\'instant'**
  String get timeJustNow;

  /// No description provided for @timeMinutesAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {minutes}min'**
  String timeMinutesAgo(int minutes);

  /// No description provided for @timeHoursAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {hours}h'**
  String timeHoursAgo(int hours);

  /// No description provided for @timeDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'Il y a {days}j'**
  String timeDaysAgo(int days);

  /// No description provided for @notifVideoAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Short assigné'**
  String get notifVideoAssigned;

  /// No description provided for @notifDeadlineReminder.
  ///
  /// In fr, this message translates to:
  /// **'Rappel deadline'**
  String get notifDeadlineReminder;

  /// No description provided for @notifVideoCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Short terminé'**
  String get notifVideoCompleted;

  /// No description provided for @notifVideoValidated.
  ///
  /// In fr, this message translates to:
  /// **'Short validé'**
  String get notifVideoValidated;

  /// No description provided for @notifVideoRejected.
  ///
  /// In fr, this message translates to:
  /// **'Short rejeté'**
  String get notifVideoRejected;

  /// No description provided for @notifAccountBlocked.
  ///
  /// In fr, this message translates to:
  /// **'Compte bloqué'**
  String get notifAccountBlocked;

  /// No description provided for @notifAccountUnblocked.
  ///
  /// In fr, this message translates to:
  /// **'Compte débloqué'**
  String get notifAccountUnblocked;

  /// No description provided for @profileAccountInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations du compte'**
  String get profileAccountInfo;

  /// No description provided for @profileEmail.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get profileEmail;

  /// No description provided for @profilePhone.
  ///
  /// In fr, this message translates to:
  /// **'Telephone'**
  String get profilePhone;

  /// No description provided for @profileStatus.
  ///
  /// In fr, this message translates to:
  /// **'Status'**
  String get profileStatus;

  /// No description provided for @profileActive.
  ///
  /// In fr, this message translates to:
  /// **'Actif'**
  String get profileActive;

  /// No description provided for @profileBlocked.
  ///
  /// In fr, this message translates to:
  /// **'Bloque'**
  String get profileBlocked;

  /// No description provided for @profileLastLogin.
  ///
  /// In fr, this message translates to:
  /// **'Derniere connexion'**
  String get profileLastLogin;

  /// No description provided for @profileMemberSince.
  ///
  /// In fr, this message translates to:
  /// **'Membre depuis'**
  String get profileMemberSince;

  /// No description provided for @profileStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques'**
  String get profileStats;

  /// No description provided for @profileStatsAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assignees'**
  String get profileStatsAssigned;

  /// No description provided for @profileStatsCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminees'**
  String get profileStatsCompleted;

  /// No description provided for @profileStatsInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get profileStatsInProgress;

  /// No description provided for @profileStatsRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux'**
  String get profileStatsRate;

  /// No description provided for @profileStatsThisMonth.
  ///
  /// In fr, this message translates to:
  /// **'Ce mois'**
  String get profileStatsThisMonth;

  /// No description provided for @profileStatsLate.
  ///
  /// In fr, this message translates to:
  /// **'En retard'**
  String get profileStatsLate;

  /// No description provided for @profileNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get profileNotifications;

  /// No description provided for @profileEmailNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications email'**
  String get profileEmailNotifications;

  /// No description provided for @profileWhatsappNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications WhatsApp'**
  String get profileWhatsappNotifications;

  /// No description provided for @profileWhatsappLinked.
  ///
  /// In fr, this message translates to:
  /// **'WhatsApp lie'**
  String get profileWhatsappLinked;

  /// No description provided for @profileChangePassword.
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get profileChangePassword;

  /// No description provided for @commentAddPlaceholder.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un commentaire...'**
  String get commentAddPlaceholder;

  /// No description provided for @commentEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun commentaire'**
  String get commentEmpty;

  /// No description provided for @commentTimeNow.
  ///
  /// In fr, this message translates to:
  /// **'maintenant'**
  String get commentTimeNow;

  /// No description provided for @commentTimeMinutes.
  ///
  /// In fr, this message translates to:
  /// **'{minutes}min'**
  String commentTimeMinutes(int minutes);

  /// No description provided for @commentTimeHours.
  ///
  /// In fr, this message translates to:
  /// **'{hours}h'**
  String commentTimeHours(int hours);

  /// No description provided for @commentTimeDays.
  ///
  /// In fr, this message translates to:
  /// **'{days}j'**
  String commentTimeDays(int days);

  /// No description provided for @commentTimeMonths.
  ///
  /// In fr, this message translates to:
  /// **'{months} mois'**
  String commentTimeMonths(int months);

  /// No description provided for @adminRecentActivity.
  ///
  /// In fr, this message translates to:
  /// **'Activité récente'**
  String get adminRecentActivity;

  /// No description provided for @adminTotalVideos.
  ///
  /// In fr, this message translates to:
  /// **'Total vidéos'**
  String get adminTotalVideos;

  /// No description provided for @adminRolled.
  ///
  /// In fr, this message translates to:
  /// **'Roulées'**
  String get adminRolled;

  /// No description provided for @adminAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assignées'**
  String get adminAssigned;

  /// No description provided for @adminPublished.
  ///
  /// In fr, this message translates to:
  /// **'Publiées'**
  String get adminPublished;

  /// No description provided for @adminNoRecentActivity.
  ///
  /// In fr, this message translates to:
  /// **'Aucune activité récente'**
  String get adminNoRecentActivity;

  /// No description provided for @contentTypeVaSansEdit.
  ///
  /// In fr, this message translates to:
  /// **'VA Sans Edit'**
  String get contentTypeVaSansEdit;

  /// No description provided for @contentTypeVaAvecEdit.
  ///
  /// In fr, this message translates to:
  /// **'VA Avec Edit'**
  String get contentTypeVaAvecEdit;

  /// No description provided for @contentTypeVfSansEdit.
  ///
  /// In fr, this message translates to:
  /// **'VF Sans Edit'**
  String get contentTypeVfSansEdit;

  /// No description provided for @contentTypeVfAvecEdit.
  ///
  /// In fr, this message translates to:
  /// **'VF Avec Edit'**
  String get contentTypeVfAvecEdit;

  /// No description provided for @contentTypeVoSansEdit.
  ///
  /// In fr, this message translates to:
  /// **'VO Sans Edit'**
  String get contentTypeVoSansEdit;

  /// No description provided for @contentTypeVoAvecEdit.
  ///
  /// In fr, this message translates to:
  /// **'VO Avec Edit'**
  String get contentTypeVoAvecEdit;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}

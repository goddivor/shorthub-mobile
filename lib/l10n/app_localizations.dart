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

  /// No description provided for @drawerChangeBanner.
  ///
  /// In fr, this message translates to:
  /// **'Changer la bannière'**
  String get drawerChangeBanner;

  /// No description provided for @drawerRemoveBanner.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la bannière'**
  String get drawerRemoveBanner;

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

  /// No description provided for @analyticsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Analytiques'**
  String get analyticsTitle;

  /// No description provided for @analyticsStatusDistribution.
  ///
  /// In fr, this message translates to:
  /// **'Répartition par statut'**
  String get analyticsStatusDistribution;

  /// No description provided for @analyticsWeeklyActivity.
  ///
  /// In fr, this message translates to:
  /// **'Activité hebdomadaire'**
  String get analyticsWeeklyActivity;

  /// No description provided for @analyticsCompletionTrend.
  ///
  /// In fr, this message translates to:
  /// **'Tendance de complétion (30j)'**
  String get analyticsCompletionTrend;

  /// No description provided for @analyticsKeyMetrics.
  ///
  /// In fr, this message translates to:
  /// **'Métriques clés'**
  String get analyticsKeyMetrics;

  /// No description provided for @analyticsCompletionRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de complétion'**
  String get analyticsCompletionRate;

  /// No description provided for @analyticsAvgPerWeek.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne/semaine'**
  String get analyticsAvgPerWeek;

  /// No description provided for @analyticsLateRate.
  ///
  /// In fr, this message translates to:
  /// **'Taux de retard'**
  String get analyticsLateRate;

  /// No description provided for @analyticsNoData.
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée disponible'**
  String get analyticsNoData;

  /// No description provided for @navAnalytics.
  ///
  /// In fr, this message translates to:
  /// **'Analytiques'**
  String get navAnalytics;

  /// No description provided for @analyticsWeekLabel.
  ///
  /// In fr, this message translates to:
  /// **'S{week}'**
  String analyticsWeekLabel(int week);

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

  /// No description provided for @shareOverlayTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une chaine source'**
  String get shareOverlayTitle;

  /// No description provided for @shareOverlayContentType.
  ///
  /// In fr, this message translates to:
  /// **'Type de contenu'**
  String get shareOverlayContentType;

  /// No description provided for @shareOverlayAddChannel.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter la chaine'**
  String get shareOverlayAddChannel;

  /// No description provided for @shareOverlayAdding.
  ///
  /// In fr, this message translates to:
  /// **'Ajout en cours...'**
  String get shareOverlayAdding;

  /// No description provided for @shareOverlaySuccess.
  ///
  /// In fr, this message translates to:
  /// **'Chaine ajoutee avec succes !'**
  String get shareOverlaySuccess;

  /// No description provided for @shareOverlayAlreadyExists.
  ///
  /// In fr, this message translates to:
  /// **'Cette chaine existe deja'**
  String get shareOverlayAlreadyExists;

  /// No description provided for @shareOverlayClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get shareOverlayClose;

  /// No description provided for @shareOverlayLoginRequired.
  ///
  /// In fr, this message translates to:
  /// **'Connexion requise'**
  String get shareOverlayLoginRequired;

  /// No description provided for @shareOverlayLoginHint.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous a ShortHub pour ajouter des chaines sources'**
  String get shareOverlayLoginHint;

  /// No description provided for @drawerSettings.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get drawerSettings;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get settingsLanguage;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l\'application'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageFrench.
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get settingsLanguageFrench;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In fr, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsTheme.
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get settingsTheme;

  /// No description provided for @settingsThemeDesc.
  ///
  /// In fr, this message translates to:
  /// **'Choisir l\'apparence de l\'application'**
  String get settingsThemeDesc;

  /// No description provided for @settingsThemeLight.
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeBlack.
  ///
  /// In fr, this message translates to:
  /// **'Noir'**
  String get settingsThemeBlack;

  /// No description provided for @settingsAbout.
  ///
  /// In fr, this message translates to:
  /// **'À propos'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get settingsVersion;

  /// No description provided for @modalValidateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Valider le short'**
  String get modalValidateTitle;

  /// No description provided for @modalValidateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Short validé avec succès !'**
  String get modalValidateSuccess;

  /// No description provided for @modalFeedbackOptional.
  ///
  /// In fr, this message translates to:
  /// **'Feedback (optionnel)'**
  String get modalFeedbackOptional;

  /// No description provided for @modalFeedbackHint.
  ///
  /// In fr, this message translates to:
  /// **'Commentaire pour le vidéaste...'**
  String get modalFeedbackHint;

  /// No description provided for @modalRejectTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rejeter le short'**
  String get modalRejectTitle;

  /// No description provided for @modalRejectSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Short rejeté'**
  String get modalRejectSuccess;

  /// No description provided for @modalRejectReason.
  ///
  /// In fr, this message translates to:
  /// **'Raison du rejet *'**
  String get modalRejectReason;

  /// No description provided for @modalRejectReasonHint.
  ///
  /// In fr, this message translates to:
  /// **'Expliquer la raison du rejet...'**
  String get modalRejectReasonHint;

  /// No description provided for @modalRejectDeleteFile.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le fichier vidéo'**
  String get modalRejectDeleteFile;

  /// No description provided for @modalRejectDeleteFileDefault.
  ///
  /// In fr, this message translates to:
  /// **'Fichier sur Google Drive'**
  String get modalRejectDeleteFileDefault;

  /// No description provided for @changePasswordTitle.
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordOld.
  ///
  /// In fr, this message translates to:
  /// **'Ancien mot de passe'**
  String get changePasswordOld;

  /// No description provided for @changePasswordNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get changePasswordNew;

  /// No description provided for @changePasswordConfirmField.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get changePasswordConfirmField;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe modifié avec succès'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordAllRequired.
  ///
  /// In fr, this message translates to:
  /// **'Tous les champs sont requis'**
  String get changePasswordAllRequired;

  /// No description provided for @changePasswordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get changePasswordMinLength;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In fr, this message translates to:
  /// **'Les mots de passe ne correspondent pas'**
  String get changePasswordMismatch;

  /// No description provided for @modalAssignTitle.
  ///
  /// In fr, this message translates to:
  /// **'Assigner le short'**
  String get modalAssignTitle;

  /// No description provided for @modalAssignSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Short assigné avec succès !'**
  String get modalAssignSuccess;

  /// No description provided for @modalAssignVideaste.
  ///
  /// In fr, this message translates to:
  /// **'Vidéaste'**
  String get modalAssignVideaste;

  /// No description provided for @modalAssignSelectVideaste.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner un vidéaste'**
  String get modalAssignSelectVideaste;

  /// No description provided for @modalAssignErrorVideastes.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement vidéastes'**
  String get modalAssignErrorVideastes;

  /// No description provided for @modalAssignChannel.
  ///
  /// In fr, this message translates to:
  /// **'Chaîne de publication'**
  String get modalAssignChannel;

  /// No description provided for @modalAssignSelectChannel.
  ///
  /// In fr, this message translates to:
  /// **'Sélectionner une chaîne'**
  String get modalAssignSelectChannel;

  /// No description provided for @modalAssignErrorChannels.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement chaînes'**
  String get modalAssignErrorChannels;

  /// No description provided for @modalAssignDeadline.
  ///
  /// In fr, this message translates to:
  /// **'Deadline'**
  String get modalAssignDeadline;

  /// No description provided for @modalAssignPickDate.
  ///
  /// In fr, this message translates to:
  /// **'Choisir une date limite'**
  String get modalAssignPickDate;

  /// No description provided for @modalAssignNotes.
  ///
  /// In fr, this message translates to:
  /// **'Notes (optionnel)'**
  String get modalAssignNotes;

  /// No description provided for @modalAssignNotesHint.
  ///
  /// In fr, this message translates to:
  /// **'Instructions pour le vidéaste...'**
  String get modalAssignNotesHint;

  /// No description provided for @modalAssignButton.
  ///
  /// In fr, this message translates to:
  /// **'Assigner'**
  String get modalAssignButton;

  /// No description provided for @modalRollLoading.
  ///
  /// In fr, this message translates to:
  /// **'Génération du short...'**
  String get modalRollLoading;

  /// No description provided for @modalRollClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get modalRollClose;

  /// No description provided for @modalRollIgnore.
  ///
  /// In fr, this message translates to:
  /// **'Ignorer'**
  String get modalRollIgnore;

  /// No description provided for @modalRollRetain.
  ///
  /// In fr, this message translates to:
  /// **'Retenir'**
  String get modalRollRetain;

  /// No description provided for @channelAddSource.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un canal source'**
  String get channelAddSource;

  /// No description provided for @channelAddPub.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un canal de publication'**
  String get channelAddPub;

  /// No description provided for @channelUrlLabel.
  ///
  /// In fr, this message translates to:
  /// **'URL YouTube'**
  String get channelUrlLabel;

  /// No description provided for @channelUrlHint.
  ///
  /// In fr, this message translates to:
  /// **'https://youtube.com/@nomdelachaine'**
  String get channelUrlHint;

  /// No description provided for @channelUrlHelp.
  ///
  /// In fr, this message translates to:
  /// **'Collez l\'URL d\'une chaîne YouTube, d\'une vidéo ou d\'un short'**
  String get channelUrlHelp;

  /// No description provided for @channelContentType.
  ///
  /// In fr, this message translates to:
  /// **'Type de contenu'**
  String get channelContentType;

  /// No description provided for @channelUrlRequired.
  ///
  /// In fr, this message translates to:
  /// **'L\'URL YouTube est requise'**
  String get channelUrlRequired;

  /// No description provided for @channelSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un canal...'**
  String get channelSearchHint;

  /// No description provided for @channelDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer le canal'**
  String get channelDeleteTitle;

  /// No description provided for @channelDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer {name} ?'**
  String channelDeleteConfirm(String name);

  /// No description provided for @channelDeleted.
  ///
  /// In fr, this message translates to:
  /// **'{name} a été supprimé'**
  String channelDeleted(String name);

  /// No description provided for @channelEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le canal'**
  String get channelEditTitle;

  /// No description provided for @channelEditSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Canal modifié avec succès'**
  String get channelEditSuccess;

  /// No description provided for @commonEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get commonEdit;

  /// No description provided for @commonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get commonDelete;

  /// No description provided for @commonAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get commonAdd;

  /// No description provided for @commonClose.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get commonClose;

  /// No description provided for @usersAllRoles.
  ///
  /// In fr, this message translates to:
  /// **'Tous les rôles'**
  String get usersAllRoles;

  /// No description provided for @usersSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un membre...'**
  String get usersSearchHint;

  /// No description provided for @usersEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun membre trouvé'**
  String get usersEmpty;

  /// No description provided for @usersNoUsers.
  ///
  /// In fr, this message translates to:
  /// **'Aucun utilisateur'**
  String get usersNoUsers;

  /// No description provided for @usersInviteHint.
  ///
  /// In fr, this message translates to:
  /// **'Commencez par inviter des membres'**
  String get usersInviteHint;

  /// No description provided for @usersInviteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Inviter un utilisateur'**
  String get usersInviteTitle;

  /// No description provided for @usersUsername.
  ///
  /// In fr, this message translates to:
  /// **'Nom d\'utilisateur'**
  String get usersUsername;

  /// No description provided for @usersUsernameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex: johndoe'**
  String get usersUsernameHint;

  /// No description provided for @usersEmailOptional.
  ///
  /// In fr, this message translates to:
  /// **'Email (optionnel)'**
  String get usersEmailOptional;

  /// No description provided for @usersEmailHint.
  ///
  /// In fr, this message translates to:
  /// **'exemple@email.com'**
  String get usersEmailHint;

  /// No description provided for @usersPassword.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get usersPassword;

  /// No description provided for @usersPasswordHint.
  ///
  /// In fr, this message translates to:
  /// **'Minimum 6 caractères'**
  String get usersPasswordHint;

  /// No description provided for @usersRole.
  ///
  /// In fr, this message translates to:
  /// **'Rôle'**
  String get usersRole;

  /// No description provided for @usersUsernameRequired.
  ///
  /// In fr, this message translates to:
  /// **'Le nom d\'utilisateur est requis'**
  String get usersUsernameRequired;

  /// No description provided for @usersPasswordMinLength.
  ///
  /// In fr, this message translates to:
  /// **'Le mot de passe doit contenir au moins 6 caractères'**
  String get usersPasswordMinLength;

  /// No description provided for @usersInviteButton.
  ///
  /// In fr, this message translates to:
  /// **'Inviter'**
  String get usersInviteButton;

  /// No description provided for @usersBlockConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir bloquer {name} ? Il ne pourra plus accéder à l\'application.'**
  String usersBlockConfirm(String name);

  /// No description provided for @usersBlocked.
  ///
  /// In fr, this message translates to:
  /// **'{name} a été bloqué'**
  String usersBlocked(String name);

  /// No description provided for @usersBlockButton.
  ///
  /// In fr, this message translates to:
  /// **'Bloquer'**
  String get usersBlockButton;

  /// No description provided for @usersUnblockConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir débloquer {name} ?'**
  String usersUnblockConfirm(String name);

  /// No description provided for @usersUnblocked.
  ///
  /// In fr, this message translates to:
  /// **'{name} a été débloqué'**
  String usersUnblocked(String name);

  /// No description provided for @usersUnblockButton.
  ///
  /// In fr, this message translates to:
  /// **'Débloquer'**
  String get usersUnblockButton;

  /// No description provided for @usersDeleted.
  ///
  /// In fr, this message translates to:
  /// **'{name} a été supprimé'**
  String usersDeleted(String name);

  /// No description provided for @usersDeleteButton.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get usersDeleteButton;

  /// No description provided for @usersDeleteConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Êtes-vous sûr de vouloir supprimer {name} ? Cette action est irréversible.'**
  String usersDeleteConfirm(String name);

  /// No description provided for @publishSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Short publié avec succès !'**
  String get publishSuccess;

  /// No description provided for @rollingGenerate.
  ///
  /// In fr, this message translates to:
  /// **'Générer'**
  String get rollingGenerate;

  /// No description provided for @userViewProfile.
  ///
  /// In fr, this message translates to:
  /// **'Voir le profil'**
  String get userViewProfile;

  /// No description provided for @channelViewChannel.
  ///
  /// In fr, this message translates to:
  /// **'Voir la chaîne'**
  String get channelViewChannel;

  /// No description provided for @commonSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher...'**
  String get commonSearchHint;

  /// No description provided for @routeNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Route non trouvée : {route}'**
  String routeNotFound(String route);

  /// No description provided for @channelNoSource.
  ///
  /// In fr, this message translates to:
  /// **'Aucun canal source'**
  String get channelNoSource;

  /// No description provided for @channelAddedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Canal {name} ajouté avec succès'**
  String channelAddedSuccess(String name);

  /// No description provided for @usersCreatedSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Utilisateur {name} créé avec succès'**
  String usersCreatedSuccess(String name);

  /// No description provided for @channelSelected.
  ///
  /// In fr, this message translates to:
  /// **'Canal : {name}'**
  String channelSelected(String name);

  /// No description provided for @sortTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trier par'**
  String get sortTitle;

  /// No description provided for @sortLastAdded.
  ///
  /// In fr, this message translates to:
  /// **'Dernier ajouté'**
  String get sortLastAdded;

  /// No description provided for @sortNameAZ.
  ///
  /// In fr, this message translates to:
  /// **'Nom (A-Z)'**
  String get sortNameAZ;

  /// No description provided for @sortNameZA.
  ///
  /// In fr, this message translates to:
  /// **'Nom (Z-A)'**
  String get sortNameZA;

  /// No description provided for @sortMostVideos.
  ///
  /// In fr, this message translates to:
  /// **'Plus de vidéos'**
  String get sortMostVideos;

  /// No description provided for @sortLeastVideos.
  ///
  /// In fr, this message translates to:
  /// **'Moins de vidéos'**
  String get sortLeastVideos;

  /// No description provided for @filterByType.
  ///
  /// In fr, this message translates to:
  /// **'Filtrer par type'**
  String get filterByType;

  /// No description provided for @filterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get filterAll;

  /// No description provided for @channelSourcesTab.
  ///
  /// In fr, this message translates to:
  /// **'Canaux Sources'**
  String get channelSourcesTab;

  /// No description provided for @channelPubTab.
  ///
  /// In fr, this message translates to:
  /// **'Canaux de Publication'**
  String get channelPubTab;

  /// No description provided for @channelNoResults.
  ///
  /// In fr, this message translates to:
  /// **'Aucun canal trouvé'**
  String get channelNoResults;

  /// No description provided for @channelNoPub.
  ///
  /// In fr, this message translates to:
  /// **'Aucun canal de publication'**
  String get channelNoPub;

  /// No description provided for @channelAddToStart.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un canal pour commencer'**
  String get channelAddToStart;

  /// No description provided for @channelAddToPublish.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez un canal pour publier'**
  String get channelAddToPublish;

  /// No description provided for @channelLoadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement des canaux'**
  String get channelLoadingError;

  /// No description provided for @rollingStatsRolled.
  ///
  /// In fr, this message translates to:
  /// **'Rollés'**
  String get rollingStatsRolled;

  /// No description provided for @rollingStatsRetained.
  ///
  /// In fr, this message translates to:
  /// **'Retenus'**
  String get rollingStatsRetained;

  /// No description provided for @rollingStatsAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assignés'**
  String get rollingStatsAssigned;

  /// No description provided for @rollingStatsInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get rollingStatsInProgress;

  /// No description provided for @rollingStatsCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminés'**
  String get rollingStatsCompleted;

  /// No description provided for @rollingStatsValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validés'**
  String get rollingStatsValidated;

  /// No description provided for @rollingStatsPublished.
  ///
  /// In fr, this message translates to:
  /// **'Publiés'**
  String get rollingStatsPublished;

  /// No description provided for @rollingStatsRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejetés'**
  String get rollingStatsRejected;

  /// No description provided for @rollingLoadingChannels.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des chaînes...'**
  String get rollingLoadingChannels;

  /// No description provided for @rollingLoadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement des chaînes'**
  String get rollingLoadingError;

  /// No description provided for @rollingNoChannels.
  ///
  /// In fr, this message translates to:
  /// **'Aucune chaîne source'**
  String get rollingNoChannels;

  /// No description provided for @filterWithEdit.
  ///
  /// In fr, this message translates to:
  /// **'Avec Edit'**
  String get filterWithEdit;

  /// No description provided for @filterWithoutEdit.
  ///
  /// In fr, this message translates to:
  /// **'Sans Edit'**
  String get filterWithoutEdit;

  /// No description provided for @trackingStatsTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get trackingStatsTotal;

  /// No description provided for @trackingStatsAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Assignés'**
  String get trackingStatsAssigned;

  /// No description provided for @trackingStatsInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get trackingStatsInProgress;

  /// No description provided for @trackingStatsCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminés'**
  String get trackingStatsCompleted;

  /// No description provided for @trackingStatsValidated.
  ///
  /// In fr, this message translates to:
  /// **'Validés'**
  String get trackingStatsValidated;

  /// No description provided for @trackingStatsRejected.
  ///
  /// In fr, this message translates to:
  /// **'Rejetés'**
  String get trackingStatsRejected;

  /// No description provided for @trackingStatsPublished.
  ///
  /// In fr, this message translates to:
  /// **'Publiés'**
  String get trackingStatsPublished;

  /// No description provided for @trackingAllStatuses.
  ///
  /// In fr, this message translates to:
  /// **'Tous les statuts'**
  String get trackingAllStatuses;

  /// No description provided for @trackingSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un short...'**
  String get trackingSearchHint;

  /// No description provided for @trackingLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des shorts...'**
  String get trackingLoading;

  /// No description provided for @trackingLoadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur chargement des shorts'**
  String get trackingLoadingError;

  /// No description provided for @trackingNoShortsFiltered.
  ///
  /// In fr, this message translates to:
  /// **'Aucun short ne correspond aux filtres'**
  String get trackingNoShortsFiltered;

  /// No description provided for @trackingNoShorts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun short dans le workflow'**
  String get trackingNoShorts;

  /// No description provided for @usersLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des utilisateurs...'**
  String get usersLoading;

  /// No description provided for @usersLoadingError.
  ///
  /// In fr, this message translates to:
  /// **'Erreur lors du chargement des utilisateurs'**
  String get usersLoadingError;

  /// No description provided for @usersIrreversible.
  ///
  /// In fr, this message translates to:
  /// **'Cette action est irréversible'**
  String get usersIrreversible;
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

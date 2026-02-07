// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ShortHub';

  @override
  String get appTagline => 'Gestion collaborative de YouTube Shorts';

  @override
  String get appTaglineSplash => 'Gestion Collaborative de Shorts';

  @override
  String get loading => 'Chargement...';

  @override
  String get loadingVideos => 'Chargement des videos...';

  @override
  String get loadingNotifications => 'Chargement des notifications...';

  @override
  String get loadingProfile => 'Chargement du profil...';

  @override
  String get loadingShort => 'Chargement du short...';

  @override
  String get loginUsername => 'Nom d\'utilisateur';

  @override
  String get loginUsernameHint => 'Entrez votre nom d\'utilisateur';

  @override
  String get loginPassword => 'Mot de passe';

  @override
  String get loginPasswordHint => 'Entrez votre mot de passe';

  @override
  String get loginButton => 'Se connecter';

  @override
  String get loginError => 'Erreur de connexion. Vérifiez vos identifiants.';

  @override
  String get loginUsernameRequired => 'Le nom d\'utilisateur est requis';

  @override
  String get loginUsernameMinLength =>
      'Le nom d\'utilisateur doit contenir au moins 3 caractères';

  @override
  String get loginPasswordRequired => 'Le mot de passe est requis';

  @override
  String get loginPasswordMinLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get noUserConnected => 'Aucun utilisateur connecté';

  @override
  String get userNotConnected => 'Utilisateur non connecte';

  @override
  String get navNavigation => 'NAVIGATION';

  @override
  String get navSettings => 'PARAMÈTRES';

  @override
  String get navTracking => 'Suivi';

  @override
  String get navRolling => 'Rolling';

  @override
  String get navChannels => 'Canaux';

  @override
  String get navTeam => 'Équipe';

  @override
  String get navAssigned => 'Assignées';

  @override
  String get navInProgress => 'En cours';

  @override
  String get navCompleted => 'Terminées';

  @override
  String get navToValidate => 'À valider';

  @override
  String get navValidated => 'Validées';

  @override
  String get navRejected => 'Rejetées';

  @override
  String get drawerProfile => 'Mon profil';

  @override
  String get drawerDarkMode => 'Mode sombre';

  @override
  String get drawerLanguage => 'Langue';

  @override
  String get drawerLogout => 'Déconnexion';

  @override
  String get drawerLogoutConfirm =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get drawerNoEmail => 'Aucun email';

  @override
  String get roleAdmin => 'Administrateur';

  @override
  String get roleVideaste => 'Vidéaste';

  @override
  String get roleAssistant => 'Assistant';

  @override
  String get statusRolled => 'Rollé';

  @override
  String get statusRetained => 'Retenu';

  @override
  String get statusRejected => 'Rejeté';

  @override
  String get statusAssigned => 'Assigné';

  @override
  String get statusInProgress => 'En cours';

  @override
  String get statusCompleted => 'Terminé';

  @override
  String get statusValidated => 'Validé';

  @override
  String get statusPublished => 'Publié';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonView => 'Voir';

  @override
  String get commonViewDetails => 'Voir les details';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonOops => 'Oups !';

  @override
  String get commonYes => 'Oui';

  @override
  String get commonNo => 'Non';

  @override
  String get commonSearch => 'Rechercher un short...';

  @override
  String get commonError => 'Erreur';

  @override
  String commonErrorPrefix(String error) {
    return 'Erreur: $error';
  }

  @override
  String get actionValidate => 'Valider';

  @override
  String get actionReject => 'Rejeter';

  @override
  String get actionPublish => 'Publier';

  @override
  String get actionWork => 'Travailler';

  @override
  String get actionComplete => 'Terminer';

  @override
  String get actionStart => 'Commencer';

  @override
  String get shortLate => 'En retard';

  @override
  String get shortChannels => 'Chaines';

  @override
  String get shortSource => 'Source';

  @override
  String get shortPublication => 'Publication';

  @override
  String get shortAssignment => 'Assignation';

  @override
  String get shortVideaste => 'Videaste';

  @override
  String get shortAssignedBy => 'Assigne par';

  @override
  String get shortDate => 'Date';

  @override
  String get shortDeadline => 'Deadline';

  @override
  String get shortDaysRemaining => 'Jours restants';

  @override
  String get shortTimeline => 'Historique';

  @override
  String get shortTimelineRolled => 'Rolle';

  @override
  String get shortTimelineRetained => 'Retenu';

  @override
  String get shortTimelineAssigned => 'Assigne';

  @override
  String get shortTimelineCompleted => 'Termine';

  @override
  String get shortTimelineValidated => 'Valide';

  @override
  String get shortTimelinePublished => 'Publie';

  @override
  String get shortTimelineRejected => 'Rejete';

  @override
  String get shortCompletionTime => 'Temps de completion';

  @override
  String shortCompletionTimeValue(String hours) {
    return '$hours heures';
  }

  @override
  String get shortNotes => 'Notes';

  @override
  String get shortAdminFeedback => 'Feedback admin';

  @override
  String get shortVideoFile => 'Fichier video';

  @override
  String get shortFileName => 'Nom';

  @override
  String get shortFileSize => 'Taille';

  @override
  String get shortFileType => 'Type';

  @override
  String get shortFileUpload => 'Upload';

  @override
  String get shortTags => 'Tags';

  @override
  String shortComments(int count) {
    return 'Commentaires ($count)';
  }

  @override
  String get shortErrorLoading => 'Erreur chargement du short';

  @override
  String get dialogPublishTitle => 'Publier le short';

  @override
  String dialogPublishContent(String title) {
    return 'Confirmer la publication de \"$title\" ?';
  }

  @override
  String get dialogStartWorkTitle => 'Commencer le travail';

  @override
  String get dialogStartWorkContent =>
      'Confirmer le debut du travail sur ce short ?';

  @override
  String dialogStartWorkContentNamed(String title) {
    return 'Commencer a travailler sur \"$title\" ?';
  }

  @override
  String get dialogCompleteTitle => 'Terminer le travail';

  @override
  String get dialogCompleteContent => 'Confirmer que le travail est termine ?';

  @override
  String dialogCompleteContentNamed(String title) {
    return 'Marquer \"$title\" comme termine ?';
  }

  @override
  String get dialogValidateTitle => 'Valider la video';

  @override
  String dialogValidateContent(String title) {
    return 'Valider \"$title\" ?';
  }

  @override
  String get dialogRejectTitle => 'Rejeter la video';

  @override
  String get dialogRejectReasonLabel => 'Raison du rejet :';

  @override
  String get dialogRejectHint =>
      'Expliquez pourquoi vous rejetez cette video...';

  @override
  String get dialogRejectReasonRequired => 'La raison est obligatoire';

  @override
  String get dialogFeedbackHint => 'Feedback optionnel...';

  @override
  String get snackWorkStarted => 'Travail demarre !';

  @override
  String get snackVideoCompleted => 'Video marquee comme terminee !';

  @override
  String get snackVideoValidated => 'Video validee avec succes';

  @override
  String get snackVideoRejected => 'Video rejetee';

  @override
  String get emptyNoVideosToValidate => 'Aucune video a valider';

  @override
  String get emptyNoValidatedVideos => 'Aucune video validee';

  @override
  String get emptyNoRejectedVideos => 'Aucune video rejetee';

  @override
  String get emptyNoAssignedVideos => 'Aucune video assignee';

  @override
  String get emptyNoInProgressVideos => 'Aucune video en cours';

  @override
  String get emptyNoCompletedVideos => 'Aucune video terminee';

  @override
  String get errorLoadingVideos => 'Erreur lors du chargement des videos';

  @override
  String get errorLoadingStats => 'Erreur lors du chargement des statistiques';

  @override
  String get errorLoadingShort => 'Erreur chargement du short';

  @override
  String get errorLoadingProfile => 'Erreur chargement du profil';

  @override
  String get errorLoadingNotifications => 'Erreur chargement des notifications';

  @override
  String get errorLoading => 'Erreur lors du chargement';

  @override
  String get statsAssigned => 'Assignees';

  @override
  String get statsCompleted => 'Completees';

  @override
  String get statsRate => 'Taux';

  @override
  String get statsToValidate => 'A valider';

  @override
  String get statsValidated => 'Validees';

  @override
  String get statsRejected => 'Rejetees';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Tout lire';

  @override
  String get notificationsEmpty => 'Aucune notification';

  @override
  String get timeJustNow => 'A l\'instant';

  @override
  String timeMinutesAgo(int minutes) {
    return 'Il y a ${minutes}min';
  }

  @override
  String timeHoursAgo(int hours) {
    return 'Il y a ${hours}h';
  }

  @override
  String timeDaysAgo(int days) {
    return 'Il y a ${days}j';
  }

  @override
  String get notifVideoAssigned => 'Short assigné';

  @override
  String get notifDeadlineReminder => 'Rappel deadline';

  @override
  String get notifVideoCompleted => 'Short terminé';

  @override
  String get notifVideoValidated => 'Short validé';

  @override
  String get notifVideoRejected => 'Short rejeté';

  @override
  String get notifAccountBlocked => 'Compte bloqué';

  @override
  String get notifAccountUnblocked => 'Compte débloqué';

  @override
  String get profileAccountInfo => 'Informations du compte';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Telephone';

  @override
  String get profileStatus => 'Status';

  @override
  String get profileActive => 'Actif';

  @override
  String get profileBlocked => 'Bloque';

  @override
  String get profileLastLogin => 'Derniere connexion';

  @override
  String get profileMemberSince => 'Membre depuis';

  @override
  String get profileStats => 'Statistiques';

  @override
  String get profileStatsAssigned => 'Assignees';

  @override
  String get profileStatsCompleted => 'Terminees';

  @override
  String get profileStatsInProgress => 'En cours';

  @override
  String get profileStatsRate => 'Taux';

  @override
  String get profileStatsThisMonth => 'Ce mois';

  @override
  String get profileStatsLate => 'En retard';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileEmailNotifications => 'Notifications email';

  @override
  String get profileWhatsappNotifications => 'Notifications WhatsApp';

  @override
  String get profileWhatsappLinked => 'WhatsApp lie';

  @override
  String get profileChangePassword => 'Changer le mot de passe';

  @override
  String get commentAddPlaceholder => 'Ajouter un commentaire...';

  @override
  String get commentEmpty => 'Aucun commentaire';

  @override
  String get commentTimeNow => 'maintenant';

  @override
  String commentTimeMinutes(int minutes) {
    return '${minutes}min';
  }

  @override
  String commentTimeHours(int hours) {
    return '${hours}h';
  }

  @override
  String commentTimeDays(int days) {
    return '${days}j';
  }

  @override
  String commentTimeMonths(int months) {
    return '$months mois';
  }

  @override
  String get adminRecentActivity => 'Activité récente';

  @override
  String get adminTotalVideos => 'Total vidéos';

  @override
  String get adminRolled => 'Roulées';

  @override
  String get adminAssigned => 'Assignées';

  @override
  String get adminPublished => 'Publiées';

  @override
  String get adminNoRecentActivity => 'Aucune activité récente';

  @override
  String get analyticsTitle => 'Analytiques';

  @override
  String get analyticsStatusDistribution => 'Répartition par statut';

  @override
  String get analyticsWeeklyActivity => 'Activité hebdomadaire';

  @override
  String get analyticsCompletionTrend => 'Tendance de complétion (30j)';

  @override
  String get analyticsKeyMetrics => 'Métriques clés';

  @override
  String get analyticsCompletionRate => 'Taux de complétion';

  @override
  String get analyticsAvgPerWeek => 'Moyenne/semaine';

  @override
  String get analyticsLateRate => 'Taux de retard';

  @override
  String get analyticsNoData => 'Aucune donnée disponible';

  @override
  String get navAnalytics => 'Analytiques';

  @override
  String analyticsWeekLabel(int week) {
    return 'S$week';
  }

  @override
  String get contentTypeVaSansEdit => 'VA Sans Edit';

  @override
  String get contentTypeVaAvecEdit => 'VA Avec Edit';

  @override
  String get contentTypeVfSansEdit => 'VF Sans Edit';

  @override
  String get contentTypeVfAvecEdit => 'VF Avec Edit';

  @override
  String get contentTypeVoSansEdit => 'VO Sans Edit';

  @override
  String get contentTypeVoAvecEdit => 'VO Avec Edit';

  @override
  String get shareOverlayTitle => 'Ajouter une chaine source';

  @override
  String get shareOverlayContentType => 'Type de contenu';

  @override
  String get shareOverlayAddChannel => 'Ajouter la chaine';

  @override
  String get shareOverlayAdding => 'Ajout en cours...';

  @override
  String get shareOverlaySuccess => 'Chaine ajoutee avec succes !';

  @override
  String get shareOverlayAlreadyExists => 'Cette chaine existe deja';

  @override
  String get shareOverlayClose => 'Fermer';

  @override
  String get shareOverlayLoginRequired => 'Connexion requise';

  @override
  String get shareOverlayLoginHint =>
      'Connectez-vous a ShortHub pour ajouter des chaines sources';

  @override
  String get drawerSettings => 'Paramètres';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsAppearance => 'Apparence';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsLanguageLabel => 'Langue de l\'application';

  @override
  String get settingsLanguageFrench => 'Français';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsDarkMode => 'Mode sombre';

  @override
  String get settingsDarkModeDesc => 'Basculer entre le thème clair et sombre';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsVersion => 'Version';
}

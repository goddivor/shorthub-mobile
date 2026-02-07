// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ShortHub';

  @override
  String get appTagline => 'Collaborative YouTube Shorts Management';

  @override
  String get appTaglineSplash => 'Collaborative Shorts Management';

  @override
  String get loading => 'Loading...';

  @override
  String get loadingVideos => 'Loading videos...';

  @override
  String get loadingNotifications => 'Loading notifications...';

  @override
  String get loadingProfile => 'Loading profile...';

  @override
  String get loadingShort => 'Loading short...';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginUsernameHint => 'Enter your username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginPasswordHint => 'Enter your password';

  @override
  String get loginButton => 'Sign in';

  @override
  String get loginError => 'Login error. Check your credentials.';

  @override
  String get loginUsernameRequired => 'Username is required';

  @override
  String get loginUsernameMinLength => 'Username must be at least 3 characters';

  @override
  String get loginPasswordRequired => 'Password is required';

  @override
  String get loginPasswordMinLength => 'Password must be at least 6 characters';

  @override
  String get noUserConnected => 'No user connected';

  @override
  String get userNotConnected => 'User not connected';

  @override
  String get navNavigation => 'NAVIGATION';

  @override
  String get navSettings => 'SETTINGS';

  @override
  String get navTracking => 'Tracking';

  @override
  String get navRolling => 'Rolling';

  @override
  String get navChannels => 'Channels';

  @override
  String get navTeam => 'Team';

  @override
  String get navAssigned => 'Assigned';

  @override
  String get navInProgress => 'In Progress';

  @override
  String get navCompleted => 'Completed';

  @override
  String get navToValidate => 'To validate';

  @override
  String get navValidated => 'Validated';

  @override
  String get navRejected => 'Rejected';

  @override
  String get drawerProfile => 'My profile';

  @override
  String get drawerDarkMode => 'Dark mode';

  @override
  String get drawerLanguage => 'Language';

  @override
  String get drawerLogout => 'Logout';

  @override
  String get drawerLogoutConfirm => 'Are you sure you want to log out?';

  @override
  String get drawerNoEmail => 'No email';

  @override
  String get roleAdmin => 'Administrator';

  @override
  String get roleVideaste => 'Videographer';

  @override
  String get roleAssistant => 'Assistant';

  @override
  String get statusRolled => 'Rolled';

  @override
  String get statusRetained => 'Retained';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get statusAssigned => 'Assigned';

  @override
  String get statusInProgress => 'In Progress';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusValidated => 'Validated';

  @override
  String get statusPublished => 'Published';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Confirm';

  @override
  String get commonView => 'View';

  @override
  String get commonViewDetails => 'View details';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonOops => 'Oops!';

  @override
  String get commonYes => 'Yes';

  @override
  String get commonNo => 'No';

  @override
  String get commonSearch => 'Search a short...';

  @override
  String get commonError => 'Error';

  @override
  String commonErrorPrefix(String error) {
    return 'Error: $error';
  }

  @override
  String get actionValidate => 'Validate';

  @override
  String get actionReject => 'Reject';

  @override
  String get actionPublish => 'Publish';

  @override
  String get actionWork => 'Work';

  @override
  String get actionComplete => 'Complete';

  @override
  String get actionStart => 'Start';

  @override
  String get shortLate => 'Late';

  @override
  String get shortChannels => 'Channels';

  @override
  String get shortSource => 'Source';

  @override
  String get shortPublication => 'Publication';

  @override
  String get shortAssignment => 'Assignment';

  @override
  String get shortVideaste => 'Videographer';

  @override
  String get shortAssignedBy => 'Assigned by';

  @override
  String get shortDate => 'Date';

  @override
  String get shortDeadline => 'Deadline';

  @override
  String get shortDaysRemaining => 'Days remaining';

  @override
  String get shortTimeline => 'Timeline';

  @override
  String get shortTimelineRolled => 'Rolled';

  @override
  String get shortTimelineRetained => 'Retained';

  @override
  String get shortTimelineAssigned => 'Assigned';

  @override
  String get shortTimelineCompleted => 'Completed';

  @override
  String get shortTimelineValidated => 'Validated';

  @override
  String get shortTimelinePublished => 'Published';

  @override
  String get shortTimelineRejected => 'Rejected';

  @override
  String get shortCompletionTime => 'Completion time';

  @override
  String shortCompletionTimeValue(String hours) {
    return '$hours hours';
  }

  @override
  String get shortNotes => 'Notes';

  @override
  String get shortAdminFeedback => 'Admin feedback';

  @override
  String get shortVideoFile => 'Video file';

  @override
  String get shortFileName => 'Name';

  @override
  String get shortFileSize => 'Size';

  @override
  String get shortFileType => 'Type';

  @override
  String get shortFileUpload => 'Upload';

  @override
  String get shortTags => 'Tags';

  @override
  String shortComments(int count) {
    return 'Comments ($count)';
  }

  @override
  String get shortErrorLoading => 'Error loading short';

  @override
  String get dialogPublishTitle => 'Publish short';

  @override
  String dialogPublishContent(String title) {
    return 'Confirm publishing \"$title\"?';
  }

  @override
  String get dialogStartWorkTitle => 'Start work';

  @override
  String get dialogStartWorkContent => 'Confirm starting work on this short?';

  @override
  String dialogStartWorkContentNamed(String title) {
    return 'Start working on \"$title\"?';
  }

  @override
  String get dialogCompleteTitle => 'Complete work';

  @override
  String get dialogCompleteContent => 'Confirm the work is complete?';

  @override
  String dialogCompleteContentNamed(String title) {
    return 'Mark \"$title\" as completed?';
  }

  @override
  String get dialogValidateTitle => 'Validate video';

  @override
  String dialogValidateContent(String title) {
    return 'Validate \"$title\"?';
  }

  @override
  String get dialogRejectTitle => 'Reject video';

  @override
  String get dialogRejectReasonLabel => 'Rejection reason:';

  @override
  String get dialogRejectHint => 'Explain why you are rejecting this video...';

  @override
  String get dialogRejectReasonRequired => 'Reason is required';

  @override
  String get dialogFeedbackHint => 'Optional feedback...';

  @override
  String get snackWorkStarted => 'Work started!';

  @override
  String get snackVideoCompleted => 'Video marked as completed!';

  @override
  String get snackVideoValidated => 'Video validated successfully';

  @override
  String get snackVideoRejected => 'Video rejected';

  @override
  String get emptyNoVideosToValidate => 'No videos to validate';

  @override
  String get emptyNoValidatedVideos => 'No validated videos';

  @override
  String get emptyNoRejectedVideos => 'No rejected videos';

  @override
  String get emptyNoAssignedVideos => 'No assigned videos';

  @override
  String get emptyNoInProgressVideos => 'No videos in progress';

  @override
  String get emptyNoCompletedVideos => 'No completed videos';

  @override
  String get errorLoadingVideos => 'Error loading videos';

  @override
  String get errorLoadingStats => 'Error loading statistics';

  @override
  String get errorLoadingShort => 'Error loading short';

  @override
  String get errorLoadingProfile => 'Error loading profile';

  @override
  String get errorLoadingNotifications => 'Error loading notifications';

  @override
  String get errorLoading => 'Error loading';

  @override
  String get statsAssigned => 'Assigned';

  @override
  String get statsCompleted => 'Completed';

  @override
  String get statsRate => 'Rate';

  @override
  String get statsToValidate => 'To validate';

  @override
  String get statsValidated => 'Validated';

  @override
  String get statsRejected => 'Rejected';

  @override
  String get notificationsTitle => 'Notifications';

  @override
  String get notificationsMarkAllRead => 'Mark all read';

  @override
  String get notificationsEmpty => 'No notifications';

  @override
  String get timeJustNow => 'Just now';

  @override
  String timeMinutesAgo(int minutes) {
    return '${minutes}min ago';
  }

  @override
  String timeHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String timeDaysAgo(int days) {
    return '${days}d ago';
  }

  @override
  String get notifVideoAssigned => 'Short assigned';

  @override
  String get notifDeadlineReminder => 'Deadline reminder';

  @override
  String get notifVideoCompleted => 'Short completed';

  @override
  String get notifVideoValidated => 'Short validated';

  @override
  String get notifVideoRejected => 'Short rejected';

  @override
  String get notifAccountBlocked => 'Account blocked';

  @override
  String get notifAccountUnblocked => 'Account unblocked';

  @override
  String get profileAccountInfo => 'Account information';

  @override
  String get profileEmail => 'Email';

  @override
  String get profilePhone => 'Phone';

  @override
  String get profileStatus => 'Status';

  @override
  String get profileActive => 'Active';

  @override
  String get profileBlocked => 'Blocked';

  @override
  String get profileLastLogin => 'Last login';

  @override
  String get profileMemberSince => 'Member since';

  @override
  String get profileStats => 'Statistics';

  @override
  String get profileStatsAssigned => 'Assigned';

  @override
  String get profileStatsCompleted => 'Completed';

  @override
  String get profileStatsInProgress => 'In progress';

  @override
  String get profileStatsRate => 'Rate';

  @override
  String get profileStatsThisMonth => 'This month';

  @override
  String get profileStatsLate => 'Late';

  @override
  String get profileNotifications => 'Notifications';

  @override
  String get profileEmailNotifications => 'Email notifications';

  @override
  String get profileWhatsappNotifications => 'WhatsApp notifications';

  @override
  String get profileWhatsappLinked => 'WhatsApp linked';

  @override
  String get profileChangePassword => 'Change password';

  @override
  String get commentAddPlaceholder => 'Add a comment...';

  @override
  String get commentEmpty => 'No comments';

  @override
  String get commentTimeNow => 'now';

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
    return '${days}d';
  }

  @override
  String commentTimeMonths(int months) {
    return '$months months';
  }

  @override
  String get adminRecentActivity => 'Recent activity';

  @override
  String get adminTotalVideos => 'Total videos';

  @override
  String get adminRolled => 'Rolled';

  @override
  String get adminAssigned => 'Assigned';

  @override
  String get adminPublished => 'Published';

  @override
  String get adminNoRecentActivity => 'No recent activity';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get analyticsStatusDistribution => 'Status distribution';

  @override
  String get analyticsWeeklyActivity => 'Weekly activity';

  @override
  String get analyticsCompletionTrend => 'Completion trend (30d)';

  @override
  String get analyticsKeyMetrics => 'Key metrics';

  @override
  String get analyticsCompletionRate => 'Completion rate';

  @override
  String get analyticsAvgPerWeek => 'Avg/week';

  @override
  String get analyticsLateRate => 'Late rate';

  @override
  String get analyticsNoData => 'No data available';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String analyticsWeekLabel(int week) {
    return 'W$week';
  }

  @override
  String get contentTypeVaSansEdit => 'VA No Edit';

  @override
  String get contentTypeVaAvecEdit => 'VA With Edit';

  @override
  String get contentTypeVfSansEdit => 'VF No Edit';

  @override
  String get contentTypeVfAvecEdit => 'VF With Edit';

  @override
  String get contentTypeVoSansEdit => 'VO No Edit';

  @override
  String get contentTypeVoAvecEdit => 'VO With Edit';
}

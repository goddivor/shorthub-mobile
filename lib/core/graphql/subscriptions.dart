// lib/core/graphql/subscriptions.dart
// GraphQL Subscriptions

// ==================== Notifications ====================

const String notificationReceivedSubscription = r'''
  subscription NotificationReceived($userId: ID!) {
    notificationReceived(userId: $userId) {
      id
      type
      message
      sentViaEmail
      sentViaWhatsApp
      sentViaPlatform
      read
      createdAt
    }
  }
''';

// ==================== Videos/Shorts ====================

const String videoStatusChangedSubscription = r'''
  subscription VideoStatusChanged($videoId: ID) {
    videoStatusChanged(videoId: $videoId) {
      id
      videoId
      title
      status
      updatedAt
    }
  }
''';

const String videoAssignedSubscription = r'''
  subscription VideoAssigned($userId: ID!) {
    videoAssigned(userId: $userId) {
      id
      videoId
      title
      status
      assignedTo {
        id
        username
      }
      sourceChannel {
        channelName
      }
      deadline
    }
  }
''';

const String videoCompletedSubscription = r'''
  subscription VideoCompleted {
    videoCompleted {
      id
      videoId
      title
      status
      assignedTo {
        id
        username
      }
    }
  }
''';

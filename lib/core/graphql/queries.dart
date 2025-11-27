// lib/core/graphql/queries.dart

/// GraphQL Queries
library;


// ==================== Auth ====================

const String meQuery = r'''
  query Me {
    me {
      id
      username
      email
      role
      status
      phone
      whatsappLinked
      emailNotifications
      whatsappNotifications
      profileImage
      lastLogin
      stats {
        totalVideosAssigned
        totalVideosCompleted
        totalVideosInProgress
        completionRate
        averageCompletionTime
        videosCompletedThisMonth
        videosLate
        videosOnTime
      }
      createdAt
      updatedAt
    }
  }
''';

// ==================== Shorts ====================

const String shortsQuery = r'''
  query Shorts($filter: ShortFilterInput) {
    shorts(filter: $filter) {
      id
      videoId
      videoUrl
      sourceChannel {
        id
        channelId
        channelName
        profileImageUrl
        contentType
      }
      status
      rolledAt
      retainedAt
      rejectedAt
      assignedTo {
        id
        username
      }
      assignedBy {
        id
        username
      }
      assignedAt
      deadline
      targetChannel {
        id
        channelId
        channelName
        profileImageUrl
        contentType
      }
      completedAt
      validatedAt
      publishedAt
      title
      description
      tags
      notes
      adminFeedback
      isLate
      daysUntilDeadline
      timeToComplete
      driveFileId
      driveFileUrl
      driveFolderId
      uploadedAt
      fileName
      fileSize
      mimeType
      createdAt
      updatedAt
    }
  }
''';

const String shortQuery = r'''
  query Short($id: ID!) {
    short(id: $id) {
      id
      videoId
      videoUrl
      sourceChannel {
        id
        channelId
        channelName
        profileImageUrl
        contentType
      }
      status
      rolledAt
      retainedAt
      rejectedAt
      assignedTo {
        id
        username
        email
        profileImage
      }
      assignedBy {
        id
        username
      }
      assignedAt
      deadline
      targetChannel {
        id
        channelId
        channelName
        profileImageUrl
        contentType
      }
      completedAt
      validatedAt
      publishedAt
      title
      description
      tags
      notes
      adminFeedback
      isLate
      daysUntilDeadline
      timeToComplete
      driveFileId
      driveFileUrl
      driveFolderId
      uploadedAt
      fileName
      fileSize
      mimeType
      createdAt
      updatedAt
    }
  }
''';

const String shortsStatsQuery = r'''
  query ShortsStats {
    shortsStats {
      totalRolled
      totalRetained
      totalRejected
      totalAssigned
      totalInProgress
      totalCompleted
      totalValidated
      totalPublished
    }
  }
''';

// ==================== Channels ====================

const String sourceChannelsQuery = r'''
  query SourceChannels($contentType: ContentType) {
    sourceChannels(contentType: $contentType) {
      id
      channelId
      channelName
      profileImageUrl
      contentType
      totalVideos
      createdAt
      updatedAt
    }
  }
''';

const String adminChannelsQuery = r'''
  query AdminChannels {
    adminChannels {
      id
      channelId
      channelName
      profileImageUrl
      contentType
      totalVideos
      subscriberCount
      createdAt
      updatedAt
    }
  }
''';

// ==================== Users ====================

const String usersQuery = r'''
  query Users($first: Int, $role: UserRole, $status: UserStatus) {
    users(first: $first, role: $role, status: $status) {
      edges {
        node {
          id
          username
          email
          role
          status
          phone
          whatsappLinked
          emailNotifications
          whatsappNotifications
          profileImage
          lastLogin
          createdAt
          updatedAt
        }
      }
      totalCount
    }
  }
''';

// ==================== Notifications ====================

const String notificationsQuery = r'''
  query Notifications($first: Int, $unreadOnly: Boolean) {
    notifications(first: $first, unreadOnly: $unreadOnly) {
      edges {
        node {
          id
          type
          message
          sentViaEmail
          sentViaWhatsApp
          sentViaPlatform
          emailSentAt
          whatsappSentAt
          platformSentAt
          read
          readAt
          createdAt
        }
      }
      totalCount
    }
  }
''';

const String unreadNotificationsCountQuery = r'''
  query UnreadNotificationsCount {
    unreadNotificationsCount
  }
''';

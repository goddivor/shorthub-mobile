// lib/core/graphql/mutations.dart

/// GraphQL Mutations
library;


// ==================== Auth ====================

const String loginMutation = r'''
  mutation Login($username: String!, $password: String!) {
    login(username: $username, password: $password) {
      token
      refreshToken
      user {
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
  }
''';

const String logoutMutation = r'''
  mutation Logout {
    logout
  }
''';

const String refreshTokenMutation = r'''
  mutation RefreshToken($token: String!) {
    refreshToken(token: $token) {
      token
      refreshToken
      user {
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
  }
''';

const String changePasswordMutation = r'''
  mutation ChangePassword($oldPassword: String!, $newPassword: String!) {
    changePassword(oldPassword: $oldPassword, newPassword: $newPassword)
  }
''';

// ==================== Shorts ====================

const String rollShortMutation = r'''
  mutation RollShort($input: RollShortInput!) {
    rollShort(input: $input) {
      id
      videoId
      videoUrl
      sourceChannel {
        id
        channelName
        profileImageUrl
      }
      status
      rolledAt
      createdAt
    }
  }
''';

const String retainShortMutation = r'''
  mutation RetainShort($shortId: ID!) {
    retainShort(shortId: $shortId) {
      id
      status
      retainedAt
    }
  }
''';

const String rejectShortMutation = r'''
  mutation RejectShort($shortId: ID!) {
    rejectShort(shortId: $shortId) {
      id
      status
      rejectedAt
    }
  }
''';

const String assignShortMutation = r'''
  mutation AssignShort($input: AssignShortInput!) {
    assignShort(input: $input) {
      id
      status
      assignedTo {
        id
        username
      }
      assignedAt
      deadline
      targetChannel {
        id
        channelName
      }
      notes
    }
  }
''';

const String updateShortStatusMutation = r'''
  mutation UpdateShortStatus($input: UpdateShortStatusInput!) {
    updateShortStatus(input: $input) {
      id
      status
      completedAt
      validatedAt
      publishedAt
      adminFeedback
    }
  }
''';

const String deleteShortMutation = r'''
  mutation DeleteShort($id: ID!) {
    deleteShort(id: $id)
  }
''';

// ==================== Short Comments ====================

const String createShortCommentMutation = r'''
  mutation CreateShortComment($input: CreateShortCommentInput!) {
    createShortComment(input: $input) {
      id
      comment
      author {
        id
        username
        profileImage
      }
      createdAt
    }
  }
''';

// ==================== Channels ====================

const String createSourceChannelMutation = r'''
  mutation CreateSourceChannel($input: CreateSourceChannelInput!) {
    createSourceChannel(input: $input) {
      id
      channelId
      channelName
      profileImageUrl
      contentType
      totalVideos
      createdAt
    }
  }
''';

const String updateSourceChannelMutation = r'''
  mutation UpdateSourceChannel($id: ID!, $input: UpdateSourceChannelInput!) {
    updateSourceChannel(id: $id, input: $input) {
      id
      contentType
      profileImageUrl
      updatedAt
    }
  }
''';

const String deleteSourceChannelMutation = r'''
  mutation DeleteSourceChannel($id: ID!) {
    deleteSourceChannel(id: $id)
  }
''';

const String createAdminChannelMutation = r'''
  mutation CreateAdminChannel($input: CreateAdminChannelInput!) {
    createAdminChannel(input: $input) {
      id
      channelId
      channelName
      profileImageUrl
      contentType
      totalVideos
      subscriberCount
      createdAt
    }
  }
''';

const String deleteAdminChannelMutation = r'''
  mutation DeleteAdminChannel($id: ID!) {
    deleteAdminChannel(id: $id)
  }
''';

// ==================== Users (Admin only) ====================

const String createUserMutation = r'''
  mutation CreateUser($input: CreateUserInput!) {
    createUser(input: $input) {
      id
      username
      role
      status
      createdAt
    }
  }
''';

const String updateUserStatusMutation = r'''
  mutation UpdateUserStatus($id: ID!, $status: UserStatus!) {
    updateUserStatus(id: $id, status: $status) {
      id
      status
      updatedAt
    }
  }
''';

const String deleteUserMutation = r'''
  mutation DeleteUser($id: ID!) {
    deleteUser(id: $id)
  }
''';

// ==================== Notifications ====================

const String markNotificationAsReadMutation = r'''
  mutation MarkNotificationAsRead($id: ID!) {
    markNotificationAsRead(id: $id) {
      id
      read
      readAt
    }
  }
''';

const String markAllNotificationsAsReadMutation = r'''
  mutation MarkAllNotificationsAsRead {
    markAllNotificationsAsRead
  }
''';

//
//  TCHConstants.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <TwilioConversationsClient/TCHResult.h>

@class TwilioConversationsClient;
@class TCHConversation;
@class TCHMessage;
@class TCHUser;
@class TCHDetailedDeliveryReceipt;
@class TCHContentTemplate;
@protocol TCHContentDataRaw;

/** Client connection state. */
typedef NS_ENUM(NSInteger, TCHClientConnectionState) {
    TCHClientConnectionStateUnknown,        ///< Client connection state is not yet known.
    TCHClientConnectionStateDisconnected,   ///< Client is offline and no connection attempt in process.
    TCHClientConnectionStateConnected,      ///< Client is online and ready.
    TCHClientConnectionStateConnecting,     ///< Client is offline and connection attempt is in process.
    TCHClientConnectionStateDenied,         ///< Client connection is denied because of invalid token.
    TCHClientConnectionStateError,          ///< Client connection is in the erroneous state. Probably offline.
    TCHClientConnectionStateFatalError      ///< Client connection is rejected and customer action is required.
};

/** The synchronization status of the client. */
typedef NS_ENUM(NSInteger, TCHClientSynchronizationStatus) {
    TCHClientSynchronizationStatusStarted = 0,               ///< Client synchronization has started.
    TCHClientSynchronizationStatusConversationsListCompleted,     ///< Conversations list is available.
    TCHClientSynchronizationStatusCompleted,                 ///< All joined conversations, their participants and the requested number of messages are synchronized.
    TCHClientSynchronizationStatusFailed                     ///< Synchronization failed.
};

/** Enumeration indicating the client's logging level. */
typedef NS_ENUM(NSInteger, TCHLogLevel) {
    TCHLogLevelSilent = 0,       ///< Show no errors.
    TCHLogLevelFatal,            ///< Show fatal errors only.
    TCHLogLevelCritical,         ///< Show critical log messages as well as all Fatal log messages.
    TCHLogLevelWarning,          ///< Show warnings as well as all Critical log messages.
    TCHLogLevelInfo,             ///< Show informational messages as well as all Warning log messages.
    TCHLogLevelDebug,            ///< Show low-level debugging messages as well as all Info log messages.
    TCHLogLevelTrace             ///< Show low-level tracing messages as well as all Debug log messages.
};

/** Enumeration indicating the updates made to the TCHConversation object. */
typedef NS_ENUM(NSInteger, TCHConversationUpdate) {
    TCHConversationUpdateStatus = 1,                     ///< The user's status on this conversation changed.
    TCHConversationUpdateLastReadMessageIndex,           ///< The user's last read message index on this conversation changed.
    TCHConversationUpdateUniqueName,                     ///< The conversation's unique name changed.
    TCHConversationUpdateFriendlyName,                   ///< The conversation's friendly name changed.
    TCHConversationUpdateAttributes,                     ///< The conversation's attributes changed.
    TCHConversationUpdateLastMessage,                    ///< The conversation's last message changed.
    TCHConversationUpdateUserNotificationLevel,          ///< The conversation's user notification level changed.
    TCHConversationUpdateState,                          ///< The conversation's state changed.
};

/** Enumeration indicating the conversation's current synchronization status with the server. */
typedef NS_ENUM(NSInteger, TCHConversationSynchronizationStatus) {
    TCHConversationSynchronizationStatusNone = 0,        ///< Conversation not ready yet, local object only.
    TCHConversationSynchronizationStatusIdentifier,      ///< Conversation SID is available.
    TCHConversationSynchronizationStatusMetadata,        ///< Conversation SID, Friendly Name, Attributes and Unique Name are available.
    TCHConversationSynchronizationStatusAll,             ///< Conversation collections: participants and messages are ready to use.
    TCHConversationSynchronizationStatusFailed           ///< Conversation synchronization failed.
};

/** Enumeration indicating the user's current status on a given conversation. */
typedef NS_ENUM(NSInteger, TCHConversationStatus) {
    TCHConversationStatusJoined = 1,         ///< User is joined to the conversation.
    TCHConversationStatusNotParticipating,   ///< User is not participating on this conversation.
};

/**
 * Enumeration representing the various states of the conversation.
 *
 * States of the conversation could change in the following sequence: ACTIVE <-> INACTIVE -> CLOSED
 * with timers (automatically flip to "inactive" after some period of inactivity), triggers (new message,
 * new participant -- flip to "active" back on activity), or API call.
 */
typedef NS_ENUM(NSInteger, TCHConversationState) {
    TCHConversationStateUndefined = 0,      ///< Conversation state is unknown.
    TCHConversationStateActive,             ///< Conversation state is active, i.e. some events have happened in the conversation recently (new message received, new participant added etc).
    TCHConversationStateInactive,           ///< Conversation state is inactive, i.e. no new events have happened in the conversation recently (new message received, new participant added etc). So the conversation has been moved to inactive state by timeout.
    TCHConversationStateClosed,             ///< Conversations state is closed. When conversation moves to closed state SDK receives update that the user left given conversation. So SDKs will not receive any updates on it in the future. Any operations with closed conversation are not permitted.
};

/** Enumeration indicating the user's notification level on a conversation. */
typedef NS_ENUM(NSInteger, TCHConversationNotificationLevel) {
    TCHConversationNotificationLevelDefault = 0,       ///< User will receive notifications for the conversation if joined, nothing if unjoined.
    TCHConversationNotificationLevelMuted,             ///< User will not receive notifications for the conversation.
};

/** Enumeration indicating the updates made to the TCHUser object. */
typedef NS_ENUM(NSInteger, TCHUserUpdate) {
    TCHUserUpdateFriendlyName = 0,        ///< The friendly name changed.
    TCHUserUpdateAttributes,              ///< The attributes changed.
    TCHUserUpdateReachabilityOnline,      ///< The user's online status changed.
    TCHUserUpdateReachabilityNotifiable   ///< The user's notifiability status changed.
};

/** Enumeration indicating the updates made to the TCHParticipant object. */
typedef NS_ENUM(NSInteger, TCHParticipantUpdate) {
    TCHParticipantUpdateLastReadMessageIndex = 0,            ///< The participant's last read message index changed.
    TCHParticipantUpdateLastReadTimestamp,                   ///< The participant's last read message timestamp changed.
    TCHParticipantUpdateAttributes                           ///< The participant's attributes changed.
};

/** Enumerations indicating the type of the TCHParticipant object. */
typedef NS_ENUM(NSInteger, TCHParticipantType) {
    TCHParticipantTypeUnset = 0, ///< The participant's type is not initialized yet.
    TCHParticipantTypeOther,     ///< The participant's type is unknown for current SDK.
    TCHParticipantTypeChat,      ///< The participant's type is Chat.
    TCHParticipantTypeSms,       ///< The participant's type is SMS.
    TCHParticipantTypeWhatsapp   ///< The participant's type is WhatsApp.
};

/** Enumeration indicating the updates made to the TCHMessage object. */
typedef NS_ENUM(NSInteger, TCHMessageUpdate) {
    TCHMessageUpdateBody = 0,               ///< The message's body changed.
    TCHMessageUpdateAttributes,             ///< The message's attributes changed.
    TCHMessageUpdateDeliveryReceipt,        ///< The message's aggregated delivery receipt changed.
    TCHMessageUpdateSubject,                ///< The message's subject changed.
};

/** Enumeration indicating the type of media in a message. */
typedef NS_ENUM(NSUInteger, TCHMediaCategory) {
    TCHMediaCategoryMedia,              ///< This type means that a message contain attached media.
    TCHMediaCategoryBody,          ///< This type means that media with this category replaces a body from a message.
    TCHMediaCategoryHistory,       ///< The type is email history.
} NS_SWIFT_NAME(MediaCategory);

/** Completion block which will indicate the TCHResult of the operation.

 @param result The result of the operation.
 */
typedef void (^TCHCompletion)(TCHResult * _Nonnull result);

/** Completion block which will indicate the TCHResult of the operation and your handle to the TwilioConversationsClient instance.

 @param result The result of the operation.
 @param conversationsClient The newly created conversations client which you should create a strong reference to.
 */
typedef void (^TCHTwilioClientCompletion)(TCHResult * _Nonnull result, TwilioConversationsClient * _Nullable conversationsClient);

/** Completion block which will indicate the TCHResult of the operation and a conversation.

 @param result The result of the operation.
 @param conversation The conversation returned by the operation.
 */
typedef void (^TCHConversationCompletion)(TCHResult * _Nonnull result, TCHConversation * _Nullable conversation);

/** Completion block which will indicate the TCHResult of the operation and a message.

 @param result The result of the operation.
 @param message The message returned by the operation.
 */
typedef void (^TCHMessageCompletion)(TCHResult * _Nonnull result, TCHMessage * _Nullable message);

/** Completion block which will indicate the TCHResult of the operation and a list of messages.

 @param result The result of the operation.
 @param messages An array of messages returned by the operation.
 */
typedef void (^TCHMessagesCompletion)(TCHResult * _Nonnull result, NSArray<TCHMessage *> * _Nullable messages);

/** Completion block which will indicate the TCHResult of the operation and a user.

 @param result The result of the operation.
 @param user The user returned by the operation.
 */
typedef void (^TCHUserCompletion)(TCHResult * _Nonnull result, TCHUser * _Nullable user);

/** Completion block which will provide the requested count.

 @param result The result of the operation.
 @param count The requested count, provided the operation completed successfully.
 */
typedef void (^TCHCountCompletion)(TCHResult * _Nonnull result, NSUInteger count);

/** Completion block which will provide the requested nullable count.

 @param result The result of the operation.
 @param count The requested count, provided the operation completed successfully, or nil.
 */
typedef void (^TCHNullableCountCompletion)(TCHResult * _Nonnull result, NSNumber * _Nullable count);

/** Completion block which will provide the requested string value.

 @param result The result of the operation.
 @param value The requested string value, provided the operation completed successfully.
 */
typedef void (^TCHStringCompletion)(TCHResult * _Nonnull result, NSString * _Nullable value);

/** Completion block which will provide the requested URL value.

 @param result The result of the operation.
 @param value The requested URL value, provided the operation completed successfully.
 */
typedef void (^TCHURLCompletion)(TCHResult * _Nonnull result, NSURL * _Nullable value);

/** Completion block which will provide the requested dictionary value, where a media message sid is the key and a value is the temporary url.

 @param result The result of the operation.
 @param value The requested dictionary value, provided the operation completed successfully.
 */
typedef void (^TCHMediaSidsCompletion)(TCHResult * _Nonnull result, NSDictionary<NSString *, NSURL *> * _Nullable value);

/** Completion block which will provide content templates available for the account.

 @param result The result of the operation.
 @param templates The requested content templates, provided the operation completed successfully.
 */
typedef void (^TCHContentTemplatesCompletion)(TCHResult * _Nonnull result, NSArray<TCHContentTemplate *> * _Nullable templates);

/** Completion block which will provide the content data for a message.

 @param result The result of the operation.
 @param contentData The requested content templates, provided the operation completed successfully.
 */
typedef void (^TCHContentDataCompletion)(TCHResult * _Nonnull result, NSObject<TCHContentDataRaw> * _Nullable contentData);

/** Completion block which will provide the requested array of TCHDetailedDeliveryReceipt's value.

 @param result The result of the operation.
 @param receipts The requested array of receipts, provided the operation completed successfully.
 */
typedef void (^TCHDetailedDeliveryReceiptsCompletion)(TCHResult * _Nonnull result, NSArray<TCHDetailedDeliveryReceipt *> * _Nullable receipts);

/** Block called upon start of the media operation. */
typedef void (^TCHMediaOnStarted)(void);

/** Block called with progress on the media operation.

 @param bytes The total number of bytes written so far by the operation.
 */
typedef void (^TCHMediaOnProgress)(NSUInteger bytes);

/** Block called upon successful completion of the operation with the media's sid.

 @param mediaSid The media's sid.
 */
typedef void (^TCHMediaOnCompleted)(NSString * _Nonnull mediaSid);

/** Block called upon erronous completion of the operation.

 @param error The error which indicates the problem.
 */
typedef void (^TCHMediaOnFailed)(TCHError * _Nonnull error);

/** Conversation creation options key for setting friendly name. */
FOUNDATION_EXPORT NSString *const _Nonnull TCHConversationOptionFriendlyName;

/** Conversation creation options key for setting unqiue name. */
FOUNDATION_EXPORT NSString *const _Nonnull TCHConversationOptionUniqueName;

/** Conversation creation options key for setting attributes.  Expected value is an NSDictionary* */
FOUNDATION_EXPORT NSString *const _Nonnull TCHConversationOptionAttributes;

/** The Twilio Conversations error domain used as NSError's `domain`. */
FOUNDATION_EXPORT NSString *const _Nonnull TCHErrorDomain;

/** The errorCode specified when an error client side occurs without another specific error code. */
FOUNDATION_EXPORT NSInteger const TCHErrorGeneric;

/** The userInfo key for the error message, if any. */
FOUNDATION_EXPORT NSString *const _Nonnull TCHErrorMsgKey;

typedef NS_ENUM(NSInteger, TCHCommandTimeout) {
    /** Minimum valid command timeout value in milliseconds that could be used in TwilioConversationsClientProperties. */
    TCHCommandTimeoutMin = 10000,

    /** Maximum valid command timeout value in milliseconds that could be used in TwilioConversationsClientProperties. */
    TCHCommandTimeoutMax = 0x7fffffff,

    /** Default command timeout value in milliseconds that could be used in TwilioConversationsClientProperties. */
    TCHCommandTimeoutDefault = 90000
};

//
//  TwilioConversationsClient.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TwilioConversationsClient/TCHConstants.h>
#import <TwilioConversationsClient/TCHError.h>
#import <TwilioConversationsClient/TCHConversation.h>
#import <TwilioConversationsClient/TCHMessage.h>
#import <TwilioConversationsClient/TCHParticipant.h>
#import <TwilioConversationsClient/TCHUser.h>
#import <TwilioConversationsClient/TCHContentTemplate.h>

@class TwilioConversationsClientProperties;
@protocol TwilioConversationsClientDelegate;

/** Represents a conversations client connection to Twilio. */
__attribute__((visibility("default")))
@interface TwilioConversationsClient : NSObject

/** Messaging client delegate */
@property (nonatomic, weak, nullable) id<TwilioConversationsClientDelegate> delegate;

/** The logged in user in the conversation system. */
@property (nonatomic, strong, readonly, nullable) TCHUser *user;

/** The client's current connection state. */
@property (nonatomic, assign, readonly) TCHClientConnectionState connectionState;

/** The current client synchronization state. */
@property (nonatomic, assign, readonly) TCHClientSynchronizationStatus synchronizationStatus;

/**
 Queue all completions and events would fire from.
 If not set here or in properties on a client creation, main queue would be used.
 */
@property (nonatomic, readwrite, nonnull) dispatch_queue_t dispatchQueue;

/** Sets the logging level for the client. 
 
 @param logLevel The new log level.
 */
+ (void)setLogLevel:(TCHLogLevel)logLevel;

/** The logging level for the client. 
 
 @return The log level.
 */
+ (TCHLogLevel)logLevel;

/** Initialize a new conversations client instance.
 
 @param token The client access token to use when communicating with Twilio.
 @param properties The properties to initialize the client with, if this is nil defaults will be used.
 @param delegate Delegate conforming to TwilioConversationsClientDelegate for conversations client lifecycle notifications.
 @param completion Completion block that will specify the result of the operation and a reference to the new TwilioConversationsClient.
 */
+ (void)conversationsClientWithToken:(nonnull NSString *)token
                          properties:(nullable TwilioConversationsClientProperties *)properties
                            delegate:(nullable id<TwilioConversationsClientDelegate>)delegate
                          completion:(nonnull TCHTwilioClientCompletion)completion;

/** Returns the name of the SDK for diagnostic purposes.
 
 @return An identifier for the Conversations SDK.
 */
+ (nonnull NSString *)sdkName;

/** Returns the version of the SDK
 
 @return The conversations client version.
 */
+ (nonnull NSString *)sdkVersion;

/** Updates the access token currently being used by the client.
 
 @param token The updated client access token to use when communicating with Twilio.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)updateToken:(nonnull NSString *)token
         completion:(nullable TCHCompletion)completion;

/** Retrieve a list of conversations currently subscribed to on the client.
 
 This will be nil until the client is fully initialized, see the client delegate callback `conversationsClient:synchronizationStatusUpdated:`
 
 @return An array of all of the client's currently subscribed conversations.
 */
- (nullable NSArray<TCHConversation *> *)myConversations;

/** Create a new conversation with the specified options.

 @param options Conversation options for new conversation whose keys are TCHConversationOption* constants. (optional - may be empty or nil)
 @param completion Completion block that will specify the result of the operation and a reference to the new conversation.
 @discussion TCHConversationOptionFriendlyName - String friendly name (optional)
 @discussion TCHConversationOptionUniqueName - String unique name (optional)
 @discussion TCHConversationOptionAttributes - Expected value is an valid json object, see also TCHConversation setAttributes:completion: (optional)
 */
- (void)createConversationWithOptions:(nullable NSDictionary<NSString *, id> *)options
                           completion:(nullable TCHConversationCompletion)completion;

/** Obtains a conversation with the specified id or unique name.

 @param sidOrUniqueName Identifier or unique name for the conversation.
 @param completion Completion block that will specify the result of the operation and a reference to the requested conversation if it exists.
 */
- (void)conversationWithSidOrUniqueName:(nonnull NSString *)sidOrUniqueName
                             completion:(nonnull TCHConversationCompletion)completion;

/** Obtain all participants across available conversations with the given identity.

 @param identity The identity of the user to to search in multiple conversations.
 @return The array of participants for this user.
 */
- (nonnull NSArray<TCHParticipant *> *)participantsWithIdentity:(nonnull NSString *)identity;

/** Provides all subscribed-to users.
 
 @return The array of subscribed users.
 */
- (nullable NSArray<TCHUser *> *)users;

/** Obtain a subscribed user object for the given identity.  If no current subscription exists for this user, this will
 fetch the user and subscribe them.  The least recently subscribed user object will be unsubscribed if you reach your instance's
 user subscription limit.

 @param identity The identity of the user to obtain.
 @param completion Completion block that will specify the result of the operation and the newly subscribed user.
 */
- (void)subscribedUserWithIdentity:(nonnull NSString *)identity
                        completion:(nonnull TCHUserCompletion)completion;

/** Register APNS token for push notification updates.
 
 @param token The APNS token which usually comes from `didRegisterForRemoteNotificationsWithDeviceToken`.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)registerWithNotificationToken:(nonnull NSData *)token
                           completion:(nullable TCHCompletion)completion;

/** De-register from push notification updates.
 
 @param token The APNS token which usually comes from `didRegisterForRemoteNotificationsWithDeviceToken`.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)deregisterWithNotificationToken:(nonnull NSData *)token
                             completion:(nullable TCHCompletion)completion;

/** Queue the incoming notification with the messaging library for processing - notifications usually arrive from `didReceiveRemoteNotification`.
 
 @param notification The incoming notification.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)handleNotification:(nonnull NSDictionary *)notification
                completion:(nullable TCHCompletion)completion;

/** Indicates whether reachability is enabled for this instance.
 
 @return YES if reachability is enabled.
 */
- (BOOL)isReachabilityEnabled;

/** Cleanly shut down the messaging subsystem when you are done with it. */
- (void)shutdown;

/** Get content URLs for all media attachments in the given set using a single network request.

 The returned URLs are impermanent, they will expire in several minutes and thus cannot be cached.
 If the URLs expire, you will need to request new ones. Each call to this function produces new temporary URLs.

 @param media The set of media objects to query content URLs for.
 @param completion The completion block to receive a map of media sids to corresponding temporary content URLs.
 @return The cancellation token to cancel the network request.
 */
- (nullable TCHCancellationToken *)getTemporaryContentUrlsForMedia:(nonnull NSSet<TCHMedia *> *)media
                                                        completion:(nonnull TCHMediaSidsCompletion)completion NS_SWIFT_NAME(getTemporaryContentUrlsFor(media:completion:));

/** Get content URLs for all media attachments in the given set using a single network request.

 The returned URLs are impermanent, they will expire in several minutes and thus cannot be cached.
 If the URLs expire, you will need to request new ones. Each call to this function produces new temporary URLs.

 @param sids The set of media sids to query content URLs for.
 @param completion The completion block to receive a map of media sids to corresponding temporary content URLs.
 @return The cancellation token to cancel the network request.
 */
- (nullable TCHCancellationToken *)getTemporaryContentUrlsForMediaSids:(nonnull NSSet<NSString *> *)sids
                                                            completion:(nonnull TCHMediaSidsCompletion)completion NS_SWIFT_NAME(getTemporaryContentUrlsFor(mediaSids:completion:));

/** Get content templates assigned to the Twilio account.

 Content templates could be created using the Twilio console or REST API.

 @param completion The completion block to receive content templates.
 */
- (void)getContentTemplatesWithCompletion:(nonnull TCHContentTemplatesCompletion)completion NS_SWIFT_NAME(getContentTemplates(completion:));

@end

#pragma mark -

/** Optional conversations client initialization properties. */
__attribute__((visibility("default")))
@interface TwilioConversationsClientProperties : NSObject

@property (nonatomic, copy, nonnull) NSString *region;

/** Timeout in milliseconds for commands which SDK sends over network (i.e. send message, join to a conversation, etc).
 Completion block will be called when timeout is reached.
 
 In case of bad connectivity SDK retries to send command until timeout is reached.
 Timeout could occur earlier than specified time if there is no enough time to make one more attempt.
 
 Value must be between TCHCommandTimeoutMin and TCHCommandTimeoutMax.
 
 Default value is TCHCommandTimeoutDefault.
 */
@property (nonatomic, assign) NSInteger commandTimeout;

/**
 Defer certificate trust decisions to the OS, overriding the default of
 certificate pinning for Twilio back-end connections.

 Twilio client SDKs utilize certificate pinning to prevent man-in-the-middle attacks
 against your connections to our services. Customers in certain very specific
 environments may need to opt-out of this if custom certificate authorities must
 be allowed to intentionally intercept communications for security or policy reasons.

 Setting this property to `true` for a Conversations Client instance will defer to iOS to
 establish whether or not a given connection is providing valid and trusted TLS certificates.

 Keeping this property at its default value of `false` allows the Twilio client SDK
 to determine trust when communicating with our servers.

 The default value is `false`.
 */
@property (nonatomic, readwrite) BOOL deferCertificateTrustToPlatform;

/**
 If useProxy flag is `true` TwilioConversationsClient will try to read and apply system proxy settings.
 If this flag is `false` all proxy settings will be ignored and direct connection will be used.

 The default value is `false`.
 */
@property (nonatomic, readwrite) BOOL useProxy;

/**
 Queue all completions and events would fire from. If not set main queue would be used.
 */
@property (nonatomic, readwrite, nullable) dispatch_queue_t dispatchQueue;

@end

#pragma mark -

/** This protocol declares the conversations client delegate methods. */
__attribute__((visibility("default")))
@protocol TwilioConversationsClientDelegate <NSObject>
@optional

/** Called when the client connection state changes.
 
 @param client The conversations client.
 @param state The current connection state of the client.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
     connectionStateUpdated:(TCHClientConnectionState)state;

/**
 Called when the client's token has expired.
 
 In response, your delegate should generate a new token and call
 `conversationsClient:updateToken:completion:` immediately as connection to
 the server has been lost.
 
 @param client The conversations client.
 */
- (void)conversationsClientTokenExpired:(nonnull TwilioConversationsClient *)client;

/**
 Called when the client's token will expire soon.
 
 In response, your delegate should generate a new token and call
 `conversationsClient:updateToken:completion:` as soon as possible.
 
 @param client The conversations client.
 */
- (void)conversationsClientTokenWillExpire:(nonnull TwilioConversationsClient *)client;

/** Called when the client synchronization state changes during startup.
 
 @param client The conversations client.
 @param status The current synchronization status of the client.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
synchronizationStatusUpdated:(TCHClientSynchronizationStatus)status;

/** Called when the current user has a conversation added to their conversation list.
 
 @param client The conversations client.
 @param conversation The conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
          conversationAdded:(nonnull TCHConversation *)conversation;

/** Called when one of the current user's conversations is changed.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param updated An indication of what changed on the conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
                    updated:(TCHConversationUpdate)updated;

/** Called when the conversation synchronization state is changed.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param status The current synchronization status of the conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
synchronizationStatusUpdated:(TCHConversationSynchronizationStatus)status;

/** Called when current participant is removed from the conversation or conversation is closed or deleted.
 
 @param client The conversations client.
 @param conversation The conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
        conversationDeleted:(nonnull TCHConversation *)conversation;

/** Called when a conversation has a new participant join.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
          participantJoined:(nonnull TCHParticipant *)participant;

/** Called when participant data is modified.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 @param updated An indication of what changed on the participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
                participant:(nonnull TCHParticipant *)participant
                    updated:(TCHParticipantUpdate)updated;

/** Called when a participant has left the conversation.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
            participantLeft:(nonnull TCHParticipant *)participant;

/** Called when a conversation receives a new message.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param message The message.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
               messageAdded:(nonnull TCHMessage *)message;

/** Called when message data is modified.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param message The message.
 @param updated An indication of what changed on the message.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
                    message:(nonnull TCHMessage *)message
                    updated:(TCHMessageUpdate)updated;

/** Called when message is deleted from the conversation.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param message The message.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
               conversation:(nonnull TCHConversation *)conversation
             messageDeleted:(nonnull TCHMessage *)message;

/** Called when an error occurs.
 
 @param client The conversations client.
 @param error The error.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
              errorReceived:(nonnull TCHError *)error;

/** Called when a participant of a conversation starts typing.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
typingStartedOnConversation:(nonnull TCHConversation *)conversation
                participant:(nonnull TCHParticipant *)participant;

/** Called when a participant of a conversation ends typing.
 
 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
  typingEndedOnConversation:(nonnull TCHConversation *)conversation
                participant:(nonnull TCHParticipant *)participant;

/** Called as a result of TwilioConversationsClient's handleNotification: method being invoked for a new message received notification.  `handleNotification:` parses the push payload and extracts the new message's conversation and index for the push notification then calls this delegate method.
 
 @param client The conversations client.
 @param conversationSid The conversation sid for the new message.
 @param messageIndex The index of the new message.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
notificationNewMessageReceivedForConversationSid:(nonnull NSString *)conversationSid
               messageIndex:(NSUInteger)messageIndex;

/** Called as a result of TwilioConversationsClient's handleNotification: method being invoked for an added to conversation notification.  `handleNotification:` parses the push payload and extracts the conversation for the push notification then calls this delegate method.
 
 @param client The conversations client.
 @param conversationSid The conversation sid for the newly added conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
notificationAddedToConversationWithSid:(nonnull NSString *)conversationSid;

/** Called as a result of TwilioConversationsClient's handleNotification: method being invoked for a removed from conversation notification.  `handleNotification:` parses the push payload and extracts the conversation for the push notification then calls this delegate method.
 
 @param client The conversations client.
 @param conversationSid The conversation sid for the removed conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
notificationRemovedFromConversationWithSid:(nonnull NSString *)conversationSid;

/** Called when a processed push notification has changed the application's badge count.  You should call:
 
 UIApplication.sharedApplication.applicationIconBadgeNumber = badgeCount
 
 Please note that badge count indicates the number of 1:1 conversations (2 participants only) that have unread messages.  This does not reflect total unread message count or conversations with more than 2 participants.

 To ensure your application's badge updates when the application is in the foreground if Twilio is managing your badge counts.  You may disregard this delegate callback otherwise.
 
 @param client The conversations client.
 @param badgeCount The updated badge count.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
notificationUpdatedBadgeCount:(NSUInteger)badgeCount;

/** Called when the current user's or that of any subscribed conversation participant's user is updated.
 
 @param client The conversations client.
 @param user The object for changed user.
 @param updated An indication of what changed on the user.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
                       user:(nonnull TCHUser *)user
                    updated:(TCHUserUpdate)updated;

/** Called when the client subscribes to updates for a given user.
 
 @param client The conversations client.
 @param user The object for subscribed user.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
             userSubscribed:(nonnull TCHUser *)user;

/** Called when the client unsubscribes from updates for a given user.
 
 @param client The conversations client.
 @param user The object for unsubscribed user.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client
           userUnsubscribed:(nonnull TCHUser *)user;

@end

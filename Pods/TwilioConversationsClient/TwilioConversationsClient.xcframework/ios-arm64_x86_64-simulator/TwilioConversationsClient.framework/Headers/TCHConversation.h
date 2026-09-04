//
//  TCHConversation.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TwilioConversationsClient/TCHConstants.h>
#import <TwilioConversationsClient/TCHUser.h>
#import <TwilioConversationsClient/TCHJsonAttributes.h>
#import <TwilioConversationsClient/TCHMessageBuilder.h>
#import <TwilioConversationsClient/TCHParticipant.h>
#import <TwilioConversationsClient/TCHConversationLimits.h>

@class TwilioConversationsClient;
@protocol TCHConversationDelegate;

/** Representation of a conversations conversation. */
__attribute__((visibility("default")))
@interface TCHConversation : NSObject

/** Optional conversation delegate.  Upon setting the delegate, you will receive the current conversation synchronization status by delegate method. */
@property (nonatomic, weak, nullable) id<TCHConversationDelegate> delegate;

/** The unique identifier for this conversation. */
@property (nonatomic, copy, readonly, nullable) NSString *sid;

/** The friendly name for this conversation. */
@property (nonatomic, copy, readonly, nullable) NSString *friendlyName;

/** The unique name for this conversation. */
@property (nonatomic, copy, readonly, nullable) NSString *uniqueName;

/** The current user's notification level on this conversation. This property reflects whether the
 user will receive push notifications for activity on this conversation.*/
@property (nonatomic, assign, readonly) TCHConversationNotificationLevel notificationLevel;

/** The conversation's synchronization status. */
@property (nonatomic, assign, readonly) TCHConversationSynchronizationStatus synchronizationStatus;

/** The current user's status on this conversation. */
@property (nonatomic, assign, readonly) TCHConversationStatus status;

/** The current state for this conversation. */
@property (readonly) TCHConversationState state;

/** The date when TCHConversationState was last updated. */
@property (readonly, nullable) NSDate *stateDateUpdatedAsDate;

/** The identity of the conversation's creator. */
@property (nonatomic, copy, readonly, nullable) NSString *createdBy;

/** The conversation creation date. */
@property (nonatomic, strong, readonly, nullable) NSString *dateCreated;

/** The conversation creation date as an NSDate. */
@property (nonatomic, strong, readonly, nullable) NSDate *dateCreatedAsDate;

/** The timestamp the conversation was last updated. */
@property (nonatomic, strong, readonly, nullable) NSString *dateUpdated;

/** The timestamp the conversation was last updated as an NSDate. */
@property (nonatomic, strong, readonly, nullable) NSDate *dateUpdatedAsDate;

/** The timestamp of the conversation's most recent message. */
@property (nonatomic, strong, readonly, nullable) NSDate *lastMessageDate;

/** The index of the conversation's most recent message. */
@property (nonatomic, strong, readonly, nullable) NSNumber *lastMessageIndex;

/** Index of the last Message the User has marked as read in this Conversation. */
@property (nonatomic, copy, readonly, nullable) NSNumber *lastReadMessageIndex;

/** Limits for attachments per each message in the conversation. */
@property (nonatomic, readonly, nonnull) TCHConversationLimits *limits;

/** Return this conversation's attributes.

 @return The developer-defined extensible attributes for this conversation.
 */
- (nullable TCHJsonAttributes *)attributes;

/** Set this conversation's attributes.

 @param attributes The new developer-defined extensible attributes for this conversation. (Supported types are NSString, NSNumber, NSArray, NSDictionary and NSNull)
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setAttributes:(nullable TCHJsonAttributes *)attributes
           completion:(nullable TCHCompletion)completion;

/** Set this conversation's friendly name.

 @param friendlyName The new friendly name for this conversation.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setFriendlyName:(nullable NSString *)friendlyName
             completion:(nullable TCHCompletion)completion;

/** Set this conversation's unique name.

 @param uniqueName The new unique name for this conversation.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setUniqueName:(nullable NSString *)uniqueName
           completion:(nullable TCHCompletion)completion;

/** Set the user's notification level for the conversation.  This property determines whether the
 user will receive push notifications for activity on this conversation.

 @param notificationLevel The new notification level for the current user on this conversation.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setNotificationLevel:(TCHConversationNotificationLevel)notificationLevel
                  completion:(nullable TCHCompletion)completion;

/** Join the current user to this conversation.

 @param completion Completion block that will specify the result of the operation.
 */
- (void)joinWithCompletion:(nullable TCHCompletion)completion;

/** Leave the current conversation.

 @param completion Completion block that will specify the result of the operation.
 */
- (void)leaveWithCompletion:(nullable TCHCompletion)completion;

/** Destroy the current conversation, removing all of its participants.

 @param completion Completion block that will specify the result of the operation.
 */
- (void)destroyWithCompletion:(nullable TCHCompletion)completion;

/** Indicates to other users and the backend that the user is typing a message to this conversation. */
- (void)typing;

/** Prepares a new message to send into the conversation.

 @return The message builder for building a new message and sending it into the conversation.

 Example of usage:
 @code
 conversation.prepareMessage()
    .setBody("message body")
    .addMedia(mediaData, "image/jpeg", "filename.jpg", .init(onStarted: {
        print("Media upload started")
    } onProgress: { bytesSent in
        print("Current progress \(bytesSent)")
    } onCompleted: { mediaSid in
        print("Media uploaded with sid \(mediaSid)")
    } onFailed: { error in
        print("Media upload failed with error \(error)")
    }))
    .buildAndSend { result, message in
        print("Message sent with result \(result)")
    }
 @endcode
 */
- (nonnull TCHMessageBuilder *)prepareMessage;

/** Removes the specified message from the conversation.

 @param message The message to remove.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeMessage:(nonnull TCHMessage *)message
           completion:(nullable TCHCompletion)completion;

/** Fetches the most recent `count` messages.  This will return locally cached messages if they are all available or may require a load from the server.

 @param count The number of most recent messages to return.
 @param completion Completion block that will specify the result of the operation as well as the requested messages if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)getLastMessagesWithCount:(NSUInteger)count
                      completion:(nonnull TCHMessagesCompletion)completion;

/** Fetches at most `count` messages including and prior to the specified `index`.  This will return locally cached messages if they are all available or may require a load from the server.

 @param index The starting point for the request.
 @param count The number of preceding messages to return.
 @param completion Completion block that will specify the result of the operation as well as the requested messages if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)getMessagesBefore:(NSUInteger)index
                withCount:(NSUInteger)count
               completion:(nonnull TCHMessagesCompletion)completion;

/** Fetches at most `count` messages including and subsequent to the specified `index`.  This will return locally cached messages if they are all available or may require a load from the server.

 @param index The starting point for the request.
 @param count The number of succeeding messages to return.
 @param completion Completion block that will specify the result of the operation as well as the requested messages if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)getMessagesAfter:(NSUInteger)index
               withCount:(NSUInteger)count
              completion:(nonnull TCHMessagesCompletion)completion;

/** Returns the message with the specified index.

 @param index The index of the message.
 @param completion Completion block that will specify the result of the operation as well as the requested message if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)messageWithIndex:(nonnull NSNumber *)index
              completion:(nonnull TCHMessageCompletion)completion;

/** Returns the oldest message starting at index.  If the message at index does not exist, the next message will be returned.

 @param index The index of the last message reported as read (may refer to a deleted message).
 @param completion Completion block that will specify the result of the operation as well as the requested message if successful.  If no completion block is specified, no operation will be executed.
 */
- (void)messageForReadIndex:(nonnull NSNumber *)index
                 completion:(nonnull TCHMessageCompletion)completion;

/** Set the last read index for this Participant and Conversation.  Allows you to set any value, including smaller than the current index.

 @param index The new index.
 @param completion Optional completion block that will specify the result of the operation and an updated unread message count for the user on this conversation.
 */
- (void)setLastReadMessageIndex:(nonnull NSNumber *)index
                     completion:(nullable TCHCountCompletion)completion;

/** Update the last read index for this Participant and Conversation.  Only update the index if the value specified is larger than the previous value.

 @param index The new index.
 @param completion Optional completion block that will specify the result of the operation and an updated unread message count for the user on this conversation.
 */
- (void)advanceLastReadMessageIndex:(nonnull NSNumber *)index
                         completion:(nullable TCHCountCompletion)completion;

/** Update the last read index for this Participant and Conversation to the max message currently on this device.

 @param completion Optional completion block that will specify the result of the operation and an updated unread message count for the user on this conversation.
 */
- (void)setAllMessagesReadWithCompletion:(nullable TCHCountCompletion)completion;

/** Reset the last read index for this Participant and Conversation to no messages read.

 @param completion Optional completion block that will specify the result of the operation and an updated unread message count for the user on this conversation.
 */
- (void)setAllMessagesUnreadWithCompletion:(nullable TCHNullableCountCompletion)completion;

/** Fetch the number of unread messages on this conversation for the current user.

 Use this method to obtain number of unread messages together with
 [TCHConversation setLastReadMessageIndex:completion:] instead of relying on
 TCHMessage indices which may have gaps. See [TCHMessage index] for details.

 Available even if the conversation is not yet synchronized.

 Note: if the last read index has not been yet set for current user as the participant of this conversation
 then unread messages count is considered uninitialized. In this case nil is returned.
 See [TCHConversation setLastReadMessageIndex:completion:].

 This method is semi-realtime. This means that this data will be eventually correct,
 but will also possibly be incorrect for a few seconds. The Conversations system does not
 provide real time events for counter values changes.

 So this is quite useful for any “unread messages count” badges, but is not recommended
 to build any core application logic based on these counters being accurate in real time.
 This function performs an async call to service to obtain up-to-date message count.

 The retrieved value is then cached for 5 seconds so there is no reason to call this
 function more often than once in 5 seconds.

 @param completion Completion block that will specify the requested count.  If no completion block is specified, no operation will be executed.
 */
- (void)getUnreadMessagesCountWithCompletion:(nonnull TCHNullableCountCompletion)completion;

/** Fetch the number of messages on this conversation.

 Available even if the conversation is not yet synchronized.

 This method is semi-realtime. This means that this data will be eventually correct,
 but will also possibly be incorrect for a few seconds. The Conversations system does not
 provide real time events for counter values changes.

 So this is quite useful for any UI badges, but is not recommended
 to build any core application logic based on these counters being accurate in real time.
 This function performs an async call to service to obtain up-to-date message count.

 The retrieved value is then cached for 5 seconds so there is no reason to call this
 function more often than once in 5 seconds.

 @param completion Completion block that will specify the requested count.  If no completion block is specified, no operation will be executed.
 */
- (void)getMessagesCountWithCompletion:(nonnull TCHCountCompletion)completion;

/** Fetch the number of participants on this conversation.

 Available even if the conversation is not yet synchronized.

 This method is semi-realtime. This means that this data will be eventually correct,
 but will also possibly be incorrect for a few seconds. The Conversations system does not
 provide real time events for counter values changes.

 So this is quite useful for any UI badges, but is not recommended
 to build any core application logic based on these counters being accurate in real time.
 This function performs an async call to service to obtain up-to-date message count.

 The retrieved value is then cached for 5 seconds so there is no reason to call this
 function more often than once in 5 seconds.

 @param completion Completion block that will specify the requested count.  If no completion block is specified, no operation will be executed.
 */
- (void)getParticipantsCountWithCompletion:(nonnull TCHCountCompletion)completion;

/** Obtain the participants of this conversation.
 */
- (nonnull NSArray<TCHParticipant *> *)participants;

/** Add specified username to this conversation.

 @param identity The username to add to this conversation.
 @param attributes The developer-defined extensible attributes for participant or nil to use default empty attributes. (Supported types are NSString, NSNumber, NSArray, NSDictionary and NSNull)
 @param completion Completion block that will specify the result of the operation.
 */
- (void)addParticipantByIdentity:(nonnull NSString *)identity
                      attributes:(nullable TCHJsonAttributes *)attributes
                      completion:(nullable TCHCompletion)completion;

/**  Add specified non chat participant to this conversation, i.e. sms, whatsapp participants etc.

 @param address The participant address to add to this conversation (phone number for sms and whatsapp participants)
 @param proxyAddress Proxy address (Twilio phone number for sms and whatsapp participants).
 See conversations quickstart for more info: https://www.twilio.com/docs/conversations/quickstart
 @param attributes The developer-defined extensible attributes for participant or nil to use default empty attributes. (Supported types are NSString, NSNumber, NSArray, NSDictionary and NSNull)
 @param completion Completion block that will specify the result of the operation.
 */
- (void)addParticipantByAddress:(nonnull NSString *)address
                   proxyAddress:(nonnull NSString *)proxyAddress
                     attributes:(nullable TCHJsonAttributes *)attributes
                     completion:(nullable TCHCompletion)completion;

/** Remove specified participant from this conversation.

 @param participant The participant to remove from this conversation.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeParticipant:(nonnull TCHParticipant *)participant
               completion:(nullable TCHCompletion)completion;

/** Remove specified username from this conversation.

 @param identity The username to remove from this conversation.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeParticipantByIdentity:(nonnull NSString *)identity
                         completion:(nullable TCHCompletion)completion;

/** Fetch the participant object for the given identity if it exists.

 @param identity The username to fetch.
 @return The TCHParticipant object, if one exists for the username for this conversation.
 */
- (nullable TCHParticipant *)participantWithIdentity:(nonnull NSString *)identity;

/** Fetch the participant object for the given SID if it exists.

 @param sid The participant's SID.
 @return The TCHParticipant object, if one exists for the SID for this conversation.
 */
- (nullable TCHParticipant *)participantWithSid:(nonnull NSString *)sid;

@end

/** This protocol declares the conversation delegate methods. */
__attribute__((visibility("default")))
@protocol TCHConversationDelegate <NSObject>
@optional
/** Called when this conversation is changed.

 @param client The conversations client.
 @param conversation The conversation.
 @param updated An indication of what changed on the conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation updated:(TCHConversationUpdate)updated;

/** Called when current participant is removed from the conversation or conversation is closed or deleted.

 @param client The conversations client.
 @param conversation The conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversationDeleted:(nonnull TCHConversation *)conversation;

/** Called when the conversation synchronization state is changed.

 @param client The conversations client.
 @param conversation The conversation.
 @param status The current synchronization status of the conversation.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation synchronizationStatusUpdated:(TCHConversationSynchronizationStatus)status;

/** Called when this conversation has a new participant join.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation participantJoined:(nonnull TCHParticipant *)participant;

/** Called when participant data is modified.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 @param updated An indication of what changed on the participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation participant:(nonnull TCHParticipant *)participant updated:(TCHParticipantUpdate)updated;

/** Called when a participant has left this conversation.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation participantLeft:(nonnull TCHParticipant *)participant;

/** Called when this conversation receives a new message.

 @param client The conversations client.
 @param conversation The conversation.
 @param message The message.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation messageAdded:(nonnull TCHMessage *)message;

/** Called when message data is modified.

 @param client The conversations client.
 @param conversation The conversation.
 @param message The message.
 @param updated An indication of what changed on the message.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation message:(nonnull TCHMessage *)message updated:(TCHMessageUpdate)updated;

/** Called when message is deleted from the conversation.

 @param client The conversations client.
 @param conversation The conversation.
 @param message The message.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation messageDeleted:(nonnull TCHMessage *)message;

/** Called when a participant of a conversation starts typing.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client typingStartedOnConversation:(nonnull TCHConversation *)conversation participant:(nonnull TCHParticipant *)participant;

/** Called when a participant of a conversation ends typing.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client typingEndedOnConversation:(nonnull TCHConversation *)conversation participant:(nonnull TCHParticipant *)participant;

/** Called when this conversation has a participant's user updated.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 @param user The object for changed user.
 @param updated An indication of what changed on the user.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation participant:(nonnull TCHParticipant *)participant user:(nonnull TCHUser *)user updated:(TCHUserUpdate)updated;

/** Called when the user associated with a participant of this conversation is subscribed to.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 @param user The object for subscribed user.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation participant:(nonnull TCHParticipant *)participant userSubscribed:(nonnull TCHUser *)user;

/** Called when the user associated with a participant of this conversation is unsubscribed from.

 @param client The conversations client.
 @param conversation The conversation.
 @param participant The participant.
 @param user The object for unsubscribed user.
 */
- (void)conversationsClient:(nonnull TwilioConversationsClient *)client conversation:(nonnull TCHConversation *)conversation participant:(nonnull TCHParticipant *)participant userUnsubscribed:(nonnull TCHUser *)user;

@end

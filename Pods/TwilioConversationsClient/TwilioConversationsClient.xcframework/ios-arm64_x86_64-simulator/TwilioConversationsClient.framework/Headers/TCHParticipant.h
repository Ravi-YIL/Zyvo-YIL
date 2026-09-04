//
//  TCHParticipant.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TwilioConversationsClient/TCHConstants.h>
#import <TwilioConversationsClient/TCHJsonAttributes.h>

/** Representation of a Participant on a conversations conversation. */
__attribute__((visibility("default")))
@interface TCHParticipant : NSObject

/** The conversation for this participant. */
@property (nonatomic, weak, readonly, nullable) TCHConversation *conversation;

/** The unique identifier for this participant. */
@property (nonatomic, copy, readonly, nullable) NSString *sid;

/** The identity for this participant. */
@property (nonatomic, strong, readonly, nullable) NSString *identity;

/** The type of this participant. */
@property (nonatomic, readonly) TCHParticipantType type;

/** Index of the last Message the Participant has read in this Conversation. */
@property (nonatomic, copy, readonly, nullable) NSNumber *lastReadMessageIndex;

/** Timestamp the last read message index updated for the Participant in this Conversation. */
@property (nonatomic, copy, readonly, nullable) NSString *lastReadTimestamp;

/** Timestamp the last read message index updated for the Participant in this Conversation as an NSDate. */
@property (nonatomic, strong, readonly, nullable) NSDate *lastReadTimestampAsDate;

/** The Participant creation date. */
@property (nonatomic, copy, readonly, nullable) NSString *dateCreated;

/** The Participant creation date as an NSDate. */
@property (nonatomic, copy, readonly, nullable) NSDate *dateCreatedAsDate;

/** The Participant last update date. */
@property (nonatomic, copy, readonly, nullable) NSString *dateUpdated;

/** The Participant last update date as an NSDate. */
@property (nonatomic, copy, readonly, nullable) NSDate *dateUpdatedAsDate;

/** Return this participant's attributes.

 @return The developer-defined extensible attributes for this participant.
 */
- (nullable TCHJsonAttributes *)attributes;

/** Set this participant's attributes.

 @param attributes The new developer-defined extensible attributes for this participant. (Supported types are NSString, NSNumber, NSArray, NSDictionary and NSNull)
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setAttributes:(nullable TCHJsonAttributes *)attributes
           completion:(nullable TCHCompletion)completion;

/** Obtain a subscribed user object for the participant.  If no current subscription exists for this user, this will
 fetch the user and subscribe them.  The least recently subscribed user object will be unsubscribed if you reach your instance's
 user subscription limit.

 @param completion Completion block that will specify the result of the operation and the newly subscribed user.
 */
- (void)subscribedUserWithCompletion:(nonnull TCHUserCompletion)completion;

/** Remove this participant from conversation

 @param completion Completion block that will specify the result of the operation.
 */
- (void)removeWithCompletion:(nullable TCHCompletion)completion;

@end

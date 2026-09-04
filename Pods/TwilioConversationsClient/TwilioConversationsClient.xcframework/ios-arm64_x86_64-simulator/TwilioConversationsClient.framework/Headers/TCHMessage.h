//
//  TCHMessage.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TwilioConversationsClient/TCHConstants.h>
#import <TwilioConversationsClient/TCHJsonAttributes.h>
#import <TwilioConversationsClient/TCHAggregatedDeliveryReceipt.h>
#import <TwilioConversationsClient/TCHDetailedDeliveryReceipt.h>
#import <TwilioConversationsClient/TCHMedia.h>
#import <TwilioConversationsClient/TCHUnsentMessage.h>
#import <TwilioConversationsClient/TCHContentTemplate.h>

@class TCHParticipant;

/** Representation of a Message on a conversations conversation. */
__attribute__((visibility("default")))
@interface TCHMessage : NSObject

/** The unique identifier for this message. */
@property (nonatomic, copy, readonly, nullable) NSString *sid;

/** Index of Message in the Conversation's messages stream.

 By design of the conversations system the message indices may have arbitrary gaps between them,
 that does not necessarily mean they were deleted or otherwise modified - just that
 messages may have non-contiguous indices even if they are sent immediately one after another.

 Trying to use indices for some calculations is going to be unreliable.

 To calculate the number of unread messages it is better to use the read horizon API.
 See [TCHConversation getUnreadMessagesCountWithCompletion:] for details.
 */
@property (nonatomic, copy, readonly, nullable) NSNumber *index;

/** The identity of the author of the message. */
@property (nonatomic, copy, readonly, nullable) NSString *author;

/** The subject of the message. */
@property (nonatomic, copy, readonly, nullable) NSString *subject;

/** The body of the message.

 For an email the body will contain the preview for the email.
 To get full email body call `getEmailBodyForContentType`
 */
@property (nonatomic, copy, readonly, nullable) NSString *body;

/// The content sid of a template if the message is a templated one, see [TCHContentTemplate]
@property (nonatomic, copy, readonly, nullable) NSString *contentSid;

/** The SID of the participant this message is sent by. */
@property (nonatomic, copy, readonly, nullable) NSString *participantSid;

/** The participant this message is sent by. */
@property (nonatomic, copy, readonly, nullable) TCHParticipant *participant;

/** The message creation date. */
@property (nonatomic, copy, readonly, nullable) NSString *dateCreated;

/** The message creation date as an NSDate. */
@property (nonatomic, strong, readonly, nullable) NSDate *dateCreatedAsDate;

/** The message last update date. */
@property (nonatomic, copy, readonly, nullable) NSString *dateUpdated;

/** The message last update date as an NSDate. */
@property (nonatomic, strong, readonly, nullable) NSDate *dateUpdatedAsDate;

/** The identity of the user who updated the message. */
@property (nonatomic, copy, readonly, nullable) NSString *lastUpdatedBy;

/** Aggregated delivery receipt for the message. */
@property (readonly, nullable) TCHAggregatedDeliveryReceipt *aggregatedDeliveryReceipt;

/**  All media attachments (not including email body/history attachments). */
@property (readonly, nonnull) NSArray<TCHMedia *> *attachedMedia;

/** Get detailed delivery receipts for the message.

 @param completion Completion block that will specify the result of the operation.
 */
- (void)getDetailedDeliveryReceiptsWithCompletion:(nonnull TCHDetailedDeliveryReceiptsCompletion)completion;

/** Update the body of this message
 
 @param body The new body for this message.
 @param completion Completion block that will specify the result of the operation.
 */
- (void)updateBody:(nonnull NSString *)body
        completion:(nullable TCHCompletion)completion;

/** Return this message's attributes.
 
 @return The developer-defined extensible attributes for this message.
 */
- (nullable TCHJsonAttributes *)attributes;

/** Set this message's attributes.
 
 @param attributes The new developer-defined extensible attributes for this message. (Supported types are NSString, NSNumber, NSArray, NSDictionary and NSNull)
 @param completion Completion block that will specify the result of the operation.
 */
- (void)setAttributes:(nullable TCHJsonAttributes *)attributes
           completion:(nullable TCHCompletion)completion;

/** Download the content data for the message.

 See [TCHContentDataType] for the list of available content data types and corresponding data classes.

 @param completion Completion block that will specify the result of the operation.
 */
- (void)getContentDataWithCompletion:(nonnull TCHContentDataCompletion)completion NS_SWIFT_NAME(getContentData(completion:));

/** Return a list of media matching the specific set of categories.

 @param categories The set of categories to match.
 @return The list of media descriptors matching given categories.
 */
- (nonnull NSArray<TCHMedia *> *)getMediaByCategories:(nonnull NSSet<NSNumber *> *)categories;

/** Returns the email body attachment of the default text/plain content type.

 @return The email body attachment or nil if message has no email body for the requested content type.
 */
- (nullable TCHMedia *)getEmailBody NS_SWIFT_NAME(getEmailBody());

/** Returns the email body attachment of the specific content type.

 @param contentType The type to match.
 @return The email body attachment or nil if message has no email body for the requested content type.
 */
- (nullable TCHMedia *)getEmailBodyForContentType:(nonnull NSString *)contentType NS_SWIFT_NAME(getEmailBody(contentType:));

/** Returns the email history attachment of the default text/plain content type.

 @return The email history attachment or nil if message has no email history for the requested content type.
 */
- (nullable TCHMedia *)getEmailHistory NS_SWIFT_NAME(getEmailHistory());

/** Returns the email history attachment of the specific content type.

 @param contentType The type to match.
 @return The email history attachment or nil if message has no email history for the requested content type.
 */
- (nullable TCHMedia *)getEmailHistoryForContentType:(nonnull NSString *)contentType NS_SWIFT_NAME(getEmailHistory(contentType:));

/** Get content URLs for all attached media using a single network request.

 The returned URLs are impermanent, they will expire in several minutes and thus cannot be cached.
 If  the URLs expire, you will need to request new ones. Each call to this function produces new temporary URLs.

 @param completion The listener to receive a map of media sids to content temporary URL.
 @return The cancellation token to cancel the network request.
 */
- (nullable TCHCancellationToken *)getTemporaryContentUrlsForAttachedMediaWithCompletion:(nonnull TCHMediaSidsCompletion)completion NS_SWIFT_NAME(getTemporaryContentUrlsForAttachedMedia(completion:));

/** Get content URLs for all media attachments in the given set using a single network request.

 This is a convenience method, see [TwilioConversationsClient getTemporaryContentUrlsForMedia:completion:]

 The returned URLs are impermanent, they will expire in several minutes and thus cannot be cached.
 If the URLs expire, you will need to request new ones. Each call to this function produces new temporary URLs.

 @param media The set of media objects to query content URLs for.
 @param completion The completion block to receive a map of media sids to corresponding temporary content URLs.
 @return The cancellation token to cancel the network request.
 */
- (nullable TCHCancellationToken *)getTemporaryContentUrlsForMedia:(nonnull NSSet<TCHMedia *> *)media
                                                        completion:(nonnull TCHMediaSidsCompletion)completion NS_SWIFT_NAME(getTemporaryContentUrlsFor(media:completion:));

/** Get content URLs for all media attachments in the given set using a single network request.

 This is a convenience method, see [TwilioConversationsClient getTemporaryContentUrlsForMediaSids:completion:]

 The returned URLs are impermanent, they will expire in several minutes and thus cannot be cached.
 If the URLs expire, you will need to request new ones. Each call to this function produces new temporary URLs.

 @param sids The set of media sids to query content URLs for.
 @param completion The completion block to receive a map of media sids to corresponding temporary content URLs.
 @return The cancellation token to cancel the network request.
 */
- (nullable TCHCancellationToken *)getTemporaryContentUrlsForMediaSids:(nonnull NSSet<NSString *> *)sids
                                                            completion:(nonnull TCHMediaSidsCompletion)completion NS_SWIFT_NAME(getTemporaryContentUrlsFor(mediaSids:completion:));

@end

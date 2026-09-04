//
//  TCHDetailedDeliveryReceipt.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Enumeration indicating the delivery status of a message.
 */
typedef NS_ENUM(NSUInteger, TCHDeliveryStatus) {
    TCHDeliveryStatusRead = 0,      ///< Message considered as <b>read</b> by a participant, if the message has been delivered and opened by the recipient in the conversation. The recipient must have enabled read receipts.
    TCHDeliveryStatusUndelivered,   ///< Message considered as <b>undelivered</b> to a participant, if Twilio has received a delivery receipt indicating that the message was not delivered. This can happen for many reasons including carrier content filtering and the availability of the destination handset.
    TCHDeliveryStatusDelivered,     ///< Message considered as <b>delivered</b> to a participant, if Twilio has received confirmation of message delivery from the upstream carrier, and, where available, the destination handset.
    TCHDeliveryStatusFailed,        ///< Message considered as <b>failed</b> to be delivered to a participant if the message could not be sent. This can happen for various reasons including queue overflows, account suspensions and media errors (in the case of MMS for instance).
    TCHDeliveryStatusSent,          ///< Message considered as <b>sent</b> to a participant, if the nearest upstream carrier accepted the message.
    TCHDeliveryStatusQueued,        ///< Message considered as <b>queued</b>, if it is waiting in a queue to be sent to an upstream carrier.
};

/**
 * Contains the detailed information about the TCHMessage's delivery status to the TCHParticipant
 */
__attribute__((visibility("default")))
@interface TCHDetailedDeliveryReceipt : NSObject

/**
 * The delivery status of the TCHMessage delivery to the TCHParticipant.
 */
@property (readonly) TCHDeliveryStatus status;

/**
 * The unique identifier for this receipt.
 */
@property (readonly) NSString *sid;

/**
 * The unique identifier of a TCHMessage which this receipt is for.
 */
@property (readonly) NSString *messageSid;

/**
 * The unique idenitifier of a TCHConversation which this receipt is for.
 */
@property (readonly) NSString *conversationSid;

/**
 * The messaging channel-specific identifier for the message delivered to participant,
 * e.g. SMxx for text messages and MMxx for media messages etc.
 */
@property (readonly) NSString *channelMessageSid;

/**
 * The unique identifier of TCHParticipant which this receipt is for.
 */
@property (readonly) NSString *participantSid;

/**
 * The error code of the delivery operation which points to a detailed description of the reason
 * why the TCHMessage cannot be delivered to the TCHParticipant.
 */
@property (readonly) NSInteger errorCode;

/**
 * The timestamp the receipt was created as an NSDate.
 */
@property (readonly) NSDate *dateCreatedAsDate;

/**
 * The timestamp the receipt was last updated as an NSDate.
 */
@property (readonly) NSDate *dateUpdatedAsDate;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

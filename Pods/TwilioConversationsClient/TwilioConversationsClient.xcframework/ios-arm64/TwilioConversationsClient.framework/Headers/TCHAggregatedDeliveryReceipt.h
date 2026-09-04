//
//  TCHAggregatedDeliveryReceipt.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Enumeration indicating the amount of participants which have the status for the message. */
typedef NS_ENUM(NSUInteger, TCHDeliveryAmount) {
    TCHDeliveryAmountNone = 0,      ///< The amount for the delivery receipt status is 0. So no delivery event has been received with that status for the specified message.
    TCHDeliveryAmountSome,          ///< Amount of the delivery receipt status is at least 1. So at least one delivery event has been received.
    TCHDeliveryAmountAll            ///< Amount of the delivery receipt status equals the maximum number of delivery events expected for that message. The maximum number of delivery events expected for that message is returned by TCHAggregatedDeliveryReceipt.total.
};

/**
 * Contains aggregated information about a TCHMessage's delivery statuses across all participants
 * of a TCHConversation.
 *
 * At any moment during delivering message to a TCHParticipant the message can have zero or more of following
 * delivery statuses:
 *
 * Message considered as <b>sent</b> to a participant, if the nearest upstream carrier accepted the message.
 *
 * Message considered as <b>delivered</b> to a participant, if Twilio has received confirmation of message
 * delivery from the upstream carrier, and, where available, the destination handset.
 *
 * Message considered as <b>undelivered</b> to a participant, if Twilio has received a delivery receipt
 * indicating that the message was not delivered. This can happen for many reasons including carrier content
 * filtering and the availability of the destination handset.
 *
 * Message considered as <b>read</b> by a participant, if the message has been delivered and opened by the
 * recipient in the conversation. The recipient must have enabled read receipts.
 *
 * Message considered as <b>failed</b> to be delivered to a participant if the message could not be sent.
 * This can happen for various reasons including queue overflows, account suspensions and media
 * errors (in the case of MMS for instance).
 *
 * TCHAggregatedDeliveryReceipt class contains aggregated value TCHDeliveryAmount for each delivery status.
 * The TCHDeliveryAmount displays amount of participants which have the status for the message.
 */
__attribute__((visibility("default")))
@interface TCHAggregatedDeliveryReceipt : NSObject

/**
 * Maximum number of delivery events expected for the message.
 */
@property (readonly) NSInteger total;

/**
 * Message considered as <b>sent</b> to a participant, if the nearest upstream carrier accepted the message.
 *
 * TCHDeliveryAmount of participants that have <b>sent</b> delivery status for the message.
 */
@property (readonly) TCHDeliveryAmount sent;

/**
 * Message considered as <b>delivered</b> to a participant, if Twilio has received confirmation of message
 * delivery from the upstream carrier, and, where available, the destination handset.
 *
 * TCHDeliveryAmount of participants that have <b>delivered</b> delivery status for the message.
 */
@property (readonly) TCHDeliveryAmount delivered;

/**
 * Message considered as <b>undelivered</b> to a participant, if Twilio has received a delivery receipt
 * indicating that the message was not delivered. This can happen for many reasons including carrier content
 * filtering and the availability of the destination handset.
 *
 * TCHDeliveryAmount of participants that have <b>undelivered</b> delivery status for the message.
 */
@property (readonly) TCHDeliveryAmount undelivered;

/**
 * Message considered as <b>read</b> by a participant, if the message has been delivered and opened by the
 * recipient in the conversation. The recipient must have enabled read receipts.
 *
 * TCHDeliveryAmount of participants that have <b>read</b> delivery status for the message.
 */
@property (readonly) TCHDeliveryAmount read;

/**
 * Message considered as <b>failed</b> to be delivered to a participant if the message could not be sent.
 * This can happen for various reasons including queue overflows, account suspensions and media
 * errors (in the case of MMS for instance). Twilio does not charge you for failed messages.
 *
 * TCHDeliveryAmount of participants that have <b>failed</b> delivery status for the message.
 */
@property (readonly) TCHDeliveryAmount failed;

@end

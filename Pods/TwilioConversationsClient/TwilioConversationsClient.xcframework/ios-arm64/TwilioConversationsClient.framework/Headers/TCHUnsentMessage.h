//
//  TCHUnsentMessage.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <TwilioConversationsClient/TCHConstants.h>

NS_ASSUME_NONNULL_BEGIN

@class TCHCancellationToken;

/** The representation of an unsent message in a conversation. */
__attribute__((visibility("default")))
NS_SWIFT_NAME(UnsentMessage)
@interface TCHUnsentMessage : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/** Send the previously prepared message to a conversation.

 @param completion The completion block with the result of the operation.
 */
- (TCHCancellationToken *)sendWithCompletion:(nullable TCHMessageCompletion)completion NS_SWIFT_NAME(send(completion:));

@end

NS_ASSUME_NONNULL_END

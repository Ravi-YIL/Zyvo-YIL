//
//  TCHConversationLimits.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** Limits for attachments per each message in a conversation. */
__attribute__((visibility("default")))
NS_SWIFT_NAME(ConversationLimits)
@interface TCHConversationLimits : NSObject

/** The maximum number of attachments per message. */
@property (nonatomic, readonly) NSInteger mediaAttachmentsCountLimit;

/** The maximum size of each attachment. */
@property (nonatomic, readonly) NSInteger mediaAttachmentSizeLimitInMb;

/** The maximum total size of all attachments of one message. */
@property (nonatomic, readonly) NSInteger mediaAttachmentsTotalSizeLimitInMb;

/** The list of content types supported for email body. */
@property (nonatomic, readonly) NSArray<NSString *> *emailBodiesAllowedContentTypes;

/** The list of content types supported for email history. */
@property (nonatomic, readonly) NSArray<NSString *> *emailHistoriesAllowedContentTypes;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

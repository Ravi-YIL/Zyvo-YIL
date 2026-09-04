//
//  TCHMedia.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <TwilioConversationsClient/TCHConstants.h>
#import <TwilioConversationsClient/TCHCancellationToken.h>

NS_ASSUME_NONNULL_BEGIN

/** The media representation of a media information of a message in a conversation. */
__attribute__((visibility("default")))
NS_SWIFT_NAME(Media)
@interface TCHMedia: NSObject

/** The server-assigned unique identifier for the media. */
@property (nonatomic, readonly) NSString *sid;

/** The content type of the media. */
@property (nonatomic, readonly) NSString *contentType;

/** The media category. */
@property (nonatomic, readonly) TCHMediaCategory category;

/** The file name of the media if present, nil otherwise. */
@property (nonatomic, readonly, nullable) NSString *filename;

/** The size of the media in bytes. */
@property (nonatomic, readonly) NSUInteger size;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/** Get a direct content URL for the media attachment.

 The returned URL is impermanent, it will expire in several minutes and thus cannot be cached.
 If the URL expires, you will need to request a new one. Each call to this function produces a new temporary URL.

 @param completion The completion block with a result and a temporary URL for.
 @return The cancellation token to cancel the network request.
 */
- (TCHCancellationToken *)getTemporaryContentUrlWithCompletion:(TCHURLCompletion)completion NS_SWIFT_NAME(getTemporaryContentUrl(completion:));

@end

NS_ASSUME_NONNULL_END

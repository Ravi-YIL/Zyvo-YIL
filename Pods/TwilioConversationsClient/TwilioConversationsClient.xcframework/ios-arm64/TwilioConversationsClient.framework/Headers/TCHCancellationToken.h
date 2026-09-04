//
//  TCHCancellationToken.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/** The interface to cancel a network request. */
__attribute__((visibility("default")))
NS_SWIFT_NAME(CancellationToken)
@interface TCHCancellationToken : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/** Cancel the network request.

 The request could be already transmitted to the backend or could be not.
 In case when it has been already transmitted cancellation doesn't
 rollback any actions made by the request, just ignores the response.
 */
- (void)cancel;

@end

NS_ASSUME_NONNULL_END

//
//  TCHMessageBuilder.h
//  Twilio Conversations Client
//
//  Copyright (c) Twilio, Inc. All rights reserved.
//

#import <TwilioConversationsClient/TCHConstants.h>
#import <TwilioConversationsClient/TCHCancellationToken.h>
#import <TwilioConversationsClient/TCHContentTemplate.h>

NS_ASSUME_NONNULL_BEGIN

@class TCHJsonAttributes;
@class TCHUnsentMessage;

/** A listener interface for reporting media upload progress. */
__attribute__((visibility("default")))
NS_SWIFT_NAME(MediaMessageListener)
@interface TCHMediaMessageListener : NSObject

/** The block to report the beginning of a media uploading. */
@property (nonatomic, nullable) TCHMediaOnStarted onStarted;

/** The block to report the running progress of a media uploading. */
@property (nonatomic, nullable) TCHMediaOnProgress onProgress;

/** The block to report the successful completion of a media uploading. */
@property (nonatomic, nullable) TCHMediaOnCompleted onCompleted;

/** The block to report a error while uploading a media. */
@property (nonatomic, nullable) TCHMediaOnFailed onFailed;

/** The initializator to pass all block at once.

 @param onStarted The block to report the beginning of a media uploading.
 @param onProgress The block to report the running progress of a media uploading.
 @param onCompleted The block to report the successful completion of a media uploading.
 @param onFailed The block to report a error while uploading a media.
 */
- (instancetype)initWithOnStarted:(nullable TCHMediaOnStarted)onStarted
                       onProgress:(nullable TCHMediaOnProgress)onProgress
                      onCompleted:(nullable TCHMediaOnCompleted)onCompleted
                         onFailed:(nullable TCHMediaOnFailed)onFailed NS_SWIFT_NAME(init(onStarted:onProgress:onCompleted:onFailed:));

@end

/** The builder of a message to send later in a conversation. */
__attribute__((visibility("default")))
NS_SWIFT_NAME(MessageBuilder)
@interface TCHMessageBuilder : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/** Set the new message body.

 @param body The body for the new message.
 @return Self for chaining.
 */
- (instancetype)setBody:(nullable NSString *)body NS_SWIFT_NAME(setBody(_:));

/** Set the new message subject.

 The subject is a part of the message which will be sent to email participants
 of the conversation (if any) as subject field of an email.

 If there is no email participants in the conversation - other chat participants will receive this
 field as a part of the message anyway.

 @param subject The subject of the message.
 @return Self for chaining.
 */
- (instancetype)setSubject:(nullable NSString *)subject NS_SWIFT_NAME(setSubject(_:));

/** Sets user defined attributes for the new message.

 @param attributes The new developer-defined extensible attributes for this message. (Supported types are NSString, NSNumber, NSArray, NSDictionary and NSNull)
 @param error An error which will indicate the failure of setting the attributes.
 @return A reference to this options object for convenience in chaining or nil in the event the attributes could not be parsed/updated.
 */
- (instancetype)setAttributes:(nullable TCHJsonAttributes *)attributes
                        error:(TCHError * _Nullable * _Nullable)error NS_SWIFT_NAME(setAttributes(_:error:));

/** Defines the message as a templated one. This method uses default variables.

 Use [setContentTemplateWithSid:contentVariables:] to specify custom values of variables.

 The message will ignore all data provided as a body, subject, and/or media.

 @param contentTemplateSid The content template sid. For all available sids take a look at [TwilioConversationsClient getContentTemplatesWithCompletion:]
 @return Self for chaining.
 */
- (instancetype)setContentTemplateWithSid:(nullable NSString *)contentTemplateSid NS_SWIFT_NAME(setContentTemplate(sid:));

/** Defines the message as a templated one. This method uses default variables.

 The message will ignore all data provided as a body, subject, and/or media.

 @param contentTemplateSid The content template sid. For all available sids take a look at [TwilioConversationsClient getContentTemplatesWithCompletion:]
 @param contentTemplateVariables The array of variables to replace the default values in the template. The content template sid must be set for a non-empty array of variables.
 @return Self for chaining.
 */
- (instancetype)setContentTemplateWithSid:(nullable NSString *)contentTemplateSid
                 contentTemplateVariables:(NSArray<TCHContentTemplateVariable *> *)contentTemplateVariables NS_SWIFT_NAME(setContentTemplate(sid:contentTemplateVariables:));

/** Adds the media attachment for the the new message.

 @param inputStream The content of the attachment.
 @param contentType The type of the attachment.
 @return Self for chaining.
 */
- (instancetype)addMediaWithInputStream:(NSInputStream *)inputStream
                            contentType:(NSString *)contentType NS_SWIFT_NAME(addMedia(inputStream:contentType:));

/** Adds the media attachment for the the new message.

 @param inputStream The content of the attachment.
 @param contentType The type of the attachment.
 @param filename The name of the attachment.
 @return Self for chaining.
 */
- (instancetype)addMediaWithInputStream:(NSInputStream *)inputStream
                            contentType:(NSString *)contentType
                               filename:(nullable NSString *)filename NS_SWIFT_NAME(addMedia(inputStream:contentType:filename:));

/** Adds the media attachment for the the new message.

 @param inputStream The content of the attachment.
 @param contentType The type of the attachment.
 @param filename The name of the attachment.
 @param listener The listener for monitoring the upload process.
 @return Self for chaining.
 */
- (instancetype)addMediaWithInputStream:(NSInputStream *)inputStream
                            contentType:(NSString *)contentType
                               filename:(nullable NSString *)filename
                               listener:(nullable TCHMediaMessageListener *)listener NS_SWIFT_NAME(addMedia(inputStream:contentType:filename:listener:));

/** Adds the media attachment for the the new message.

 @param mediaData The data of attachment.
 @param contentType The type of the attachment.
 @return Self for chaining.
 */
- (instancetype)addMediaWithData:(NSData *)mediaData
                     contentType:(NSString *)contentType NS_SWIFT_NAME(addMedia(data:contentType:));

/** Adds the media attachment for the the new message.

 @param mediaData The data of attachment.
 @param contentType The type of the attachment.
 @param filename The name of the attachment.
 @return Self for chaining.
 */
- (instancetype)addMediaWithData:(NSData *)mediaData
                     contentType:(NSString *)contentType
                        filename:(nullable NSString *)filename NS_SWIFT_NAME(addMedia(data:contentType:filename:));

/** Adds the media attachment for the the new message.

 @param mediaData The data of attachment.
 @param contentType The type of the attachment.
 @param filename The name of the attachment.
 @param listener The listener for monitoring the upload process.
 @return Self for chaining.
 */
- (instancetype)addMediaWithData:(NSData *)mediaData
                     contentType:(NSString *)contentType
                        filename:(nullable NSString *)filename
                        listener:(nullable TCHMediaMessageListener *)listener NS_SWIFT_NAME(addMedia(data:contentType:filename:listener:));

/** Set the new email body for the new message.

 This email body will be sent to email participants of the conversation.

 @param emailBody The content of the email body.
 @param contentType The type of the email body [TCHConversationLimits emailBodiesAllowedContentTypes].
 @return Self for chaining.
 */
- (instancetype)setEmailBody:(nullable NSString *)emailBody
                 contentType:(NSString *)contentType NS_SWIFT_NAME(setEmailBody(_:contentType:));

/** Set the new email body for the new message.

 This email body will be sent to email participants of the conversation.

 @param emailBody The content of the email body.
 @param contentType The type of the email body [TCHConversationLimits emailBodiesAllowedContentTypes].
 @param listener The listener of the uploading status of the email body.
 @return Self for chaining.
 */
- (instancetype)setEmailBody:(nullable NSString *)emailBody
                 contentType:(NSString *)contentType
                    listener:(nullable TCHMediaMessageListener *)listener NS_SWIFT_NAME(setEmailBody(_:contentType:listener:));

/** Set the new email body for the new message.

 This body will be sent to email participants of the conversation.

 @param inputStream The input stream of a data containing the email body.
 @param contentType The type of the email body [TCHConversationLimits emailBodiesAllowedContentTypes].
 @return Self for chaining.
 */
- (instancetype)setEmailBodyWithInputStream:(nullable NSInputStream *)inputStream
                                contentType:(NSString *)contentType NS_SWIFT_NAME(setEmailBody(inputStream:contentType:));

/** Set the new email body for the new message.

 This body will be sent to email participants of the conversation.

 @param inputStream The input stream of a data containing the email body.
 @param contentType The type of the email body [TCHConversationLimits emailBodiesAllowedContentTypes].
 @param listener The listener of uploading status of the email body.
 @return Self for chaining.
 */
- (instancetype)setEmailBodyWithInputStream:(nullable NSInputStream *)inputStream
                                contentType:(NSString *)contentType
                                   listener:(nullable TCHMediaMessageListener *)listener NS_SWIFT_NAME(setEmailBody(inputStream:contentType:listener:));

/** Set the new email history for the new message.

 This email history will be sent to email participants of the conversation.

 @param emailHistory The content of the email history.
 @param contentType The type of the email history [TCHConversationLimits emailHistoriesAllowedContentTypes].
 @return Self for chaining.
 */
- (instancetype)setEmailHistory:(nullable NSString *)emailHistory
                    contentType:(NSString *)contentType NS_SWIFT_NAME(setEmailHistory(_:contentType:));

/** Set the new email history for the new message.

 This email history will be sent to email participants of the conversation.

 @param emailHistory The content of the email history.
 @param contentType The type of the email history [TCHConversationLimits emailHistoriesAllowedContentTypes].
 @param listener The listener of the uploading status of the email history.
 @return Self for chaining.
 */
- (instancetype)setEmailHistory:(nullable NSString *)emailHistory
                    contentType:(NSString *)contentType
                       listener:(nullable TCHMediaMessageListener *)listener NS_SWIFT_NAME(setEmailHistory(_:contentType:listener:));

/** Set the new email history for the new message.

 This email history will be sent to email participants of the conversation.

 @param inputStream The input stream of a data containing the email history.
 @param contentType The type of the email history [TCHConversationLimits emailHistoriesAllowedContentTypes].
 @return Self for chaining.
 */
- (instancetype)setEmailHistoryWithInputStream:(nullable NSInputStream *)inputStream
                                   contentType:(NSString *)contentType NS_SWIFT_NAME(setEmailHistory(inputStream:contentType:));

/** Set the new email history for the new message.

 This email history will be sent to email participants of the conversation.

 @param inputStream The input stream of a data containing the email history.
 @param contentType The type of the email history [TCHConversationLimits emailHistoriesAllowedContentTypes].
 @param listener The listener of the uploading status of the email history.
 @return Self for chaining.
 */
- (instancetype)setEmailHistoryWithInputStream:(nullable NSInputStream *)inputStream
                                   contentType:(NSString *)contentType
                                      listener:(nullable TCHMediaMessageListener *)listener NS_SWIFT_NAME(setEmailHistory(inputStream:contentType:listener:));

/** Builds the new TCHUnsentMessage with which you can send the message later.

 @return The message which is ready to send.
 */
- (TCHUnsentMessage *)build;

/** Builds new TCHUnsentMessage and sends it immediately.

 @param completion The completion to report the result of the operation that receives sent TCHMessage object.
 */
- (TCHCancellationToken *)buildAndSendWithCompletion:(nullable TCHMessageCompletion)completion NS_SWIFT_NAME(buildAndSend(completion:));

@end

NS_ASSUME_NONNULL_END

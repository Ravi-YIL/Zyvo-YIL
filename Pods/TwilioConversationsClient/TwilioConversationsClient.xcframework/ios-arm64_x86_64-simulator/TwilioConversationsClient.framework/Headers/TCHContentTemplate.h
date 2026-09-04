//
//  TCHContentDataTypes.h
//  TwilioConversationsClient
//
//  Created by Ilia Kolo on 24.03.2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TCHContentDataRaw;
@class TCHContentTemplateVariable;

#pragma mark - Template

/** The content template.

 Use [TwilioConversationsClient getContentTemplatesWithCompletion:] to request all content templates for the current account.
 */
@interface TCHContentTemplate : NSObject

/// The server-assigned unique identifier for TCHContentTemplate.
@property (nonatomic, readonly, copy) NSString *sid;
/// The friendly name used to describe the content template. Not visible to the recipient.
@property (nonatomic, readonly, copy) NSString *friendlyName;
/// The timestamp when this template was created.
@property (nonatomic, readonly, copy) NSDate *dateCreated;
/// The timestamp when this template was last time updated.
@property (nonatomic, readonly, copy) NSDate *dateUpdated;
/// Template variables are being used for filling default placeholder values with desired values for variables included in content.
@property (nonatomic, readonly, copy) NSArray<TCHContentTemplateVariable *> *variables;
/** Variants of the content. See [TCHContentDataType] for available options.

    The most richest content type supported by a recipient will be sent.
 */
@property (nonatomic, readonly, copy) NSArray<NSObject<TCHContentDataRaw> *> *variants;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The content template variable. See [TCHContentTemplate.variables].
@interface TCHContentTemplateVariable : NSObject

/// The name of the template variable.
@property (nonatomic, readonly, copy) NSString *name;
/// The value of the template variable, by default filled with default data.
@property (nonatomic, readonly, copy) NSString *value;

/** Create a new instance of a content variable.

 @param name The name of the template variable.
 @param value The value of the template variable.
 @returns The new instance of the template variable.
 */
- (instancetype)initWithName:(NSString *)name value:(NSString *)value;
/** Copy the current template saving the name of the content variable with new value.

 @param value The value of the template variable.
 @returns The new instance of the template variable.
*/
- (instancetype)copyWithValue:(NSString *)value;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The type of the content template variant.
typedef NS_ENUM(NSUInteger, TCHContentDataType) {
    TCHContentDataTypeCallToAction = 0, ///< The type of the content template variant is [TCHContentDataCallToAction].
    TCHContentDataTypeCard = 1,         ///< The type of the content template variant is [TCHContentDataCard].
    TCHContentDataTypeListPicker = 2,   ///< The type of the content template variant is [TCHContentDataListPicker].
    TCHContentDataTypeLocation = 3,     ///< The type of the content template variant is [TCHContentDataLocation].
    TCHContentDataTypeMedia = 4,        ///< The type of the content template variant is [TCHContentDataMedia].
    TCHContentDataTypeQuickReply = 5,   ///< The type of the content template variant is [TCHContentDataQuickReply].
    TCHContentDataTypeText = 6,         ///< The type of the content template variant is [TCHContentDataText].
    TCHContentDataTypeOther = 7,        ///< The type of the content template variant is [TCHContentDataOther], raw data is present only.
};

/// The basic representation of the content data.
@protocol TCHContentDataRaw

/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The type of the content template variant.
@property (nonatomic, readonly) enum TCHContentDataType type;

@end

#pragma mark - CallToAction

@protocol TCHContentDataActionProtocol;

/** The template variant which defines buttons for actions

 Buttons let recipients tap to trigger actions such as launching a website or making a phone call.

 Represents the `twilio/call-to-action` content type.
 */
@interface TCHContentDataCallToAction : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeCallToAction].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The text of the message you want to send. This is included as a regular text message.
@property (nonatomic, readonly, copy) NSString *body;
/// Buttons that recipients can tap on to act with the message.
@property (nonatomic, readonly, copy) NSArray<NSObject<TCHContentDataActionProtocol> *> *actions;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The type of the action variant.
typedef NS_ENUM(NSUInteger, TCHContentDataActionType) {
    TCHContentDataActionTypeUrl = 0,    ///< The type of the action variant is [TCHContentDataActionUrl].
    TCHContentDataActionTypePhone = 1,  ///< The type of the action variant is [TCHContentDataActionPhone].
    TCHContentDataActionTypeReply = 2,  ///< The type of the action variant is [TCHContentDataActionReply].
    TCHContentDataActionTypeOther = 3,  ///< The type of the action variant is [TCHContentDataActionOther].
};

/// The basic representation of the action
@protocol TCHContentDataActionProtocol

/// The type of the action variant, one of [TCHContentDataActionType].
@property (nonatomic, readonly) enum TCHContentDataActionType type;

@end

/// The action type that being used for unknown action types, which aren't present in the current version of Conversations SDK.
@interface TCHContentDataActionOther : NSObject <TCHContentDataActionProtocol>

/// The [TCHContentDataActionTypeOther] type of the action variant.
@property (nonatomic, readonly) enum TCHContentDataActionType type;
/// The data of the action as a stringified JSON not represented by the current Conversations SDK.
@property (nonatomic, readonly, copy) NSString *rawData;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The action that shows a button which calls a phone number.
@interface TCHContentDataActionPhone : NSObject <TCHContentDataActionProtocol>

/// The [TCHContentDataActionTypePhone] type of the action variant.
@property (nonatomic, readonly) enum TCHContentDataActionType type;
/// The title of the button of the action.
@property (nonatomic, readonly, copy) NSString *title;
/// The phone number to call when the recipient taps the button.
@property (nonatomic, readonly, copy) NSString *phone;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The action that shows a button which sends back a predefined text.
@interface TCHContentDataActionReply : NSObject <TCHContentDataActionProtocol>

/// The [TCHContentDataActionTypeReply] type of the action variant.
@property (nonatomic, readonly) enum TCHContentDataActionType type;
/// The title for the action. This is the message that will be sent back when the user taps on the button.
@property (nonatomic, readonly, copy) NSString *title;
/// The postback payload. This field is not visible to the end user.
@property (nonatomic, readonly, copy) NSString * _Nullable id;
/// The index for the action.
@property (nonatomic, readonly) NSInteger index;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The action that shows a button which redirects a recipient to a predefined URL.
@interface TCHContentDataActionUrl : NSObject <TCHContentDataActionProtocol>

/// The [TCHContentDataActionTypeUrl] type of the action variant.
@property (nonatomic, readonly) enum TCHContentDataActionType type;
/// The title for the action.
@property (nonatomic, readonly, copy) NSString *title;
/// The url to redirect to when the recipient taps the button.
@property (nonatomic, readonly, copy) NSString *url;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Card

/// The action which includes a menu of up to 10 options, which offers a simple way for users to make a selection.  Represents the `twilio/card` content type.
@interface TCHContentDataCard : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeCard].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The title of the card.
@property (nonatomic, readonly, copy) NSString *title;
/// The subtitle of the card.
@property (nonatomic, readonly, copy) NSString * _Nullable subtitle;
/// URLs of media to send with the message.
@property (nonatomic, readonly, copy) NSArray<NSString *> * _Nullable media;
/// The array of actions that represent buttons on which recipients can tap on to act on the message.
@property (nonatomic, readonly, copy) NSArray<NSObject<TCHContentDataActionProtocol> *> * _Nullable actions;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - ListPicker

@class TCHContentDataListItem;

/** The template to provide a way to make a simple reaction

 The action which includes a menu of up to 10 options, which offers a simple way for users to make a selection.

 Represents the `twilio/list-picker` content type.
 */
@interface TCHContentDataListPicker : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeListPicker].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The text of the message you want to send. This is rendered as the body of the message.
@property (nonatomic, readonly, copy) NSString *body;
/// The title of the primary button.
@property (nonatomic, readonly, copy) NSString *button;
/// The array of items displayed in the list. See [TCHContentDataListItem].
@property (nonatomic, readonly, copy) NSArray<TCHContentDataListItem *> *items;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The item in the list of the list picker content template variant. See [TCHContentDataListPicker].
@interface TCHContentDataListItem : NSObject

/// The unique item identifier. Not visible to the recipient.
@property (nonatomic, readonly, copy) NSString *id;
/// The display value for the item.
@property (nonatomic, readonly, copy) NSString *item;
/// The description of the item.
@property (nonatomic, readonly, copy) NSString * _Nullable itemDescription;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Location

/** The template which contains a location pin and an optional label.

 This action can be used to enhance delivery notification or connect recipients to physical experiences you offer.

 Represents the `twilio/location` content type.
 */
@interface TCHContentDataLocation : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeLocation].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The longitude value of the location pin you want to send.
@property (nonatomic, readonly) double longitude;
/// The latitude value of the location pin you want to send.
@property (nonatomic, readonly) double latitude;
/// The optional label to be displayed to the recipient alongside the location pin.
@property (nonatomic, readonly, copy) NSString * _Nullable label;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Media

/** The template variant which sends file attachments.

 Used to send file attachments, or to send a long text via MMS in the US and Canada.

 Represents the `twilio/media` content type.
 */
@interface TCHContentDataMedia : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeMedia].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The text of the message you want to send. This is included as a regular text message.
@property (nonatomic, readonly, copy) NSString * _Nullable body;
/// URLs of media to send with the message.
@property (nonatomic, readonly, copy) NSArray<NSString *> *media;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Other
/** The template variant not represented by a class.

 Used for unknown action types, which aren't present in the current version of Conversations SDK.
 */
@interface TCHContentDataOther : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeOther].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

@class TCHContentDataReply;

#pragma mark - QuickReply

/** The template to provide a way to make a simple response.

 The template lets recipients tap, rather than type, to respond to the message.

 Represents the `twilio/quick-reply` content type.
 */
@interface TCHContentDataQuickReply : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeQuickReply].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The text of the message you want to send. This is included as a regular text message.
@property (nonatomic, readonly, copy) NSString *body;
/// The array of up to 3 buttons to make a response. See [TCHContentDataReply].
@property (nonatomic, readonly, copy) NSArray<TCHContentDataReply *> *replies;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

/// The reply which is being represented by a button that sends back a predefined text. See [TCHContentDataQuickReply.replies]
@interface TCHContentDataReply : NSObject

/// The title for the action. This is the message that will be sent back when the user taps on the button.
@property (nonatomic, readonly, copy) NSString * title;
/// The postback payload. This field is not visible to the end user.
@property (nonatomic, readonly, copy) NSString * _Nullable id;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

#pragma mark - Text

/** The template to provide a way to send a predefined text.

 Represents the `twilio/text` content type.
 */
@interface TCHContentDataText : NSObject <TCHContentDataRaw>

/// The type of the content template variant, which is [TCHContentDataTypeText].
@property (nonatomic, readonly) enum TCHContentDataType type;
/** The full data of the content data as a stringified JSON.

 Can be used for new content types and fields which are not yet supported in the current version of Conversations SDK.
 */
@property (nonatomic, readonly, copy) NSString *rawData;
/// The text of the message you want to send. This is included as a regular text message.
@property (nonatomic, readonly, copy) NSString *body;

- (nonnull instancetype)init NS_UNAVAILABLE;
+ (nonnull instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

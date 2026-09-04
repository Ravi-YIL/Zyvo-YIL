//
//  EndPoints.swift
//  RPG
//
//  Created by YATIN  KALRA on 12/02/24.
//

import Foundation

extension Notification.Name {
    static let locationDidUpdate = Notification.Name("locationDidUpdate")
}

struct AppKeys {
    static let  googleAPi = "AIzaSyC9NuN_f-wESHh3kihTvpbvdrmKlTQurxw"
    static let googleMapAPI = "AIzaSyBh1m5LWl-qV1nVkT1WZeWAzng5eP42RNk"
}
struct AppLocation {
    static var  lat = ""
    static var  long = ""
    static var  Address = ""
    static var  city = ""
    static var  state = ""
    static var  zip = ""
}
struct AppURL {
    
    static let baseURL = "https://zyvo.tgastaging.com/api/"
    static let imageURL = "https://zyvo.tgastaging.com/"
}

extension AppURL {
    
    enum Endpoint: String {
        
        
        case guestcancelbooking                  =          "guest_cancel_booking"
        case usersignupphone                  =          "signup_phone_number"
        case otpverifysignupphone             =          "otp_verify_signup_phone"
        case otp_verify_login_phone             =          "otp_verify_login_phone"
        case otp_verify_signup_email             =          "otp_verify_signup_email"
        
        case loginByPhone                     =          "login_phone_number"
        
        case loginByEmail                     =          "login_email"
        
        
        case updatepassword          =          "update_password"
        
        case get_notification_guest          =          "get_notification_guest"
        
        //        case mark_notification_read          =          "mark_notification_read"
        
        case otp_verify_forgot_password          =          "otp_verify_forgot_password"
        case signupemail          =          "signup_email"
        
        
        
        case forgetpassword          =          "forgot_password"
        
        case update_name          =          "add_update_name"
        
        case gethelpcenter          =          "get_help_center"
        
        case getAllArticle          =          "get_article_list"
        
        case getguidedetails          =          "get_guide_details"
        
        case get_booking_list          =          "get_booking_list"
        
        case bookproperty          =          "book_property"
        
        case getusercards          =          "get_user_cards"
        
        case getarticledetails          =          "get_article_details"
        
        case cancel_booking          =          "cancel_booking"
        
        case getAllGuides         =          "get_guide_list"
        
        
        case emailverification                  =          "email_verification"
        case phoneverification                  =          "phone_verification"
        
        case updatephonenumber                  =          "update_phone_number"
        
        case updateemail                  =          "update_email"
        
        case otpverifyemailverification         =          "otp_verify_email_verification"
        
        case otp_verify_phone_verification         =          "otp_verify_phone_verification"
        
        case otp_verify_update_phone         =          "otp_verify_update_phone"
        
        case otp_verify_update_email         =          "otp_verify_update_email"
        
        
        
        case getProfile                  =          "get_user_profile"
        case addmywork                  =          "add_my_work"
        case addaboutme                  =          "add_about_me"
        case add_street_address                  =          "add_street_address"
        case add_city                  =          "add_city"
        case add_state                  =          "add_state"
        case add_zip_code                  =          "add_zip_code"
        case create_wishlist                  =          "create_wishlist"
        
        case report_violation                  =          "report_violation"
        
        case report_chat                  =          "report_chat"
        
        case same_as_mailing_address                  =          "same_as_mailing_address"
        case reviewhost                  =          "review_host"
        case AddCard                      =  "save_card_stripe"
        
        case setPreferredCard                      =  "set_preferred_card"
        case deleteCardStripe                     =  "delete_card_stripe"
        case get_booking_details_list        =          "get_booking_details_list"
        case contactus                  =          "contact_us"
        
        case joinchannel                  =          "join_channel"
        
        case set_home_data_filter                  =          "get_home_data_filter"
        
        case get_wishlist                  =          "get_wishlist"
        
        case delete_wishlist                  =          "delete_wishlist"
        case get_saved_item_wishlist                  =          "get_saved_item_wishlist"
        case save_item_in_wishlist                  =          "save_item_in_wishlist"
        
        
        case get_home_property_details     =          "get_home_property_details"
        
        case get_booking_extension_time_amount     =          "get_booking_extension_time_amount"
        
        case remove_item_from_wishlist     =          "remove_item_from_wishlist"
        
        case filter_property_reviews     =          "filter_property_reviews"
        
        case filter_host_reviews     =          "filter_host_reviews"
        
        case check_host_property_availability     =          "check_host_property_availability"
        
        
        
        case deletemywork                  =          "delete_my_work"
        case deleteliveplace                  =          "delete_live_place"
        case deletehobby                  =          "delete_hobby"
        case deletepet                  =          "delete_pet"
        case completeprofile               =          "complete_profile"
        case upload_profile_image               =          "upload_profile_image"
        
        case login                       =          "login"
        case addliveplace                       =          "add_live_place"
        case addhobby                       =          "add_hobby"
        case addpet                       =          "add_pet"
        case addlanguage                       =          "add_language"
        case deletelanguage                       =          "delete_language"
        case verifyIdentity                       =          "verify_identity"
        
        
        case usertermsconditions         =          "user_terms_conditions"
        
        case getfaq         =          "get_faq"
        
        case Guestprivacypolicy           =          "get_privacy_policy"
        
        
        case get_property_price_range           =          "get_property_price_range"
        
        
        case get_term_condition           =          "get_term_condition"
        case gethomedata           =          "get_home_data"
        case chattoken           =          "chat_token"
        
        case block_user           =          "block_user"
        
        case mark_favorite_chat           =          "mark_favorite_chat"
        
        case mute_chat           =          "mute_chat"
        
        case toggle_archive_unarchive           =          "toggle_archive_unarchive"
        
        case send_chat_notification           =          "send_chat_notification"
        
        case delete_chat           =          "delete_chat"
        
        
        case get_user_channels           =          "get_user_channels"
        case getuserbookings           =          "get_user_bookings"
        case userabout                   =          "user_about"
        case getallfaqs                  =          "get_all_faqs"
        case savemyshippinginfo          =          "update_my_shipping_info"
        case usermyshippinginfo          =          "user_my_shipping_info"
        case getmyshippinginfo           =          "get_my_shipping_info"
        case shippingtogglestatus        =          "shipping_toggle_status"
        case createmyregistry            =          "create_my_registry"
        case getcategorylist             =          "get-category-list"
        
        case getFriendData                 =        "get-all-home-friend-data"
        case getmyallfriends             =          "get-my-all-friends"
        case removefriend                =          "remove_friend"
        case searchfriend                =          "search-friend"
        case sendfriendrequest           =          "send-friend-request"
        case usergetallfriendrequest     =         "user_get_all_friend_request"
        case getallmyfriendsregistry     =         "get-all-my-friends-registry"
        case usermyregistrylist          =         "user_my_registry_list"
        case sendregistryrequest         =         "send-registry-request"
        
        case acceptrejectfriendrequest   =         "accept-reject-friend-request"
        
        case acceptrejectregistryrequest =         "accept-reject-registry-request"
        
        case notifications               =         "notifications"
        
        case usermyregistrydetaillist    =         "user_my_registry_detail_list"
        
        case getmyfriendsregistryshippingdetails    =         "get-my-friends-registry-shipping-details"
        
        case shareregistry               =         "share-registry"
        
        case shareregistrywithallfriends =         "share_registry_with_all_friends"
        
        case onlinegiftlist              =         "online-gift-list"
        
        case onlinegiftlistedit              =         "online-gift-list_edit"
        
        
        
        case offlinegiftlist             =         "offline-gift-list"
        
        case offlinegiftlistedit             =         "offline-gift-list_edit"
        
        case user_contact_us_form        =         "user_contact_us_form"
        
        case user_delete_account         =         "user_delete_account"
        
        case unshareregistry             =         "unshare-registry"
        
        case userregistrylistdata        =         "user-registry-list-data"
        
        case get_all_my_friend_registry        =         "get_all_my_friend_registry"
        
        case get_friends_registry_on_calender_date        =         "get_friends_registry_on_calender_date"
        
        
        case user_forget_otp_verify        =         "user_forget_otp_verify"
        
        case logout                        =         "logout"
        
        case updateNotificationStatus      =         "notification_status"
        
        case deleteregistry                =         "delete-registry"
        
        case registrygiftlistdelete        =         "registry-gift-list-delete"
        
        case getnotificationstatus         =         "get_notification_status"
        
        case usersociallogin               =         "social_login"
        
        case changegiftstatus              =         "change-gift-status"
        
        case updategiftitems               =         "update-gift-items"
        
        case socialLogin                 =       "social-login"
        
        case signupOtpVerify             =       "Customer_Signup_otp_Verify"
        case sendOtp                     =       "Customer_Send_Otp"
        case CustomerForgotPassword      =       "Customer_Forgot_Password"
        case CustomerForgetOtpVerify     =       "Customer_Otp_Verify"
        case CustomerResetPassword       =       "Customer_Reset_Password"
        
        case CstmerVerifySendOtp         =       "Customer_Verify_SendOtp"
        case CustmerProfileOtpVerify     =       "Customer_Profile_Otp_Verify"
        
        case homeScreen                  =       "home_screen"
        
        case hostlisting                  =       "host_listing"
        
        case GetCategorySubcategory      =       "Get_Category_Subcategory"
        
        //MARK:- Host APi ENDPOINTS
        case store_property_details = "store_property_details"
        case get_properties_lists = "get_properties_lists"
        case delete_property = "delete_property"
        case get_property_details = "get_property_details"
        case property_image_delete = "property_image_delete"
        case update_property_details = "update_property_details"
        case earnings = "earnings"
        case get_host_booking_list = "get_host_booking_list"
        case mark_host_bookings = "mark_host_bookings"
        
        
        case approve_decline_booking = "approve_decline_booking"
        case host_booking_details = "host_booking_details"
        //        case filter_property_reviews = "filter_property_reviews"
        case review_guest = "review_guest"
        case host_report_violation = "host_report_violation"
        case list_report_reasons = "list_report_reasons"
        case property_booking_details = "property_booking_details"
        case get_notification_host = "get_notification_host"
        case mark_notification_read = "mark_notification_read"
        case payment_withdrawal_list = "payment_withdrawal_list"
        case payout_balance = "payout_balance"
        case get_countries = "get_countries"
        case get_states = "get_states"
        case get_cities = "get_cities"
        case add_payout_bank = "add_payout_bank"
        case add_payout_card = "add_payout_card"
        case get_payout_methods = "get_payout_methods"
        case set_primary_payout_method = "set_primary_payout_method"
        case delete_payout_method = "delete_payout_method"
        case withdraw_funds = "withdraw_funds"
        case request_withdrawal = "request_withdrawal"
        case host_unread_bookings = "host_unread_bookings"
        case toggle_property_booking = "toggle_property_booking"
        case feedback = "feedback"
        
        case checkBlockStatus = "get_user_channels_status"
        
        
        var path : String {
            let url = AppURL.baseURL
            return url + self.rawValue
        }
    }
}

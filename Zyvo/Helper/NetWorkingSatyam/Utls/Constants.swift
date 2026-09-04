//
//  Constant.swift
//  My Meeting Card
//
//  Created by pranjali kashyap on 04/03/22.
//


import UIKit

class UserDetail: NSObject {
    
static let shared = UserDetail()
    private override init() { }
    
    func setUserId(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.userid.rawValue)
        print(sUserId)
    }
    func getUserId() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.userid.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    func setScreenId(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.screenid.rawValue)
        print(sUserId)
    }
    func getScreenId() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.screenid.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeUserId() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.userid.rawValue)
    }
    //
    
    func setUserType(_ sUserType:String) -> Void {
        UserDefaults.standard.set(sUserType, forKey: UserKeys.UserType.rawValue)
        print(sUserType)
    }
    func getUserType() -> String {
        if let UserType = UserDefaults.standard.value(forKey: UserKeys.UserType.rawValue) as? String
        {
            return UserType
        }
        return ""
    }
    func removeUserType() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.UserType.rawValue)
    }
    
    func setLocationStatus(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.LocationStatus.rawValue)
        print(sUserId)
    }
    
    func setTimeZone(_ sTimeZone:String) -> Void {
        UserDefaults.standard.set(sTimeZone, forKey: UserKeys.TimeZone.rawValue)
        print(sTimeZone)
    }
    
    func getLocationStatus() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.LocationStatus.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func setNotiStatus(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.NotiStatus.rawValue)
        print(sUserId)
    }
    func getNotiStatus() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.NotiStatus.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    
    
    func removeLocationStatus() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.LocationStatus.rawValue)
    }
  
        func setName(_ sName: String) -> Void {
            UserDefaults.standard.set(sName, forKey: UserKeys.name.rawValue)
        }
        
        func getName() -> String{
            if let name = UserDefaults.standard.value(forKey: UserKeys.name.rawValue) as? String
            {
                return name
            }
            return ""
        }
    
    func removeName() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.name.rawValue)
    }
    
    func setLoginTime(_ sName: String) -> Void {
        UserDefaults.standard.set(sName, forKey: UserKeys.logintime.rawValue)
    }
    
    func getLoginTime() -> String{
        if let name = UserDefaults.standard.value(forKey: UserKeys.logintime.rawValue) as? String
        {
            return name
        }
        return ""
    }
    
    func removeLogintime() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.logintime.rawValue)
    }
    
    func setProfileimg(_ sName: String) -> Void {
        UserDefaults.standard.set(sName, forKey: UserKeys.profileimg.rawValue)
    }
    
    func getProfileimg() -> String{
        if let name = UserDefaults.standard.value(forKey: UserKeys.profileimg.rawValue) as? String
        {
            return name
        }
        return ""
    }
    
    func removeProfileimg() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.profileimg.rawValue)
    }
    
        func setEmailId(_ email: String) -> Void{
            UserDefaults.standard.set(email, forKey: UserKeys.emailId.rawValue)
        }
        
        func getEmailId() -> String{
            if let emailId = UserDefaults.standard.value(forKey: UserKeys.emailId.rawValue) as? String
            {
                return emailId
            }
            return ""
        }
        
        func setphoneNo(_ phone: String) -> Void{
            UserDefaults.standard.set(phone, forKey: UserKeys.phoneNo.rawValue)
        }
        
        func getPhoneNo() -> String{
            if let phoneNo = UserDefaults.standard.value(forKey: UserKeys.phoneNo.rawValue) as? String
            {
               return phoneNo
            }
            return ""
        }
    
    func getTimeZone() -> String{
        if let timeZone = UserDefaults.standard.value(forKey: UserKeys.TimeZone.rawValue) as? String
        {
           return timeZone
        }
        return ""
    }
    //
    func setTokenWith(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.Token.rawValue)
        print(sUserId)
    }
    func getTokenWith() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.Token.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeTokenWith() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.Token.rawValue)
    }
    
    //
    func setisCompleteProfile(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.isprofilecomplete.rawValue)
        print(sUserId)
    }
    func getisCompleteProfile() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.isprofilecomplete.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeisCompleteProfile() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.isprofilecomplete.rawValue)
    }
    
    func setAppLatitude(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.latitude.rawValue)
        print(sUserId)
    }
    func getAppLatitude() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.latitude.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeAppLatitude() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.latitude.rawValue)
    }
    
    func setAppLongitude(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.longitude.rawValue)
        print(sUserId)
    }
    func getAppLongitude() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.longitude.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeAppLongitude() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.longitude.rawValue)
    }
    
    func setKeepMeLogin(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.KeepMeLogin.rawValue)
        print(sUserId)
    }
    func getKeepMeLogin() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.KeepMeLogin.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeKeepMeLogin() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.KeepMeLogin.rawValue)
    }
    
    func setChatToken(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.chatToken.rawValue)
        print(sUserId)
    }
    func getChatToken() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.chatToken.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeChatToken() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.chatToken.rawValue)
    }
    
    func setisTimeExtend(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.isTimeExtend.rawValue)
        print(sUserId)
    }
    func getisTimeExtend() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.isTimeExtend.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeisTimeExtend() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.isTimeExtend.rawValue)
    }
    
    func setisNeedMoreOpenOnce(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.isNeedMoreOpenOnce.rawValue)
        print(sUserId)
    }
    func getisNeedMoreOpenOnce() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.isNeedMoreOpenOnce.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removeisNeedMoreOpenOnce() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.isNeedMoreOpenOnce.rawValue)
    }

    
    func setlogintType(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: UserKeys.LoginType.rawValue)
        print(sUserId)
    }
    func getlogintType() -> String {
        if let userId = UserDefaults.standard.value(forKey: UserKeys.LoginType.rawValue) as? String
        {
            return userId
        }
        return ""
    }
    
    func removelogintType() -> Void {
        UserDefaults.standard.removeObject(forKey: UserKeys.LoginType.rawValue)
    }

    func setDeviceLatitude(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: "device_latitude")
    }
    func getDeviceLatitude() -> String {
        if let userId = UserDefaults.standard.value(forKey: "device_latitude") as? String
        {
            return userId
        }
        return ""
    }
    func setDeviceLongitude(_ sUserId:String) -> Void {
        UserDefaults.standard.set(sUserId, forKey: "device_longitude")
    }
    func getDeviceLongitude() -> String {
        if let userId = UserDefaults.standard.value(forKey: "device_longitude") as? String
        {
            return userId
        }
        return ""
    }
}

enum UserKeys:String {
    case userid = "user_id"
    case logintime = "logintime"
    case screenid = "screenid"
    case UserType = "UserType"
    case LoginType = "LoginType"
    case name = "name"
    case emailId = "emailId"
    case phoneNo = "phoneNo"
    case Token = "Token"
    case LocationStatus = "LocationStatus"
    case TimeZone = "TimeZone"
    case NotiStatus = "NotiStatus"
    case profileimg = "profileimg"
    case latitude = "latitude"
    case longitude = "longitude"
    case KeepMeLogin = "KeepMeLogin"
    case chatToken = "chatToken"
    case isTimeExtend = "isTimeExtend"
    case isNeedMoreOpenOnce = "isNeedMoreOpenOnce"
    case isprofilecomplete = "is_profile_complete"
    
    
}
 

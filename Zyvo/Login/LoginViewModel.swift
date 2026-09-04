//
//  LoginViewModel.swift
//  Zyvo
//
//  Created by ravi on 22/01/25.
//

import Combine
import Foundation

class LoginViewModel {
    
    @Published var phone: String = ""
    @Published var countryCode: String = ""
    @Published var errorMessage: String?
    @Published var isloginValid: Bool = false
    @Published var loginResult:Result<BaseResponse<LoginModel>,Error>? = nil
    @Published var socialsignUpResult:Result<BaseResponse<SocialLoginModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    init() {
        setupValidation()
    }
    private func setupValidation() {
        Publishers.CombineLatest($phone, $countryCode)
            .map { phone, countryCode  in
                return self.validate(phone: phone, countryCode: countryCode)
            }
            .assign(to: \.isloginValid, on: self)
            .store(in: &cancellables)
    }
    private func validate(phone: String,countryCode: String) -> Bool {
        if phone.isEmpty {
            errorMessage = "Please enter your phone number"
            return false
        }
        if countryCode.isEmpty {
            errorMessage = "Country Code can't be empty."
            return false
        }
        if !phone.isValidPhone() {
            errorMessage = "Invalid Phone number"
            return false
        }
        errorMessage = nil
        return true
    }
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            errorMessage = "Please enter your email"
            return false
        } else if email.isNumeric {
            if !email.isValidPhone() {
                errorMessage = "Please enter a valid phone number."
                return false
            }
        } else if !email.isValidEmail() {
            errorMessage = "Please enter a valid email address."
            return false
        }
        errorMessage = "Please enter your password"
        return true
    }
}
extension LoginViewModel {
    func loginByPhoneApi(){
        var para : [String:Any] = [:]
        para[APIKeys.phonenumber] = self.phone
        para[APIKeys.countryCode] = self.countryCode
        para[APIKeys.device_type] = "ios"
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            print("FCM Token: \(fcmToken)")
            para[APIKeys.fcmToken] = "\(fcmToken)"
          
        } else {
            print("No FCM Token found")
        }
        
        
        APIServices<LoginModel>().post(endpoint: .loginByPhone, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.loginResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.loginResult = .success(response)
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }

    
    func apiforSocialLogin(fName:String,lName:String,Email:String,socialID:String){

         var para : [String:Any] = [:]
//        let delegate = AppDelegate.shared
//        let token = delegate.deviceToken

        // print(token,"TOKEN")
       // para["fcm_token"] = token
        para["device_type"] = "ios"
         para[APIKeys.email] = Email
         para[APIKeys.firstnameSocial] = fName
        para[APIKeys.lastnameSocial] = lName
         para[APIKeys.social_id] = socialID
        
        para[APIKeys.device_type] = "ios"
        
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            print("FCM Token: \(fcmToken)")
            para[APIKeys.fcmToken] = "\(fcmToken)"
          
        } else {
            print("No FCM Token found")
        }

         APIServices<SocialLoginModel>().post(endpoint: .usersociallogin, parameters: para)
             .receive(on: DispatchQueue.main)
             .sink { complition in
                 switch complition {

                 case .finished:
                     print("Request Completed")
                 case .failure(let error):
                     self.socialsignUpResult = .failure(error)
                     print("Error: \(error.localizedDescription)")
                 }

             } receiveValue: { response in
                 if response.success ?? false {
                     self.socialsignUpResult = .success(response)

                 }else{
                    // topViewController?.showAlert(for: response.message ?? "")
                     topViewController?.topmostViewController().showAlert(for: response.message ?? "")
                     //AlertControllerOnr(title: "Alert!", message: response.message ?? "")

                 }
             }.store(in: &cancellables)

     }
}


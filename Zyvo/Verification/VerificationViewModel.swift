//
//  VerificationViewModel.swift
//  Zyvo
//
//  Created by ravi on 21/01/25.
//

import Combine
import Foundation

class VerificationViewModel {
   
    @Published var otpCode: String = ""
    var userID : String = ""
    @Published var tempID: String = ""
    @Published var errorMessage: String?
    @Published var isOtpValid: Bool = false
    @Published var canResend: Bool = true
    @Published var timerText: String = "02:00"
    @Published var verifyResult:Result<BaseResponse<VerificationModel>,Error>? = nil
    
    
    @Published var verifyforgotPasswordResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var verifyforgetResult:Result<BaseResponse<[VerificationModel]>,Error>? = nil
   // @Published var sendOtpResult:Result<BaseResponse<ResndModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private var runCount = 60
    private var timer: Timer?
    
    var email = ""
    var comesFrom = ""
    var Otp = ""
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        $otpCode
            .map { $0.count == 4 }
            .assign(to: \.isOtpValid, on: self)
            .store(in: &cancellables)
    }
    
    func validateOtp() -> Bool {
        print(Otp,"Otp")
        print(otpCode,"otpCode")
        print(otpCode.count,"otpCode.count")
        if otpCode.count == 0 {
            print(otpCode)
            print(otpCode.count)
            errorMessage = "Please enter the verification code"
          topViewController?.AlertControllerOnr(title: "Alert!", message: errorMessage)
            return false
        }
      else  if otpCode.count != 4 {
            print(otpCode)
            print(otpCode.count)
            errorMessage = "Please enter the 4-digit code"
          topViewController?.AlertControllerOnr(title: "Alert!", message: errorMessage)
            return false
        }
//        else if otpCode != Otp {
//            errorMessage = "OTP is Incorrect!"
//            topViewController?.AlertControllerOnr(title: "Alert!", message: errorMessage)
//            return false
//        }
        return true
    }
    
    func updateOTPText(_ newText: String) {
        otpCode = newText
        
    }
    
    func startResendTimer() {
        canResend = false
        runCount = 60
        var time1 = 60
        timerText = "01:59"
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            self.runCount -= 1
            if self.runCount >= 10 {
                self.timerText = "01:\(String(self.runCount))"
            } else if self.runCount >= 0 {
                self.timerText = "01:0\(String(self.runCount))"
            }
            
            if self.runCount == 0 {
                
                timer.invalidate()
                self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                    time1 -= 1
                    if time1 <= 60 {
                        self.timerText = "00:\(String(time1))"
                    }
                    if time1 >= 10 {
                        self.timerText = "00:0\(String(time1))"
                    }
                    
                    if time1 == 1 {
                        
                        timer.invalidate()
                        self.canResend = true
                        self.timerText = "00:00"
                    }
                }
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension VerificationViewModel{
    func verifySignUpOtp(){
        var para = [String:Any]()
        para[APIKeys.tempID] = tempID
        para[APIKeys.Otp] = otpCode
        
        para[APIKeys.device_type] = "ios"
        
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            print("FCM Token: \(fcmToken)")
            para[APIKeys.fcmToken] = "\(fcmToken)"
          
        } else {
            print("No FCM Token found")
        }
        
        
        APIServices<VerificationModel>().post(endpoint: .otpverifysignupphone, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.verifyResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.verifyResult = .success(response)
                    
                }else{
                    
                    topViewController?.showAlert(for: "Incorrect verification code. Please try again!")
                    
                    //topViewController?.AlertControllerOnr(title: "Alert!", message: "Invalid OTP")
                    //topViewController?.showSnackAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    func apiforOtpVerifyLoginPhone(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = userID
        para[APIKeys.Otp] = otpCode
        
        para[APIKeys.device_type] = "ios"
        
        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
            print("FCM Token: \(fcmToken)")
            para[APIKeys.fcmToken] = "\(fcmToken)"
          
        } else {
            print("No FCM Token found")
        }
        APIServices<VerificationModel>().post(endpoint: .otp_verify_login_phone, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.verifyResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.verifyResult = .success(response)
                    
                }else{
                    
                    topViewController?.showAlert(for: "Incorrect verification code. Please try again!")
                  //  topViewController?.AlertControllerOnr(title: "Alert!", message: "Invalid OTP")
                    //topViewController?.showSnackAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    
    
    func apiforOtpVerifyEmailSignup(){
        var para = [String:Any]()
        
        para[APIKeys.tempID] = tempID
        para[APIKeys.Otp] = otpCode
        
        
//        para[APIKeys.device_type] = "ios"
//        
//        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
//            print("FCM Token: \(fcmToken)")
//            para[APIKeys.fcmToken] = "\(fcmToken)"
//          
//        } else {
//            print("No FCM Token found")
//        }
//        
        APIServices<VerificationModel>().post(endpoint: .otp_verify_signup_email, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.verifyResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.verifyResult = .success(response)
                    
                }else{
                    
                    topViewController?.showAlert(for: "Incorrect verification code. Please try again!")
                   // topViewController?.AlertControllerOnr(title: "Alert!", message: "Invalid OTP")
                    //topViewController?.showSnackAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
    
    func apiforOtpVerifyForgotPassword(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = userID
        para[APIKeys.Otp] = otpCode
        
        APIServices<EmptyModel>().post(endpoint: .otp_verify_forgot_password, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.verifyforgotPasswordResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.verifyforgotPasswordResult = .success(response)
                    
                }else{
                    
                    DispatchQueue.main.async {
                        topViewController?.AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                       // topViewController?.showAlert(for: response.message ?? "")
                    }
                   
                }
            }.store(in: &cancellables)
        
    }
    
}

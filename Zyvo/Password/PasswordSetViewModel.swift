//
//  PasswordSetViewModel.swift
//  Zyvo
//
//  Created by ravi on 22/01/25.
//

import Combine
import Foundation

class PasswordSetViewModel {
   // @Published var email: String = ""
    @Published var newPassword: String = ""
    @Published var confirmnewPassword: String = ""
    @Published var errorMessage: String?
    @Published var isResetPassword: Bool = false
    @Published var canResend: Bool = true
    @Published var timerText: String = "02:00"
    @Published var ResetPwdResult:Result<BaseResponse<SetPasswordModel>,Error>? = nil
   // @Published var sendOtpResult:Result<BaseResponse<ResndModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private var runCount = 60
    private var timer: Timer?
    var email = ""
    var comesFrom = ""
    var Otp = ""
    var userID = ""
    
    init() {
        setupValidation()
    }
    
    
    
    private func setupValidation() {
        Publishers.CombineLatest( $newPassword,$confirmnewPassword)
            .map {  newPassword,confirmnewPassword in
                return self.validate( newPassword: newPassword,confirmnewPassword: confirmnewPassword)
            }
            .assign(to: \.isResetPassword, on: self)
            .store(in: &cancellables)
    }
    
    
    private func validate( newPassword: String,confirmnewPassword: String) -> Bool {
        
        
        if newPassword.isEmpty {
            errorMessage = "Please enter your new password"
            return false
        }
        
        if !newPassword.isPasswordValid() {
            errorMessage = "Password must have at least one Uppercase, one Lowercase alphabet, one special character, and one numeric character."
            return false
        }
        if confirmnewPassword.isEmpty {
            errorMessage = "Please enter your confirm new password"
            return false
        }
        
        if !confirmnewPassword.isPasswordValid() {
            errorMessage = "Password must have at least one Uppercase, one Lowercase alphabet, one special character, and one numeric character."
            return false
        }
        
        errorMessage = nil
        return true
    }
  
}

extension PasswordSetViewModel{
    func apiforCreatePassword(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = userID
        para[APIKeys.password] = newPassword
        
        para[APIKeys.confirmPassword] = confirmnewPassword
       
        APIServices<SetPasswordModel>().postWithOutToken(endpoint: .updatepassword, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Data get Successuflly")
                case .failure(let error):
                    print("Error:\(error.localizedDescription)")
                    self.ResetPwdResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.ResetPwdResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    //topViewController?.showSnackAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }

}

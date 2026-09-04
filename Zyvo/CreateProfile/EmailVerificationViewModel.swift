//
//  EmailVerificationViewModel.swift
//  Zyvo
//
//  Created by ravi on 24/01/25.
//

import Combine
import Foundation

class EmailVerificationViewModel {
    
    @Published var email: String = ""
    @Published var Password: String = ""
   //@Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isSignUpValid: Bool = false
    @Published var emailVerificationResult:Result<BaseResponse<EmailVerificationModel>,Error>? = nil
    
    @Published var emailVerificationCodeSentResult:Result<BaseResponse<EmailUpdateVerificationModel>,Error>? = nil
   
    private var cancellables = Set<AnyCancellable>()
    init() {
        setupValidation()
    }
    private func setupValidation() {
        Publishers.CombineLatest( $email,$email)
            .map { email, newPassword in
                return self.validate( email: email)
            }
            .assign(to: \.isSignUpValid, on: self)
            .store(in: &cancellables)
    }
    private func validate( email: String) -> Bool {
       
        if email.isEmpty {
            errorMessage = "Email can’t be empty."
            return false
        }
        guard validateEmail(email) else{return false}
        
        errorMessage = nil
        return true
    }
    
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            errorMessage = "Email can't be empty."
            return false
        }  else if !email.isValidEmail() {
            errorMessage = "Please enter a valid email address."
            return false
        }
        errorMessage = "Password can't be empty."
        return true
    }
}
extension EmailVerificationViewModel {
    func apiforEmailVerification(){
        var para : [String:Any] = [:]
        para[APIKeys.email] = self.email
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        APIServices<EmailVerificationModel>().post(endpoint: .emailverification, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.emailVerificationResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.emailVerificationResult = .success(response)
                }else{
                    
                   // topViewController?.topmostViewController().showAlert(for: response.message ?? "")
                    topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

        }
    
    
    func apiforEmailUpdate(){
        var para : [String:Any] = [:]
        para[APIKeys.email] = self.email
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        APIServices<EmailUpdateVerificationModel>().post(endpoint: .updateemail, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.emailVerificationCodeSentResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.emailVerificationCodeSentResult = .success(response)
                }else{
                    
                   // topViewController?.topmostViewController().showAlert(for: response.message ?? "")
                    topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

        }
    
     }



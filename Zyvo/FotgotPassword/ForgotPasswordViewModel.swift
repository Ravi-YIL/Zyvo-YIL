//
//  ForgotPasswordViewModel.swift
//  Zyvo
//
//  Created by ravi on 23/01/25.
//

import Combine
import Foundation

class ForgotPasswordViewModel {
    
    @Published var newPassword: String = ""
    @Published var email: String = ""
    @Published var errorMessage: String?
    @Published var isForgetPasswordValid: Bool = false
    @Published var forgetPasswordResult:Result<BaseResponse<ForgotPasswordModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($email,$newPassword)
            .map { email, newPassword in
                return self.validate( email: email)
            }
            .assign(to: \.isForgetPasswordValid, on: self)
            .store(in: &cancellables)
    }
    
    
    private func validate(email: String) -> Bool {
        
        if email.isEmpty {
            errorMessage = "Please enter your email"
            return false
        }
        guard validateEmail(email) else{return false}
        errorMessage = nil
        return true
    }
    
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            errorMessage = "Email or phone can’t be empty."
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
       // errorMessage = "Password can't be empty."
        return true
    }
}

extension ForgotPasswordViewModel {
   
    func forgetPasswordApi(){
        var para : [String:Any] = [:]
        
        para[APIKeys.email] = self.email
       
        APIServices<ForgotPasswordModel>().post(endpoint: .forgetpassword, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                 
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.forgetPasswordResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
                    
            } receiveValue: { response in
                if response.success ?? false {
                    self.forgetPasswordResult = .success(response)
                    
                }else{
                    DispatchQueue.main.async {
                        topViewController?.showAlert(for: response.message ?? "")
                    }
                }
            }.store(in: &cancellables)

    }

}


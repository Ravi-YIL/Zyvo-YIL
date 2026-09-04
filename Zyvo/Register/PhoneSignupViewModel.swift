//
//  PhoneSignupViewModel.swift
//  Zyvo
//
//  Created by ravi on 21/01/25.
//

import Combine
import Foundation

class PhoneSignupViewModel {
    
    @Published var phone: String = ""
    @Published var countryCode: String = ""
    
    @Published var email: String = ""
    @Published var newPassword: String = ""
   // @Published var confirmPassword: String = ""
    @Published var errorMessage: String?
    @Published var isSignUpValid: Bool = false
    @Published var signUpResult:Result<BaseResponse<PhoneSignUpModel>,Error>? = nil
    
   // @Published var socialsignUpResult:Result<BaseResponse<SocialSignUpModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($phone, $countryCode)
            .map { phone, countryCode  in
                return self.validate(phone: phone, countryCode: countryCode)
            }
            .assign(to: \.isSignUpValid, on: self)
            .store(in: &cancellables)
    }
    
    
    private func validate(phone: String,countryCode: String) -> Bool {
        if phone.isEmpty {
            errorMessage = "Please enter your phone number."
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

extension PhoneSignupViewModel {
    func signUpPhoneApi(){
        var para : [String:Any] = [:]
        para[APIKeys.phonenumber] = self.phone
        para[APIKeys.countryCode] = self.countryCode
        APIServices<PhoneSignUpModel>().post(endpoint: .usersignupphone, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.signUpResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.signUpResult = .success(response)
                }else{
                    
                    topViewController?.topmostViewController().showAlert(for: response.message ?? "")
                   // topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
}


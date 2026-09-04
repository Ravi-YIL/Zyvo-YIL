//
//  PhoneVerificationViewModel_CreateProfile.swift
//  Zyvo
//
//  Created by ravi on 27/01/25.
//

import Combine
import Foundation

class PhoneVerificationViewModel_CreateProfile {
    
    @Published var phone: String = ""
    @Published var countryCode: String = ""
    @Published var errorMessage: String?
    @Published var isloginValid: Bool = false
    @Published var phoneverificationResult:Result<BaseResponse<PhoneVerificationModel_CreateProfile>,Error>? = nil
    
    @Published var updateMobileResult:Result<BaseResponse<UpdateMobileNumber>,Error>? = nil
    
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
            errorMessage = "Phone can't be empty."
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
            errorMessage = "Email can't be empty."
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
        errorMessage = "Password can't be empty."
        return true
    }
}

extension PhoneVerificationViewModel_CreateProfile {
    func apiForPhoneVerification(){
        var para : [String:Any] = [:]
        para[APIKeys.phonenumber] = self.phone
        para[APIKeys.countryCode] = self.countryCode
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<PhoneVerificationModel_CreateProfile>().post(endpoint: .phoneverification, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.phoneverificationResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.phoneverificationResult = .success(response)
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForPhoneUpdate(){
        var para : [String:Any] = [:]
        para[APIKeys.phonenumber] = self.phone
        para[APIKeys.countryCode] = self.countryCode
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<UpdateMobileNumber>().post(endpoint: .updatephonenumber, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.updateMobileResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.updateMobileResult = .success(response)
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
 
}


//
//  ContactUsViewModel.swift
//  Zyvo
//
//  Created by ravi on 31/01/25.
//

import Combine
import Foundation

class ContactUsViewModel {
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var Desc: String = ""
    @Published var errorMessage: String?
    @Published var isSignUpValid: Bool = false
    @Published var contactUsResult:Result<BaseResponse<EmptyModel>,Error>? = nil
   
    private var cancellables = Set<AnyCancellable>()
    init() {
        setupValidation()
    }
    private func setupValidation() {
        Publishers.CombineLatest3( $email, $name,$Desc)
            .map { email, name, Desc in
                return self.validate( email: email, name: name, Desc: Desc )
            }
            .assign(to: \.isSignUpValid, on: self)
            .store(in: &cancellables)
    }
    private func validate( email: String, name: String, Desc: String) -> Bool {
        
        if name.isEmpty {
            errorMessage = "Please enter your name"
            return false
        }
        if email.isEmpty {
            errorMessage = "Please enter your email"
            return false
        }
        guard validateEmail(email) else{return false}
        
        if Desc.isEmpty {
            errorMessage = "Please enter your message"
            return false
        }
        
        errorMessage = nil
        return true
    }
    
    func validateEmail(_ email: String) -> Bool {
        if email.isEmpty {
            errorMessage = "Plesae enter your email"
            return false
        } else if email.isNumeric {
            if !email.isValidPhone() {
                errorMessage = "Please enter a valid phone number."
                return false
            }
        } else if !email.isValidEmail() {
            errorMessage = "Please enter a valid email."
            return false
        }
        return true
    }
}

extension ContactUsViewModel {
    func apiforContactUs(){
        var para : [String:Any] = [:]
        para[APIKeys.email] = self.email
        para[APIKeys.name] = self.name
        para[APIKeys.message] = self.Desc
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        APIServices<EmptyModel>().post(endpoint: .contactus, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.contactUsResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.contactUsResult = .success(response)
                }else{
                     topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
}

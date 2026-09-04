//
//  UpdateNameViewModel.swift
//  Zyvo
//
//  Created by ravi on 23/01/25.
//

import Combine
import Foundation

class UpdateNameViewModel {
    @Published var userID: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var errorMessage: String?
    @Published var isNameValid: Bool = false
    @Published var updateNameResult:Result<BaseResponse<UpdateNameModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupValidation()
    }
    
    private func setupValidation() {
        Publishers.CombineLatest($firstName,$lastName)
            .map { fname, lname in
                return self.validate(fname: fname, lname: lname)
            }
            .assign(to: \.isNameValid, on: self)
            .store(in: &cancellables)
    }
    
    
    private func validate(fname: String,lname: String) -> Bool {
        
        if fname.isEmpty {
            errorMessage = "Please enter your first name."
            return false
        }
        if lname.isEmpty {
            errorMessage = "Please enter your last name."
            return false
        }
        
        errorMessage = nil
        return true
    }
    
    
}

extension UpdateNameViewModel {
    
    func apiForUpdateName(){
        var para : [String:Any] = [:]
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.firstname] = self.firstName
        para[APIKeys.lastname] = self.lastName
        
        APIServices<UpdateNameModel>().post(endpoint: .update_name, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                    
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.updateNameResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
                
            } receiveValue: { response in
                if response.success ?? false {
                    self.updateNameResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    
                }
            }.store(in: &cancellables)
    }
}


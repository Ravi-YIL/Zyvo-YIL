//
//  CreateWishListViewModel.swift
//  Zyvo
//
//  Created by ravi on 30/01/25.
//


import Combine
import Foundation
import UIKit

class CreateWishListViewModel:NSObject {
    @Published var errorMessage: String?
    @Published var profileImage: UIImage?
    @Published var name: String = ""
    @Published var Desc: String = ""
    
    var  propertyID = ""
    
    @Published var isValid: Bool = false
    
    @Published var createWishlistResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    //@Published var isPasswordValid: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
        self.setupValidation()
    }
    private func setupValidation() {
        Publishers.CombineLatest($name, $Desc)
            .map { name, Desc in
                print(name, Desc)
                return self.validate(name: name, desc: Desc)
            }.assign(to: \.isValid, on: self)
            .store(in: &cancellables)
    }
    
    private func validate(name: String, desc: String) -> Bool {
        if name.isEmpty {
            errorMessage = "Name can't be empty."
            return false
        }
        if desc.isEmpty {
            errorMessage = "Description can't be empty."
            return false
        }
        
        errorMessage = nil
        return true
    }
  
}

extension CreateWishListViewModel {
    
 
    func apiForCreateWishList(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.name] = self.name
        para[APIKeys.Desc] = self.Desc
        para[APIKeys.propertyid] = self.propertyID
        
       
        APIServices<EmptyModel>().post(endpoint: .create_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.createWishlistResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.createWishlistResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
}

//
//  AllGuidesViewModel.swift
//  Zyvo
//
//  Created by ravi on 7/02/25.
//

import Combine
import Foundation

class AllGuidesViewModel {
    @Published var userID: String = ""
    @Published var usertype: String = ""
 
    @Published var errorMessage: String?
    @Published var isNameValid: Bool = false
    
    @Published var getAllBrowseGuidesResult:Result<BaseResponse<[AllGuidesModel]>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
       
    }
    
}

extension AllGuidesViewModel {
   
    func apiForGetAllBrowseGuides(){
        var para : [String:Any] = [:]
        
//        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.usertype] = self.usertype
       
        APIServices<[AllGuidesModel]>().post(endpoint: .getAllGuides, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                 
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getAllBrowseGuidesResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
                    
            } receiveValue: { response in
                if response.success ?? false {
                    self.getAllBrowseGuidesResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    
                }
            }.store(in: &cancellables)
        }
    }




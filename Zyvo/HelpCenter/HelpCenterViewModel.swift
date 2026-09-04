//
//  HelpCenterViewModel.swift
//  Zyvo
//
//  Created by ravi on 6/02/25.
//

import Combine
import Foundation

class HelpCenterViewModel {
    @Published var userID: String = ""
    @Published var usertype: String = ""
 
    @Published var errorMessage: String?
    @Published var isNameValid: Bool = false
    
    @Published var getHelpCenterResult:Result<BaseResponse<HelpCenterModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
       
    }
    
}

extension HelpCenterViewModel {
   
    func apiForGetHelpCenter(){
        var para : [String:Any] = [:]
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.usertype] = self.usertype
       
        APIServices<HelpCenterModel>().post(endpoint: .gethelpcenter, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                 
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getHelpCenterResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
                    
            } receiveValue: { response in
                if response.success ?? false {
                    self.getHelpCenterResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    

}


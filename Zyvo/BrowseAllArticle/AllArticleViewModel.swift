//
//  AllArticleViewModel.swift
//  Zyvo
//
//  Created by ravi on 6/02/25.
//

import Combine
import Foundation

class AllArticleViewModel {
    @Published var userID: String = ""
    @Published var usertype: String = ""
 
    @Published var errorMessage: String?
    @Published var isNameValid: Bool = false
    
    @Published var getAllArticleResult:Result<BaseResponse<[AllArticleModel]>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
       
    }
    
}

extension AllArticleViewModel {
   
    func apiForGetAllArticle(){
        var para : [String:Any] = [:]
        
//        para[APIKeys.userID] = UserDetail.shared.getUserId()
//        para[APIKeys.usertype] = self.usertype
       
        APIServices<[AllArticleModel]>().post(endpoint: .getAllArticle, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                 
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getAllArticleResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
                    
            } receiveValue: { response in
                if response.success ?? false {
                    self.getAllArticleResult = .success(response)
                    
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                    //AlertControllerOnr(title: "Alert!", message: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    

}



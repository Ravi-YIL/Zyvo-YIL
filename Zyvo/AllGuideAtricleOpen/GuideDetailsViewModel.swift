//
//  GuideDetailsViewModel.swift
//  Zyvo
//
//  Created by ravi on 7/02/25.
//

import Combine
import Foundation

class GuideDetailsViewModel {
    @Published var guideId: String = ""
    @Published var usertype: String = ""
    
    @Published var articleId: String = ""
    
    
 
    @Published var errorMessage: String?
    @Published var isNameValid: Bool = false
    
    @Published var getGuideDetailsResult:Result<BaseResponse<GuideDetailsModel>,Error>? = nil
    
    @Published var getArticleDetailsResult:Result<BaseResponse<ArticleDetailsModel>,Error>? = nil
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
       
    }
    
}

extension GuideDetailsViewModel {
   
    func apiForGetGuidesDetails(){
        var para : [String:Any] = [:]
        
        para[APIKeys.guideId] = self.guideId
      
        APIServices<GuideDetailsModel>().post(endpoint: .getguidedetails, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getGuideDetailsResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getGuideDetailsResult = .success(response)
                }else{
                    self.getGuideDetailsResult = .success(response)
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForGetArticleDetails(){
        var para : [String:Any] = [:]
        
        para[APIKeys.article_id] = self.articleId
      
        APIServices<ArticleDetailsModel>().post(endpoint: .getarticledetails, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getArticleDetailsResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getArticleDetailsResult = .success(response)
                }else{
                    self.getArticleDetailsResult = .success(response)
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }

}



//
//  ListingDetailsViewModel.swift
//  Zyvo
//
//  Created by ravi on 24/04/2025.
//

import Combine
import Foundation
import UIKit

class ListingDetailsViewModel:NSObject {
   
    var latitude: String = ""
    var longitude: String = ""
   
    @Published var hostDetailsResult:Result<BaseResponse<ListingDetailsModel>,Error>? = nil
    
    @Published var getFilterDataResult:Result<BaseResponse<[FilterModel]>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
}

extension ListingDetailsViewModel {
    
    func apiForGetHostDetails(hostID : String){
        var para = [String:Any]()
        
        para[APIKeys.hostId] = hostID
        para[APIKeys.latitude] = self.latitude
        para[APIKeys.longitude] = self.longitude
       
        APIServices<ListingDetailsModel>().post(endpoint: .hostlisting, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.hostDetailsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.hostDetailsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForFilterData(hostID:String,filter:String,page:Int?){
        var para = [String:Any]()
        
        para[APIKeys.filter] = filter
        para[APIKeys.hostId] = hostID
        para[APIKeys.page] = page
        
        APIServices<[FilterModel]>().post(endpoint: .filter_host_reviews, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getFilterDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getFilterDataResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
}

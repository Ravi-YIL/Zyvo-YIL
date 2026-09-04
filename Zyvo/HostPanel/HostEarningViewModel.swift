//
//  HostEarningViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 14/02/25.
//

import Foundation
import Combine
import UIKit

class HostEarningViewModel :NSObject{
    
  
    @Published var getEarningsResult:Result<BaseResponse<HostEarningDataModel>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension HostEarningViewModel {
    
    func getHostEarning(type: String, hostID: String){
        var para = [String:Any]()
        para[APIKeys.type] = type
        para[APIKeys.hostId] = hostID
        APIServices<HostEarningDataModel>().post1(endpoint: .earnings, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getEarningsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getEarningsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

   
}

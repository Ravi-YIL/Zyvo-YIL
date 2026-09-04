//
//  getReportReasonViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 24/02/25.
//

import Foundation
import Combine
import UIKit

class getReportReasonViewModel :NSObject{
    
  
    @Published var ReportReasonResult:Result<BaseResponse<[ReportReasonDataModel]>,Error>? = nil
  
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension getReportReasonViewModel {
    
    func getReviewRasons(){
        var para = [String:Any]()
        
        APIServices<[ReportReasonDataModel]>().get(endpoint: .list_report_reasons, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                
                switch complition{
                case .finished :
                    print("Reports Reeason Get Successfully.....")
                case .failure(let error) :
                    self.ReportReasonResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.ReportReasonResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
        
    }
    
}

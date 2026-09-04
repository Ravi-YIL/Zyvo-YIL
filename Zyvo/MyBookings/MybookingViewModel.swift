//
//  MybookingViewModel.swift
//  Zyvo
//
//  Created by ravi on 12/02/25.
//

import Combine
import Foundation

class MybookingViewModel {
    @Published var guideId: String = ""
    @Published var usertype: String = ""
    
    @Published var articleId: String = ""
    
    
 
    @Published var errorMessage: String?
    @Published var isNameValid: Bool = false
    
    @Published var getBookingResult:Result<BaseResponse<[MyBookingModel]>,Error>? = nil
    
    @Published var deletebookingResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
       
    }
    
}

extension MybookingViewModel {
   
    func apiForGetMyBookings(bookingstatus:String){
        var para : [String:Any] = [:]
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.booking_status] = bookingstatus
      
        APIServices<[MyBookingModel]>().post(endpoint: .get_booking_list, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getBookingResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getBookingResult = .success(response)
                }else{
                    self.getBookingResult = .success(response)
                  //  topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForCancelBooking(booking_id : Int){
        var para : [String:Any] = [:]
        
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.bookingid] = booking_id
      
        APIServices<EmptyModel>().post(endpoint: .cancel_booking, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.deletebookingResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deletebookingResult = .success(response)
                }else{
                    self.deletebookingResult = .success(response)
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }

}



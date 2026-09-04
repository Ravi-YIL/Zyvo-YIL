//
//  BookingSlotsViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 26/02/25.
//

import Foundation
import Combine
import UIKit

class BookingSlotsViewModel :NSObject{
    
    @Published var getBookingsSlotsResult:Result<BaseResponse<DatewiseBookingDetailDataModel>,Error>? = nil
    @Published var pauseResumeBookingResult:Result<BaseResponse<PauseResumeDataModel>,Error>? = nil
  
    private var cancellables = Set<AnyCancellable>()
    
}
extension BookingSlotsViewModel {
    
    func apiforGetBookingsList(propertyID:Int,startDate:String, endDate: String, lat: Double, lot: Double){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyId] = propertyID
        para[APIKeys.latitude] = lat
        para[APIKeys.longitude] = lot
        para[APIKeys.start_date] = startDate
        para[APIKeys.end_date] = endDate
        APIServices<DatewiseBookingDetailDataModel>().post(endpoint: .property_booking_details, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getBookingsSlotsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getBookingsSlotsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }

    func apiforPauseResumeBooking(propertyID:Int){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyId] = propertyID
       
        APIServices<PauseResumeDataModel>().post(endpoint: .toggle_property_booking, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.pauseResumeBookingResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.pauseResumeBookingResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
}

//
//  BookingDetailViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 20/02/25.
//

import Foundation
import Combine
import UIKit

class BookingDetailViewModel :NSObject{
    
  
    @Published var getBookingResult:Result<BaseResponse<BookingDetailDataModel>,Error>? = nil
  
    @Published var getReviewsResult:Result<BaseResponse<[H_ReviewsDataModel]>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
}
extension BookingDetailViewModel {
    
    func HostGetBookingDetail(bookingId: Int,latitude: Double, longitude: Double, exteID: Int){
        var para = [String:Any]()
        para[APIKeys.bookingId] = bookingId
        para[APIKeys.latitude] = latitude
        para[APIKeys.longitude] = longitude
        if exteID == 0{
            para[APIKeys.extension_Id] = ""
        }else{
            para[APIKeys.extension_Id] = exteID
        }
        APIServices<BookingDetailDataModel>().post(endpoint: .host_booking_details, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getBookingResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getBookingResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

    func HostGetBookingReview(propertyId: Int,filter: String, page: Int){
        var para = [String:Any]()
        para[APIKeys.propertyId] = propertyId
        para[APIKeys.filter] = filter
        para[APIKeys.page] = page
        
        APIServices<[H_ReviewsDataModel]>().post(endpoint: .filter_property_reviews, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
        
                switch complition{
                case .finished :
                    print("Successfully fetched reviwes.....")
                case .failure(let error) :
                    self.getReviewsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getReviewsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)
    }

    
}


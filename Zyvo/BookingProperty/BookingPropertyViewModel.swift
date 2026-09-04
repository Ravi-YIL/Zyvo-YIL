//
//  BookingPropertyViewModel.swift
//  Zyvo
//
//  Created by ravi on 11/02/25.
//


import Combine
import Foundation

class BookingPropertyViewModel {
    
    
    @Published var property_id: String = ""
    @Published var booking_start: String = ""
    @Published var booking_end: String = ""
    
    @Published var cardID: String = ""
    
    
    @Published var service_fee: String = ""
    @Published var discount_amount: String = ""
    @Published var tax: String = ""
    @Published var customer_id: String = ""
    
    @Published var booking_date: String = ""
    @Published var booking_hours: Int = 0
    @Published var booking_amount: Double = 0.0
    @Published var total_amount: Double = 0.0
    @Published var apple_pay_token: String = ""
    
    // var apple_pay_token: [String: Any] = [:]
    
    
    @Published var setPreferredResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    @Published var getCardResult:Result<BaseResponse<SavedCardModelData>,Error>? = nil
    @Published var deleteSavedCardResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    @Published var bookingPropertyResult:Result<BaseResponse<BookingModel>,Error>? = nil
    
 
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
       
    }
    
}

extension BookingPropertyViewModel {
    func apiForBookingProperty(adsOns: [[String: Any]]){
        var para : [String:Any] = [:]
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = self.property_id
        para[APIKeys.booking_start] = self.booking_start
        para[APIKeys.booking_end] = self.booking_end
        para[APIKeys.booking_date] = self.booking_date
        para[APIKeys.booking_hours] = self.booking_hours
        para[APIKeys.booking_amount] = self.booking_amount
        para[APIKeys.total_amount] = self.total_amount
        para[APIKeys.addons] = adsOns
        para[APIKeys.cardID] = self.cardID
        
        para[APIKeys.service_fee] = self.service_fee
        para[APIKeys.discount_amount] = self.discount_amount
        para[APIKeys.tax] = self.tax
        
        para[APIKeys.customerid] = self.customer_id
        
        APIServices<BookingModel>().post(endpoint: .bookproperty, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.bookingPropertyResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.bookingPropertyResult = .success(response)
                }else{
                   // self.bookingPropertyResult = .success(response)
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    
    
    func apiForGetSavedCard(){
        var para : [String:Any] = [:]
        para[APIKeys.userID] = UserDetail.shared.getUserId()
     
        APIServices<SavedCardModelData>().post(endpoint: .getusercards, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("Request Completed")
                case .failure(let error):
                    self.getCardResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getCardResult = .success(response)
                }else{
                   // self.bookingPropertyResult = .success(response)
                    topViewController?.showAlert(for: response.message ?? "")
                    
                    
                }
            }.store(in: &cancellables)
    }
    
    func apiForSetPreferredCard(cardID : String){
           var para = [String:Any]()
           para[APIKeys.userID] = UserDetail.shared.getUserId()
            para[APIKeys.cardID] = cardID
           APIServices<EmptyModel>().post(endpoint: .setPreferredCard, parameters: para,loader: true)
               .receive(on: DispatchQueue.main)
               .sink { complition in
                   switch complition{
                   case .finished :
                       print("Successfully fetched.....")
                   case .failure(let error) :
                       self.setPreferredResult = .failure(error)
                   }
               } receiveValue: { response in
                   if response.success ?? false {
                       self.setPreferredResult = .success(response)
                   }else {
                       topViewController?.showAlert(for: response.message ?? "")
                   }
               }.store(in: &cancellables)
       }
    
    
    
    func apiForDeleteSavedCard(cardID : String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.payment_method_id] = cardID
        APIServices<EmptyModel>().post(endpoint: .deleteCardStripe, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deleteSavedCardResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deleteSavedCardResult = .success(response)
                   
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
       }
    
  

}


extension BookingPropertyViewModel {

    func apiForBookingPropertybyApplePay(
        adsOns: [[String: Any]],
        completion: @escaping (Bool, String) -> Void
    ) {

        var para: [String: Any] = [:]

        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = self.property_id
        para[APIKeys.booking_start] = self.booking_start
        para[APIKeys.booking_end] = self.booking_end
        para[APIKeys.booking_date] = self.booking_date
        para[APIKeys.booking_hours] = self.booking_hours
        para[APIKeys.booking_amount] = self.booking_amount
        para[APIKeys.total_amount] = self.total_amount
        para[APIKeys.addons] = adsOns
        para[APIKeys.cardID] = self.cardID
        para[APIKeys.apple_pay_token] = self.apple_pay_token
       
        para[APIKeys.service_fee] = self.service_fee
        para[APIKeys.discount_amount] = self.discount_amount
        para[APIKeys.tax] = self.tax

        para[APIKeys.customerid] = self.customer_id

        APIServices<BookingModel>()
            .post(endpoint: .bookproperty, parameters: para)
            .receive(on: DispatchQueue.main)
            .sink { complition in

                switch complition {

                case .finished:
                    print("Request Completed")

                case .failure(let error):

                    self.bookingPropertyResult = .failure(error)

                    print("Error: \(error.localizedDescription)")

                    completion(false, error.localizedDescription)
                }

            } receiveValue: { response in

                if response.success ?? false {

                    self.bookingPropertyResult = .success(response)

                    completion(true, response.message ?? "Success")

                } else {

                    topViewController?.showAlert(for: response.message ?? "")

                    completion(false, response.message ?? "Failed")
                }

            }.store(in: &cancellables)
    }
}

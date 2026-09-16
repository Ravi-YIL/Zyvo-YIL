//
//  BookingDetailsViewModel.swift
//  Zyvo
//
//  Created by ravi on 14/02/25.
//

import Combine
import Foundation
import UIKit

class BookingDetailsViewModel:NSObject {
    @Published var errorMessage: String?
   
    @Published var responseRate: Int = 0
    @Published var Communication: Int = 0
    @Published var onTime: Int = 0
    
    @Published var reviewMSG: String = ""
   
   
    @Published var isProfileValid: Bool = false
    
    @Published var bookingDetailsResult:Result<BaseResponse<BookingDetailsModel>,Error>? = nil
    
    @Published var cancelBookingResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var getJoinChannelResult:Result<BaseResponse<JoinChanelModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
   
 
}

extension BookingDetailsViewModel {
    
    func apiForGetPropertyDetails(bookingid:String,lat:String,long:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.bookingid] = bookingid
        para[APIKeys.latitude] = lat
        para[APIKeys.longitude] = long
       
        APIServices<BookingDetailsModel>().post(endpoint: .get_booking_details_list, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.bookingDetailsResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.bookingDetailsResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForJoinChannel(senderId:String,receiverId:String,groupChannel:String,userType:String, propertyId: String? = nil, propertyTitle: String? = nil){
        var para = [String:Any]()

        // Channel participants are persisted by role, regardless of which side
        // initiates the request: guest is sender and host is receiver.
        let isHostRequest = userType.trimmingCharacters(in: .whitespacesAndNewlines)
            .caseInsensitiveCompare("host") == .orderedSame
        para[APIKeys.senderId] = isHostRequest ? receiverId : senderId
        para[APIKeys.receiverId] = isHostRequest ? senderId : receiverId
        para[APIKeys.groupChannel] = groupChannel
        para[APIKeys.user_Type] = userType
        let explicitPropertyId = propertyId?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let resolvedPropertyId = explicitPropertyId.isEmpty
            ? ChatChannelName.propertyId(from: groupChannel)
            : explicitPropertyId
        if let resolvedPropertyId, !resolvedPropertyId.isEmpty {
            para[APIKeys.propertyid] = resolvedPropertyId
        }
        let resolvedPropertyTitle = propertyTitle?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !resolvedPropertyTitle.isEmpty {
            para[APIKeys.propertyTitle] = resolvedPropertyTitle
        }
        if let resolvedPropertyId, !resolvedPropertyId.isEmpty, !resolvedPropertyTitle.isEmpty {
            print("🏠 [ChatProperty] Saving visible title | channel=\(groupChannel) property_id=\(resolvedPropertyId) property_title=\(resolvedPropertyTitle)")
            QuickstartConversationsManager.shared.setChannelPropertyMetadata(
                channelName: groupChannel,
                propertyId: resolvedPropertyId,
                propertyTitle: resolvedPropertyTitle
            )
        }
       
        APIServices<JoinChanelModel>().post(endpoint: .joinchannel, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getJoinChannelResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getJoinChannelResult = .success(response)
                }else {
                    //self.getJoinChannelResult = .success(response)
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForCancelBooking(bookingid:String){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.bookingid] = bookingid
       
        APIServices<EmptyModel>().post(endpoint: .guestcancelbooking, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.cancelBookingResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.cancelBookingResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    

}

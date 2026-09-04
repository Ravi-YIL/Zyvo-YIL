//
//  WishlistDataViewModel.swift
//  Zyvo

//  Created by ravi on 3/02/25.

import Combine
import Foundation
import UIKit

class WishlistDataViewModel:NSObject {
    
    @Published var errorMessage: String?
    @Published var responseRate: Int = 0
    @Published var Communication: Int = 0
    @Published var onTime: Int = 0
    @Published var reviewMSG: String = ""
    var propertyID: String = ""
    var wishlistID: String = ""
    @Published var isProfileValid: Bool = false
    @Published var getWishListResult:Result<BaseResponse<[WishlistDataModel]>,Error>? = nil
    @Published var AddItemInWishlistResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    @Published var deleteWishlistResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    override init() {
        super.init()
      
    }
}

extension WishlistDataViewModel {
    func apiForGetCreatedWishList(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        APIServices<[WishlistDataModel]>().post(endpoint: .get_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getWishListResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getWishListResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForAddItemInWishlist(){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = self.propertyID
        para[APIKeys.wishlistid] = self.wishlistID
        APIServices<EmptyModel>().post(endpoint: .save_item_in_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.AddItemInWishlistResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.AddItemInWishlistResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForDeleteWishlist() {
        
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.wishlistid] = self.wishlistID
        APIServices<EmptyModel>().post(endpoint: .delete_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.deleteWishlistResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.deleteWishlistResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
}


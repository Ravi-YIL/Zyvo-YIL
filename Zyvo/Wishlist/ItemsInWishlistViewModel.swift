//
//  ItemsInWishlistViewModel.swift
//  Zyvo
//
//  Created by ravi on 4/02/25.
//

import Combine
import Foundation
import UIKit

class ItemsInWishlistViewModel:NSObject {
    @Published var errorMessage: String?
   
    @Published var responseRate: Int = 0
    @Published var Communication: Int = 0
    @Published var onTime: Int = 0
    
    @Published var reviewMSG: String = ""
    var propertyID: String = ""
    var wishlistID: String = ""
   
    
    @Published var isProfileValid: Bool = false
    
    
    @Published var getWishlistRemoveResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    @Published var ItemsInWishlistResult:Result<BaseResponse<[ItemsInWishlistModel]>,Error>? = nil
    
    @Published var RemoveItemsInWishlistResult:Result<BaseResponse<EmptyModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
   
 
}

extension ItemsInWishlistViewModel {
    
    func apiForGetItemsInWishList(){
        var para = [String:Any]()
        let lat = UserDetail.shared.getAppLatitude()
        let lng = UserDetail.shared.getAppLongitude()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.wishlistid] = self.wishlistID
        para[APIKeys.latitude] = lat
        para[APIKeys.longitude] = lng
        
        APIServices<[ItemsInWishlistModel]>().post(endpoint: .get_saved_item_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.ItemsInWishlistResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.ItemsInWishlistResult = .success(response)
                }else {
                    self.ItemsInWishlistResult = .success(response)
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                        let alert = UIAlertController(title: "", message: response.message ?? "", preferredStyle: .alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//
//                        if let topVC = UIApplication.shared.windows.first?.rootViewController?.topmostViewController(), topVC.view.window != nil {
//                            topVC.present(alert, animated: true, completion: nil)
//                        }
//                    }
                    
                   // topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiForRemoveItemFromWishlist(){
        var para = [String:Any]()
        
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = self.propertyID
       
        APIServices<EmptyModel>().post(endpoint: .remove_item_from_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.RemoveItemsInWishlistResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.RemoveItemsInWishlistResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    
    func apiforRemoveFromWishlist(propertyID:String){
        var para = [String:Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = propertyID
       
        APIServices<EmptyModel>().post(endpoint: .remove_item_from_wishlist, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getWishlistRemoveResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getWishlistRemoveResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)

    }
    
}


//
//  HomeDataViewModel.swift
//  Zyvo
//
//  Created by ravi on 30/01/25.
//

import Combine
import Foundation
import UIKit

class HomeDataViewModel: NSObject {
    
    // MARK: - Published Properties
    @Published var getHomeDataResult: Result<BaseResponse<[HomeDataModel]>, Error>? = nil
    @Published var getWishlistRemoveResult: Result<BaseResponse<EmptyModel>, Error>? = nil
    @Published var getUserBookingResult: Result<BaseResponse<UserBookingModel>, Error>? = nil
    @Published var chatTokenModelResult: Result<BaseResponse<chatTokenModel>, Error>? = nil
    
    // MARK: - Properties
    var latitude = ""
    var longitude = ""
    var datss = ""
    var start_time = ""
    var end_time = ""
    var activity = ""
    var locationss = ""
    var hourss = ""
    var property_price = ""
    var bookingDate = ""
    var bookingStart = ""
    
    private var cancellables = Set<AnyCancellable>()
}

// MARK: - API Calls
extension HomeDataViewModel {
    
    func apiforGetBookedPropertyTimer() {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.booking_date] = self.bookingDate
        para[APIKeys.booking_start] = self.bookingStart
        APIServices<UserBookingModel>().postWithoutAutherizationToken(endpoint: .getuserbookings, parameters: para, loader: false)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched BookedPropertyTimer.....")
                case .failure(let error):
                    self.getUserBookingResult = .failure(error)
                }
            } receiveValue: { [weak self] response in
                self?.getUserBookingResult = .success(response)
            }.store(in: &cancellables)
    }
    
    func apiforGetHomeDataWithoutLogin() {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        
        let (appLatitude, appLongitude) = getResolvedLocation()
        para[APIKeys.latitude] = appLatitude
        para[APIKeys.longitude] = appLongitude
        
        APIServices<[HomeDataModel]>().post(endpoint: .gethomedata, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched HomeDataWithoutLogin.....")
                case .failure(let error):
                    self.getHomeDataResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    HomeDataStore.shared.homeDataArr = response.data
                    HomeDataStore.shared.hasFetchedData = true
                    self.getHomeDataResult = .success(response)
                } else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
    func apiforGetChatToken(role: String) {
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.role] = role
        
        APIServices<chatTokenModel>().postWithoutAutherizationToken(endpoint: .chattoken, parameters: para, loader: false)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched ChatToken.....")
                case .failure(let error):
                    self.chatTokenModelResult = .failure(error)
                }
            } receiveValue: { [weak self] response in
                self?.chatTokenModelResult = .success(response)
            }.store(in: &cancellables)
    }
    
    private func getResolvedLocation() -> (lat: String, lng: String) {
        let devLat = UserDetail.shared.getDeviceLatitude()
        let devLng = UserDetail.shared.getDeviceLongitude()
        
        let currentLat = (!devLat.isEmpty && devLat != "0.0" && devLat != "0") ? devLat : UserDetail.shared.getAppLatitude()
        let currentLng = (!devLng.isEmpty && devLng != "0.0" && devLng != "0") ? devLng : UserDetail.shared.getAppLongitude()
        
        let whereLat = WhereSaveData.shared.lat.trimmingCharacters(in: .whitespacesAndNewlines)
        let whereLong = WhereSaveData.shared.long.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let filterLat = FilterSavedData.shared.latitude.trimmingCharacters(in: .whitespacesAndNewlines)
        let filterLong = FilterSavedData.shared.longitude.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var finalLat = currentLat
        var finalLng = currentLng
        
        if !whereLat.isEmpty && whereLat != "0.0" && whereLat != "0" && !whereLong.isEmpty && whereLong != "0.0" && whereLong != "0" {
            finalLat = whereLat
            finalLng = whereLong
        } else if !filterLat.isEmpty && filterLat != "0.0" && filterLat != "0" && !filterLong.isEmpty && filterLong != "0.0" && filterLong != "0" {
            finalLat = filterLat
            finalLng = filterLong
        } else if !latitude.isEmpty && latitude != "0.0" && latitude != "0" && !longitude.isEmpty && longitude != "0.0" && longitude != "0" {
            finalLat = latitude
            finalLng = longitude
        }
        
        return (finalLat, finalLng)
    }
    
    func apiforGetHomeData() {
        self.getHomeDataResult = nil
        var para = [String: Any]()
        
        let (appLatitude, appLongitude) = getResolvedLocation()
        
        UserDetail.shared.setAppLatitude(appLatitude)
        UserDetail.shared.setAppLongitude(appLongitude)
        
        print("appLatitude: \(appLatitude)")
        print("appLongitude: \(appLongitude)")
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.latitude] = appLatitude
        para[APIKeys.longitude] = appLongitude
        para[APIKeys.date] = self.datss
        para[APIKeys.hourss] = self.hourss
        para[APIKeys.starttime] = self.start_time
        para[APIKeys.endtime] = self.end_time
        para[APIKeys.location] = self.locationss
        
        if !self.locationss.isEmpty {
            para[APIKeys.location] = self.locationss
            para["is_location_filter_applied"] = true
        } else {
            para["is_location_filter_applied"] = false
        }
        
        para[APIKeys.property_price] = self.property_price
        
        if !activity.isEmpty {
            para[APIKeys.activitiesss] = activity
        }
        
        APIServices<[HomeDataModel]>().post(endpoint: .gethomedata, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully fetched HomeData.....")
                case .failure(let error):
                    self.getHomeDataResult = .failure(error)
                }
            } receiveValue: { [weak self] response in
                if response.success ?? false {
                    HomeDataStore.shared.homeDataArr = response.data
                    HomeDataStore.shared.hasFetchedData = true
                }
                self?.getHomeDataResult = .success(response)
            }.store(in: &cancellables)
        
    }
    
    func apiforRemoveFromWishlist(propertyID: String) {
        
        var para = [String: Any]()
        para[APIKeys.userID] = UserDetail.shared.getUserId()
        para[APIKeys.propertyid] = propertyID
        
        APIServices<EmptyModel>().post(endpoint: .remove_item_from_wishlist, parameters: para, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Successfully removed from Wishlist.....")
                case .failure(let error):
                    self.getWishlistRemoveResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getWishlistRemoveResult = .success(response)
                } else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }
    
}




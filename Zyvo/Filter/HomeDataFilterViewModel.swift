//
//  HomeDataFilterViewModel.swift
//  Zyvo
//
//  Created by ravi on 6/03/25.
//

import Combine
import Foundation
import UIKit

class HomeDataFilterViewModel:NSObject {
   
    @Published  var allowsPets: String = ""
    @Published  var selfCheckIn: String = ""
    @Published  var activities: [String] = []
    @Published  var language: [String] = []
    @Published  var amenities: [String] = []
    @Published var instantbooking: String = ""
    @Published var bathroom: String = ""
    @Published var bedroom: String = ""
    @Published var propertysize: String = ""
    @Published var peoplecount: String = ""
    @Published var timess: String = ""
    @Published var datess: String = ""
    @Published var locationss: String = ""
    @Published  var maximumprice: String = ""
    @Published var minimumprice: String = ""
    @Published var placetype: String = ""
    
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    
    
    
    @Published var isProfileValid: Bool = false
    
    @Published var getDataHomeFilterResult:Result<BaseResponse<[HomeDataModel]>,Error>? = nil
    
    @Published var minMaxResult:Result<BaseResponse<MinMaxRangeModel>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
      
    }
   
 
}

extension HomeDataFilterViewModel {
//    
//    func apiForFilterHomeData(){
//        var para = [String:Any]()
//       
//        para[APIKeys.userID] = UserDetail.shared.getUserId()
//        para[APIKeys.placetype] = self.placetype
//        para[APIKeys.minimumprice] = self.minimumprice
//        para[APIKeys.maximumprice] = self.maximumprice
//        para[APIKeys.location] = self.locationss
//        para[APIKeys.date] = self.datess
//        para[APIKeys.time] =  self.timess
//        para[APIKeys.peoplecount] = self.peoplecount
//        para[APIKeys.propertysize] = self.propertysize
//        para[APIKeys.bedroom] = self.bedroom
//        para[APIKeys.bathroom] = self.bathroom
//        para[APIKeys.instantbooking] = self.instantbooking
//      //  para[APIKeys.amenities] = self.amenities
//      //  para[APIKeys.activities] = self.activities
//        para[APIKeys.selfCheckIn] = self.selfCheckIn
//        para[APIKeys.allowsPets] = self.allowsPets
//       // para[APIKeys.languages] = self.language
//        para[APIKeys.latitude] = self.latitude
//        para[APIKeys.longitude] = self.longitude
//        
//        if !amenities.isEmpty {
//            para[APIKeys.amenities] = amenities
//        }
//
//        if !activities.isEmpty {
//            para[APIKeys.activities] = activities
//        }
//
//        if !language.isEmpty {
//            para[APIKeys.languages] = language
//        }
//       
//        APIServices<[HomeDataModel]>().postwithou(endpoint: .set_home_data_filter, parameters: para,loader: true)
//            .receive(on: DispatchQueue.main)
//            .sink { complition in
//                switch complition{
//                case .finished :
//                    print("Successfully fetched.....")
//                case .failure(let error) :
//                    self.getDataHomeFilterResult = .failure(error)
//                }
//            } receiveValue: { response in
//                if response.success ?? false {
//                    self.getDataHomeFilterResult = .success(response)
//                }else {
//                    self.getDataHomeFilterResult = .success(response)
//                    //topViewController?.showAlert(for: response.message ?? "")
//                }
//            }.store(in: &cancellables)
//    }
    
    func apiForFilterHomeData() {

        var para = [String: Any]()

        func addIfNotEmpty(_ key: String, _ value: Any?) {
            guard let value = value else { return }

            if let str = value as? String, !str.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                para[key] = str
            } else if let arr = value as? [Any], !arr.isEmpty {
                para[key] = arr
            } else if !(value is String) && !(value is [Any]) {
                para[key] = value
            }
        }

        addIfNotEmpty(APIKeys.userID, UserDetail.shared.getUserId())
        addIfNotEmpty(APIKeys.placetype, placetype)
        addIfNotEmpty(APIKeys.minimumprice, minimumprice)
        addIfNotEmpty(APIKeys.maximumprice, maximumprice)
        addIfNotEmpty(APIKeys.location, locationss)
        addIfNotEmpty(APIKeys.date, datess)
        addIfNotEmpty(APIKeys.time, timess)
        addIfNotEmpty(APIKeys.peoplecount, peoplecount)
        addIfNotEmpty(APIKeys.propertysize, propertysize)
        addIfNotEmpty(APIKeys.bedroom, bedroom)
        addIfNotEmpty(APIKeys.bathroom, bathroom)
        addIfNotEmpty(APIKeys.instantbooking, instantbooking)
        addIfNotEmpty(APIKeys.selfCheckIn, selfCheckIn)
        addIfNotEmpty(APIKeys.allowsPets, allowsPets)
        addIfNotEmpty(APIKeys.latitude, latitude)
        addIfNotEmpty(APIKeys.longitude, longitude)

        addIfNotEmpty(APIKeys.amenitiesss, amenities)
        addIfNotEmpty(APIKeys.activitiesss, activities)
        addIfNotEmpty(APIKeys.languagesss, language)

        APIServices<[HomeDataModel]>()
            .postwithou(
                endpoint: .set_home_data_filter,
                parameters: para,
                loader: true
            )
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    
                    print("Successfully fetched.....")

                case .failure(let error):
                    self.getDataHomeFilterResult = .failure(error)
                }
            } receiveValue: { response in
                self.getDataHomeFilterResult = .success(response)
            }
            .store(in: &cancellables)
    }
    
    func apiforMinMaxRange() {
        var para = [String:Any]()
        //para[APIKeys.id] = UserDetail.shared.getUserId()
        APIServices<MinMaxRangeModel>().get(endpoint: .get_property_price_range, parameters: para,loader: false)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    
                    print("Successfully fetched.....")
                    
                case .failure(let error) :
                    self.minMaxResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    
                    self.minMaxResult = .success(response)
                    
                }else {
                    
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
}


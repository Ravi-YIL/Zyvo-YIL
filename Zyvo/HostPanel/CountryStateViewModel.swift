//
//  CountryStateViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 05/03/25.
//

import Foundation
import Combine
import UIKit

class CountryStateViewModel :NSObject{
    
  
    @Published var getCountryStateCityResult:Result<BaseResponse<[CountryStateCityDataModel]>,Error>? = nil
    @Published var getStateCityResult:Result<BaseResponse<[CountryStateCityDataModel]>,Error>? = nil
    @Published var getCityResult:Result<BaseResponse<[CountryStateCityDataModel]>,Error>? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
}
extension CountryStateViewModel {
    
    func GetCountryStateCityApi(){
        var para = [String:Any]()
        
        APIServices<[CountryStateCityDataModel]>().get(endpoint: .get_countries, parameters: para,loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getCountryStateCityResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getCountryStateCityResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                }
            }.store(in: &cancellables)
    }

    func GetStateCityApi(countryCode:String){
        var para = [String:Any]()
           let endpointString = "\(AppURL.Endpoint.get_states.path)/\(countryCode)"
           
           // Convert it back to `AppURL.Endpoint`, providing a default value if it fails
           let endpoint = AppURL.Endpoint(rawValue: endpointString) ?? .get_states
        
        APIServices<[CountryStateCityDataModel]>().get(endpoint: endpoint, parameters: para, loader: true,costumUrl: endpointString)
                .receive(on: DispatchQueue.main)
                .sink { completion in
        
                switch completion{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getStateCityResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getStateCityResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }

    func GetCityApi(countryCode:String,stateCode:String){
        var para = [String:Any]()
        
//        let endpoint = "\(AppURL.Endpoint.get_countries.rawValue)/\(countryCode)"
        
        // Construct the full endpoint as a string
           let endpointString = "\(AppURL.Endpoint.get_cities.path)/\(countryCode)/\(stateCode)"
           
           // Convert it back to `AppURL.Endpoint`, providing a default value if it fails
           let endpoint = AppURL.Endpoint(rawValue: endpointString) ?? .get_cities
        
        APIServices<[CountryStateCityDataModel]>().get(endpoint: endpoint, parameters: para, loader: true,costumUrl: endpointString)
                .receive(on: DispatchQueue.main)
                .sink { completion in
        
                switch completion{
                case .finished :
                    print("Successfully fetched.....")
                case .failure(let error) :
                    self.getCityResult = .failure(error)
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.getCityResult = .success(response)
                }else {
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)

    }
    
   
}


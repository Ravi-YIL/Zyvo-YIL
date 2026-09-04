//
//  UpdatePropertyViewModel.swift
//  Zyvo
//
//  Created by YATIN  KALRA on 13/02/25.
//

import Foundation
import Combine

class UpdatePropertyViewModel {
    
    //    @Published var phone: String = ""
    //    @Published var countryCode: String = ""
    //    @Published var errorMessage: String?
    //    @Published var isloginValid: Bool = false
    @Published var UpdatePlaceResult:Result<BaseResponse<PlaceMngmt_Model>,Error>? = nil
    
    // @Published var socialsignUpResult:Result<BaseResponse<SocialSignUpModel>,Error>? = nil
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        
    }
    
    
}

extension UpdatePropertyViewModel {
    func UpdateApi(PropertyID: Int){
        
        var dict = [String:[String:Any]]()
        var imageDict: [String] = []
        var i = 0
        
        for img in SingltonClass.shared.Imgs {
            if img.image_id == ""{
                if let data = img.image.jpegData(compressionQuality: 0.5) {
                    let data = data.base64EncodedString()
                    imageDict.append(data)
                }
                i += 1
            }
        }
        let joinedActivities = SingltonClass.shared.activies + SingltonClass.shared.other_Activities
        let FromTime =  SingltonClass.shared.avilabilityHrsFrom ?? ""
        let ToTime =  SingltonClass.shared.avilabilityHrsTo ?? ""
        
        let propertyData = UpdatePropertyData(
            propertyId: PropertyID,
            space_type: SingltonClass.shared.typeOfSpace,
            property_size: Int(SingltonClass.shared.propertySize) ?? 0,
            maxGuestCount: Int(SingltonClass.shared.no_Of_Ppl) ?? 0,
            bedroomCount: Int(SingltonClass.shared.bedrooms) ?? 0,
            bathroomCount: Int(SingltonClass.shared.bathrooms) ?? 0,
            isInstantBook: Int(SingltonClass.shared.instantBooking) ?? 0,
            hasSelfCheckin: Int(SingltonClass.shared.selfCheck_in) ?? 0,
            allowsPets: Int(SingltonClass.shared.allowPets) ?? 0,
            cancellationDuration: Int(SingltonClass.shared.cancellationDays ?? "0") ?? 0,
            title: SingltonClass.shared.title ?? "",
            description: SingltonClass.shared.about ?? "",
            parkingRules: SingltonClass.shared.parkingRule ?? "",
            hostRules: SingltonClass.shared.hostRules ?? "",
            streetAddress: SingltonClass.shared.street ?? "",
            city: SingltonClass.shared.city ?? "",
            zipCode: SingltonClass.shared.zipcode ?? "",
            country: SingltonClass.shared.country ?? "",
            state: SingltonClass.shared.state ?? "",
            latitude: SingltonClass.shared.latitude ?? 0.0,
            longitude: SingltonClass.shared.longitude ?? 0.0,
            minBookingHours: Int(Double(SingltonClass.shared.miniHrsPric_HrsMini) ?? 0.0),
            hourlyRate: Int(Double(SingltonClass.shared.miniHrsPric_perHrs) ?? 0.0),
            bulkDiscountHour: Int(SingltonClass.shared.bulkDis_HrsMini) ?? 0,
            bulkDiscountRate: Int(Double(SingltonClass.shared.bulkDis_Discount) ?? 0.0),
            cleaningFee: Int(Double(SingltonClass.shared.addCleaningFees ?? "") ?? 0.0),
            availableMonth: SingltonClass.shared.avilabilityMonth.joined(separator: ","),
            availableDay: SingltonClass.shared.avilabilityDays,
            availableFrom: formatTime(FromTime),
            available_to: formatTime(ToTime),
            images: imageDict,
            activities: joinedActivities,
            amenities: SingltonClass.shared.aminities,
            addOns: SingltonClass.shared.addOns,
            deleteImages:SingltonClass.shared.deletedImg)
        APIServices<PlaceMngmt_Model>().putModel(endpoint: .update_property_details, parameters: propertyData, loader: true)
            .receive(on: DispatchQueue.main)
            .sink { complition in
                switch complition {
                case .finished:
                    print("property created successfully")
                case .failure(let error):
                    self.UpdatePlaceResult = .failure(error)
                    print("Error: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                if response.success ?? false {
                    self.UpdatePlaceResult = .success(response)
                }else{
                    topViewController?.showAlert(for: response.message ?? "")
                    
                }
            }.store(in: &cancellables)
    }
    
    
    func formatTime(_ time: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "HH:mm:ss"  // Expecting 24-hour format with seconds
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "HH:mm"  // 24-hour format without seconds
        
        if let date = inputFormatter.date(from: time) {
            return outputFormatter.string(from: date)
        } else {
            return time // Return original if conversion fails
        }
    }
    
}

